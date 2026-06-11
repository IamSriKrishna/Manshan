import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/employee/domain/entity/employee.dart';
import 'package:manshan/src/salary/data/model/create_bulk_salary_request_model.dart';
import 'package:manshan/src/salary/domain/entity/paginated_salary_transaction.dart';
import 'package:manshan/src/salary/domain/usecase/salary_usecases.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_event.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_state.dart';

class SalaryBloc extends Bloc<SalaryEvent, SalaryState> {
  final GetAllEmployeesForSalaryUsecase getEmployeesUsecase;
  final CreateBulkSalaryUsecase createBulkSalaryUsecase;
  final GetTransactionHistoryUsecase getTransactionHistoryUsecase;

  static const int _limit = 20;
  int _historyPage = 1;
  bool _isFetchingHistory = false;

  SalaryBloc({
    required this.getEmployeesUsecase,
    required this.createBulkSalaryUsecase,
    required this.getTransactionHistoryUsecase,
  }) : super(SalaryState.initial()) {
    on<LoadEmployeesEvent>(_onLoadEmployees);
    on<ToggleEmployeeSelectionEvent>(_onToggleEmployee);
    on<AppendDigitEvent>(_onAppendDigit);
    on<DeleteDigitEvent>(_onDeleteDigit);
    on<ClearAmountEvent>(_onClearAmount);
    on<UpdatePaymentModeEvent>(_onUpdatePaymentMode);
    on<UpdateSalaryTypeEvent>(_onUpdateSalaryType);
    on<SubmitBulkSalaryEvent>(_onSubmit);
    on<LoadTransactionHistoryEvent>(_onLoadHistory);
    on<LoadMoreTransactionHistoryEvent>(_onLoadMoreHistory);

  on<UpdateDateRangeEvent>(_onUpdateDateRange);
  }

  Future<void> _onLoadEmployees(
    LoadEmployeesEvent event,
    Emitter<SalaryState> emit,
  ) async {
    emit(state.copyWith(employeeLoadStatus: EmployeeStatus.loading));
    final result = await getEmployeesUsecase(page: 1, limit: 50);
    result.fold(
      (f) => emit(state.copyWith(employeeLoadStatus: EmployeeStatus.failure)),
      (r) => emit(
        state.copyWith(
          employeeLoadStatus: EmployeeStatus.success,
          employees: r.data,
        ),
      ),
    );
  }

void _onUpdateDateRange(
  UpdateDateRangeEvent event,
  Emitter<SalaryState> emit,
) {
  emit(state.copyWith(fromDate: event.fromDate, toDate: event.toDate));
}

  void _onToggleEmployee(
    ToggleEmployeeSelectionEvent event,
    Emitter<SalaryState> emit,
  ) {
    final current = List<Employee>.from(state.selectedEmployees);
    final exists = current.any((e) => e.id == event.employee.id);
    if (exists) {
      current.removeWhere((e) => e.id == event.employee.id);
    } else {
      current.add(event.employee);
    }
    emit(state.copyWith(selectedEmployees: current));
  }

  void _onAppendDigit(AppendDigitEvent event, Emitter<SalaryState> emit) {
    final current = state.amount;
    if (event.digit == "." && current.contains(".")) return;
    if (event.digit == "." && current.isEmpty) {
      emit(state.copyWith(amount: "0."));
      return;
    }
    final parts = current.split(".");
    if (parts.length == 2 && parts[1].length >= 2) return;
    if (current == "0" && event.digit != ".") {
      emit(state.copyWith(amount: event.digit));
      return;
    }
    emit(state.copyWith(amount: current + event.digit));
  }

  void _onDeleteDigit(DeleteDigitEvent event, Emitter<SalaryState> emit) {
    final current = state.amount;
    if (current.isEmpty) return;
    emit(state.copyWith(amount: current.substring(0, current.length - 1)));
  }

  void _onClearAmount(ClearAmountEvent event, Emitter<SalaryState> emit) {
    emit(state.copyWith(amount: ""));
  }

  void _onUpdatePaymentMode(
    UpdatePaymentModeEvent event,
    Emitter<SalaryState> emit,
  ) {
    emit(state.copyWith(paymentMode: event.mode));
  }

  void _onUpdateSalaryType(
    UpdateSalaryTypeEvent event,
    Emitter<SalaryState> emit,
  ) {
    emit(state.copyWith(salaryType: event.salaryType));
  }

  Future<void> _onSubmit(
  SubmitBulkSalaryEvent event,
  Emitter<SalaryState> emit,
) async {
  if (state.selectedEmployees.isEmpty ||
      state.amount.isEmpty ||
      state.fromDate == null ||
      state.toDate == null) return;

  emit(state.copyWith(submitStatus: EmployeeStatus.loading));

  final result = await createBulkSalaryUsecase(
    request: CreateBulkSalaryRequestModel(
      employeeIds: state.selectedEmployees.map((e) => e.id).toList(),
      constructionSiteId: event.constructionSiteId,
      fromDate: state.fromDate!,
      toDate: state.toDate!,
      salaryType: state.salaryType,
      enteredAmount: double.tryParse(state.amount) ?? 0,
      paymentStatus: "PAID",
      paymentMode: state.paymentMode,
      notes: event.notes,
    ),
  );

  result.fold(
    (f) => emit(state.copyWith(
      submitStatus: EmployeeStatus.failure,
      errorMessage: f.message,
    )),
    (r) => emit(state.copyWith(
      submitStatus: EmployeeStatus.success,
      message: r.message ,
      selectedEmployees: [],
      amount: "",
      fromDate: null,
      toDate: null,
    )),
  );

  await Future.delayed(const Duration(milliseconds: 100));
  emit(state.copyWith(submitStatus: EmployeeStatus.initial));
}

  Future<void> _onLoadHistory(
    LoadTransactionHistoryEvent event,
    Emitter<SalaryState> emit,
  ) async {
    _historyPage = 1;
    _isFetchingHistory = false;
    emit(state.copyWith(historyStatus: EmployeeStatus.loading));

    final result = await getTransactionHistoryUsecase(
      page: _historyPage,
      limit: _limit,
    );
    result.fold(
      (f) => emit(state.copyWith(historyStatus: EmployeeStatus.failure)),
      (r) => emit(
        state.copyWith(
          historyStatus: EmployeeStatus.success,
          transactionHistory: r.data,
          hasMoreHistory: (r.data?.data.length ?? 0) >= _limit,
        ),
      ),
    );
  }

  Future<void> _onLoadMoreHistory(
    LoadMoreTransactionHistoryEvent event,
    Emitter<SalaryState> emit,
  ) async {
    if (_isFetchingHistory || !state.hasMoreHistory) return;
    _isFetchingHistory = true;
    emit(state.copyWith(historyPaginationStatus: EmployeeStatus.loading));

    _historyPage++;
    final result = await getTransactionHistoryUsecase(
      page: _historyPage,
      limit: _limit,
    );

    result.fold(
      (f) {
        _historyPage--;
        emit(state.copyWith(historyPaginationStatus: EmployeeStatus.failure));
      },
      (r) {
        final newData = r.data?.data ?? [];
        final merged = PaginatedSalaryTransaction(
          data: [...state.transactionHistory.data, ...newData],
          total: r.data?.total ?? state.transactionHistory.total,
          page: r.data?.page ?? _historyPage,
          limit: r.data?.limit ?? _limit,
        );
        emit(
          state.copyWith(
            historyPaginationStatus: EmployeeStatus.success,
            transactionHistory: merged,
            hasMoreHistory: newData.length >= _limit,
          ),
        );
      },
    );

    _isFetchingHistory = false;
  }
}
