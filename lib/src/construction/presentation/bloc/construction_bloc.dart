import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/construction/data/model/create_construction_site_request_model.dart';
import 'package:manshan/src/construction/data/model/create_employee_site_assignment_request_model.dart';
import 'package:manshan/src/construction/data/model/create_site_entry_request_model.dart';
import 'package:manshan/src/construction/domain/entity/paginated_construction_site.dart';
import 'package:manshan/src/construction/domain/entity/paginated_employee_site_assignment.dart';
import 'package:manshan/src/construction/domain/entity/paginated_site_entry.dart';
import 'package:manshan/src/construction/domain/usecase/all_constuction_usecase.dart';
import 'package:manshan/src/construction/domain/usecase/create_construction_usecase.dart';
import 'package:manshan/src/construction/domain/usecase/create_employee_site_assignment_usecase.dart';
import 'package:manshan/src/construction/domain/usecase/create_site_entry_usecase.dart';
import 'package:manshan/src/construction/domain/usecase/get_site_assignment_usecase.dart';
import 'package:manshan/src/construction/domain/usecase/get_site_entries_usecase.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_event.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_state.dart';

class ConstructionBloc extends Bloc<ConstructionEvent, ConstructionState> {
  final AllConstructionSitesUsecase allConstructionSitesUsecase;
  final CreateConstructionSiteUsecase createConstructionSiteUsecase;
  final CreateEmployeeSiteAssignmentUsecase createEmployeeSiteAssignmentUsecase;
  final CreateSiteEntryUsecase createSiteEntryUsecase;
  final GetSiteAssignmentsUsecase getSiteAssignmentsUsecase;
  final GetSiteEntriesUsecase getSiteEntriesUsecase;

  int _currentPage = 1;
  static const int _limit = 10;
  bool _isFetching = false;

  int _assignmentsPage = 1;
  bool _isFetchingAssignments = false;

  int _entriesPage = 1;
  bool _isFetchingEntries = false;

  ConstructionBloc({
    required this.allConstructionSitesUsecase,
    required this.createConstructionSiteUsecase,
    required this.createEmployeeSiteAssignmentUsecase,
    required this.createSiteEntryUsecase,
    required this.getSiteAssignmentsUsecase,
    required this.getSiteEntriesUsecase,
  }) : super(ConstructionState.initial()) {
    on<GetAllConstructionSitesRequestEvent>(_onGetAll);
    on<LoadMoreConstructionSitesEvent>(_onLoadMore);
    on<CreateConstructionSiteRequestEvent>(_onCreateSite);
    on<CreateEmployeeSiteAssignmentRequestEvent>(_onCreateAssignment);
    on<CreateSiteEntryRequestEvent>(_onCreateEntry);
    on<GetSiteAssignmentsRequestEvent>(_onGetAssignments);
    on<LoadMoreSiteAssignmentsEvent>(_onLoadMoreAssignments);
    on<GetSiteEntriesRequestEvent>(_onGetEntries);
    on<LoadMoreSiteEntriesEvent>(_onLoadMoreEntries);
  }

  Future<void> _onGetAll(
    GetAllConstructionSitesRequestEvent event,
    Emitter<ConstructionState> emit,
  ) async {
    _currentPage = 1;
    _isFetching = false;
    emit(state.copyWith(siteStatus: EmployeeStatus.loading));
    final result = await allConstructionSitesUsecase(
      ConstructionSiteParams(page: _currentPage, limit: _limit),
    );
    result.fold(
      (f) => emit(state.copyWith(
          siteStatus: EmployeeStatus.failure, errorMessage: f.message)),
      (r) => emit(state.copyWith(
        siteStatus: EmployeeStatus.success,
        allSites: r.data,
        hasMore: (r.data?.data.length ?? 0) >= _limit,
      )),
    );
  }

