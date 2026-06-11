import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/core/util/usecase.dart';
import 'package:manshan/src/dashboard/domain/usecase/dashboard_usecase.dart';
import 'package:manshan/src/dashboard/domain/usecase/last_transaction_usecase.dart';
import 'package:manshan/src/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:manshan/src/dashboard/presentation/bloc/dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardUsecase _dashboardUsecase;
  final LastTransactionUsecase _lastTransactionUsecase;

  DashboardBloc({
    required this._dashboardUsecase,
    required this._lastTransactionUsecase,
  }) : super(DashboardState.initial()) {
    on<DashboardRequestEvent>(_onDashboardRequestEvent);
    on<LastTransactionRequestEvent>(_onLastTransactionRequestEvent);
  }

  Future<void> _onDashboardRequestEvent(
    DashboardRequestEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final response = await _dashboardUsecase.call(NoParams());

    response.fold(
      (failure) {
        emit(
          state.copyWith(
            dashboardStatus: DashboardStatus.failed,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            dashboardStatus: DashboardStatus.loaded,
            dashboard: response.data,
            message: response.message,
          ),
        );
      },
    );
  }

  Future<void> _onLastTransactionRequestEvent(
    LastTransactionRequestEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final response = await _lastTransactionUsecase.call(NoParams());

    response.fold(
      (failure) {
        emit(
          state.copyWith(
            lastTransactionStatus: DashboardStatus.failed,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        emit(
          state.copyWith(
            lastTransactionStatus: DashboardStatus.loaded,
            lastTransaction: response.data,
            message: response.message,
          ),
        );
      },
    );
  }
}
