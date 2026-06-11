import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/employee/data/model/create_employee_request_model.dart';
import 'package:manshan/src/employee/domain/entity/paginated_employee.dart';
import 'package:manshan/src/employee/domain/usecase/all_employee_usecase.dart';
import 'package:manshan/src/employee/domain/usecase/create_employee_usecase.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_event.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final AllEmployeeUsecase allEmployeeUsecase;
  final CreateEmployeeUsecase createEmployeeUsecase;

  int _currentPage = 1;
  static const int _limit = 10;
  bool _isFetching = false;

  EmployeeBloc({
    required this.allEmployeeUsecase,
    required this.createEmployeeUsecase,
  }) : super(EmployeeState.initial()) {
    on<GetAllEmployeeRequestEvent>(_onGetAll);
    on<LoadMoreEmployeeEvent>(_onLoadMore);
    on<CreateEmployeeRequestEvent>(_onCreate);
  }

  Future<void> _onGetAll(
    GetAllEmployeeRequestEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    _currentPage = 1;
    _isFetching = false;
    emit(state.copyWith(employeeStatus: EmployeeStatus.loading));

    final result = await allEmployeeUsecase(
      EmployeeParams(page: _currentPage, limit: _limit),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        employeeStatus: EmployeeStatus.failure,
        errorMessage: failure.message,
      )),
      (response) => emit(state.copyWith(
        employeeStatus: EmployeeStatus.success,
        allEmployee: response.data,
        hasMore: (response.data?.data.length ?? 0) >= _limit,
      )),
    );
  }

  Future<void> _onLoadMore(
    LoadMoreEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    if (_isFetching || !state.hasMore) return;
    _isFetching = true;

    emit(state.copyWith(paginationStatus: EmployeeStatus.loading));
    _currentPage++;

    final result = await allEmployeeUsecase(
      EmployeeParams(page: _currentPage, limit: _limit),
    );

    result.fold(
      (failure) {
        _currentPage--;
        emit(state.copyWith(paginationStatus: EmployeeStatus.failure));
      },
      (response) {
        final newData = response.data?.data ?? [];
        final merged = PaginatedEmployee(
          data: [...state.allEmployee.data, ...newData],
          total: response.data?.total ?? state.allEmployee.total,
          page: response.data?.page ?? _currentPage,
          limit: response.data?.limit ?? _limit,
        );
        emit(state.copyWith(
          paginationStatus: EmployeeStatus.success,
          allEmployee: merged,
          hasMore: newData.length >= _limit,
        ));
      },
    );

    _isFetching = false;
  }
Future<void> _onCreate(
  CreateEmployeeRequestEvent event,
  Emitter<EmployeeState> emit,
) async {
  emit(state.copyWith(createStatus: EmployeeStatus.loading));

  final result = await createEmployeeUsecase(
    request: CreateEmployeeRequestModel(
      name: event.name,
      phone: event.phone,
      role: event.role,
      salaryType: event.salaryType,
      defaultSalary: event.defaultSalary,
      joiningDate: event.joiningDate,
    ),
  );

  result.fold(
    (failure) => emit(state.copyWith(
      createStatus: EmployeeStatus.failure,
      errorMessage: failure.message,
    )),
    (response) => emit(state.copyWith(
      createStatus: EmployeeStatus.success,
      message: response.message ,
    )),
  );

  await Future.delayed(const Duration(milliseconds: 100));
  emit(state.copyWith(createStatus: EmployeeStatus.initial));
}
}