  Future<void> _onLoadMore(
    LoadMoreConstructionSitesEvent event,
    Emitter<ConstructionState> emit,
  ) async {
    if (_isFetching || !state.hasMore) return;
    _isFetching = true;
    emit(state.copyWith(paginationStatus: EmployeeStatus.loading));
    _currentPage++;
    final result = await allConstructionSitesUsecase(
      ConstructionSiteParams(page: _currentPage, limit: _limit),
    );
    result.fold(
      (f) {
        _currentPage--;
        emit(state.copyWith(paginationStatus: EmployeeStatus.failure));
      },
      (r) {
        final newData = r.data?.data ?? [];
        final merged = PaginatedConstructionSite(
          data: [...state.allSites.data, ...newData],
          total: r.data?.total ?? state.allSites.total,
          page: r.data?.page ?? _currentPage,
          limit: r.data?.limit ?? _limit,
        );
        emit(state.copyWith(
          paginationStatus: EmployeeStatus.success,
          allSites: merged,
          hasMore: newData.length >= _limit,
        ));
      },
    );
    _isFetching = false;
  }

  Future<void> _onCreateSite(
    CreateConstructionSiteRequestEvent event,
    Emitter<ConstructionState> emit,
  ) async {
    emit(state.copyWith(createSiteStatus: EmployeeStatus.loading));
    final result = await createConstructionSiteUsecase(
      request: CreateConstructionSiteRequestModel(
        siteName: event.siteName,
        location: event.location,
        clientName: event.clientName,
        startDate: event.startDate,
        endDate: event.endDate,
        status: event.status,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(
          createSiteStatus: EmployeeStatus.failure, errorMessage: f.message)),
      (r) => emit(state.copyWith(
          createSiteStatus: EmployeeStatus.success, message: r.message)),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    emit(state.copyWith(createSiteStatus: EmployeeStatus.initial));
  }

  Future<void> _onCreateAssignment(
    CreateEmployeeSiteAssignmentRequestEvent event,
    Emitter<ConstructionState> emit,
  ) async {
    emit(state.copyWith(assignmentStatus: EmployeeStatus.loading));
    final result = await createEmployeeSiteAssignmentUsecase(
      request: CreateEmployeeSiteAssignmentRequestModel(
        employeeId: event.employeeId,
        constructionSiteId: event.constructionSiteId,
        fromDate: event.fromDate,
        toDate: event.toDate,
        workType: event.workType,
        notes: event.notes,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(
          assignmentStatus: EmployeeStatus.failure, errorMessage: f.message)),
      (r) => emit(state.copyWith(
          assignmentStatus: EmployeeStatus.success, message: r.message)),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    emit(state.copyWith(assignmentStatus: EmployeeStatus.initial));
  }

  Future<void> _onCreateEntry(
    CreateSiteEntryRequestEvent event,
    Emitter<ConstructionState> emit,
  ) async {
    emit(state.copyWith(entryStatus: EmployeeStatus.loading));
    final result = await createSiteEntryUsecase(
      request: CreateSiteEntryRequestModel(
        constructionSiteId: event.constructionSiteId,
        expenseType: event.expenseType,
        itemName: event.itemName,
        quantity: event.quantity,
        unit: event.unit,
        pricePerUnit: event.pricePerUnit,
        purchaseDate: event.purchaseDate,
        vendorName: event.vendorName,
        notes: event.notes,
      ),
    );
    result.fold(
      (f) => emit(state.copyWith(
          entryStatus: EmployeeStatus.failure, errorMessage: f.message)),
      (r) => emit(state.copyWith(
          entryStatus: EmployeeStatus.success, message: r.message)),
    );
    await Future.delayed(const Duration(milliseconds: 100));
    emit(state.copyWith(entryStatus: EmployeeStatus.initial));
  }

  // ── Detail: assignments ──────────────────────────────────────────────────

  Future<void> _onGetAssignments(
    GetSiteAssignmentsRequestEvent event,
    Emitter<ConstructionState> emit,
  ) async {
    _assignmentsPage = 1;
    _isFetchingAssignments = false;
    emit(state.copyWith(
      assignmentsLoadStatus: EmployeeStatus.loading,
      siteAssignments: PaginatedEmployeeSiteAssignment.initial(),
    ));
    final result = await getSiteAssignmentsUsecase(
      SiteAssignmentParams(
          siteId: event.siteId, page: _assignmentsPage, limit: _limit),
    );
    result.fold(
      (f) => emit(state.copyWith(
          assignmentsLoadStatus: EmployeeStatus.failure,
          errorMessage: f.message)),
      (r) => emit(state.copyWith(
        assignmentsLoadStatus: EmployeeStatus.success,
        siteAssignments: r.data,
        hasMoreAssignments: (r.data?.data.length ?? 0) >= _limit,
      )),
    );
  }

  Future<void> _onLoadMoreAssignments(
    LoadMoreSiteAssignmentsEvent event,
    Emitter<ConstructionState> emit,
  ) async {
    if (_isFetchingAssignments || !state.hasMoreAssignments) return;
    _isFetchingAssignments = true;
    emit(state.copyWith(
        assignmentsPaginationStatus: EmployeeStatus.loading));
    _assignmentsPage++;
    final result = await getSiteAssignmentsUsecase(
      SiteAssignmentParams(
          siteId: event.siteId, page: _assignmentsPage, limit: _limit),
    );
    result.fold(
      (f) {
        _assignmentsPage--;
        emit(state.copyWith(
            assignmentsPaginationStatus: EmployeeStatus.failure));
      },
      (r) {
        final newData = r.data?.data ?? [];
        final merged = PaginatedEmployeeSiteAssignment(
          data: [...state.siteAssignments.data, ...newData],
          total: r.data?.total ?? state.siteAssignments.total,
          page: r.data?.page ?? _assignmentsPage,
          limit: r.data?.limit ?? _limit,
        );
        emit(state.copyWith(
          assignmentsPaginationStatus: EmployeeStatus.success,
          siteAssignments: merged,
          hasMoreAssignments: newData.length >= _limit,
        ));
      },
    );
    _isFetchingAssignments = false;
  }

  // ── Detail: entries ──────────────────────────────────────────────────────

  Future<void> _onGetEntries(
    GetSiteEntriesRequestEvent event,
    Emitter<ConstructionState> emit,
  ) async {
    _entriesPage = 1;
    _isFetchingEntries = false;
    emit(state.copyWith(
      entriesLoadStatus: EmployeeStatus.loading,
      siteEntries: PaginatedSiteEntry.initial(),
    ));
    final result = await getSiteEntriesUsecase(
      SiteEntryParams(
          siteId: event.siteId, page: _entriesPage, limit: _limit),
    );
    debugPrint("Get Site Entires");
    result.fold(
      (f) => emit(state.copyWith(
          entriesLoadStatus: EmployeeStatus.failure,
          errorMessage: f.message)),
      (r) => emit(state.copyWith(
        entriesLoadStatus: EmployeeStatus.success,
        siteEntries: r.data,
        hasMoreEntries: (r.data?.data.length ?? 0) >= _limit,
      )),
    );
  }

  Future<void> _onLoadMoreEntries(
    LoadMoreSiteEntriesEvent event,
    Emitter<ConstructionState> emit,
  ) async {
    if (_isFetchingEntries || !state.hasMoreEntries) return;
    _isFetchingEntries = true;
    emit(state.copyWith(entriesPaginationStatus: EmployeeStatus.loading));
    _entriesPage++;
    final result = await getSiteEntriesUsecase(
      SiteEntryParams(
          siteId: event.siteId, page: _entriesPage, limit: _limit),
    );
    result.fold(
      (f) {
        _entriesPage--;
        emit(state.copyWith(
            entriesPaginationStatus: EmployeeStatus.failure));
      },
      (r) {
        final newData = r.data?.data ?? [];
        final merged = PaginatedSiteEntry(
          data: [...state.siteEntries.data, ...newData],
          total: r.data?.total ?? state.siteEntries.total,
          page: r.data?.page ?? _entriesPage,
          limit: r.data?.limit ?? _limit,
        );
        emit(state.copyWith(
          entriesPaginationStatus: EmployeeStatus.success,
          siteEntries: merged,
          hasMoreEntries: newData.length >= _limit,
        ));
      },
    );
    _isFetchingEntries = false;
  }
}