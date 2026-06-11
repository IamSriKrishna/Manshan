import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/dashboard/domain/entity/dashboard.dart';
import 'package:manshan/src/dashboard/domain/entity/paginated_last_transaction.dart';

class DashboardState {
  final DashboardStatus dashboardStatus;
  final DashboardStatus lastTransactionStatus;
  final Dashboard dashboard;
  final PaginatedLastTransaction lastTransaction;
  final String message;
  final String errorMessage;

  const DashboardState({
    required this.dashboardStatus,
    required this.lastTransactionStatus,
    required this.dashboard,
    required this.lastTransaction,
    required this.message,
    required this.errorMessage,
  });

  factory DashboardState.initial() {
    return DashboardState(
      dashboardStatus: DashboardStatus.initial,
      lastTransactionStatus: DashboardStatus.initial,
      dashboard: Dashboard.initial(),
      lastTransaction: PaginatedLastTransaction.initial(),
      message: "",
      errorMessage: "",
    );
  }

  DashboardState copyWith({
    DashboardStatus? dashboardStatus,
    DashboardStatus? lastTransactionStatus,
    PaginatedLastTransaction? lastTransaction,
    Dashboard? dashboard,
    String? message,
    String? errorMessage,
  }) {
    return DashboardState(
      dashboardStatus: dashboardStatus ?? this.dashboardStatus,
      lastTransactionStatus:
          lastTransactionStatus ?? this.lastTransactionStatus,
      dashboard: dashboard ?? this.dashboard,
      lastTransaction: lastTransaction ?? this.lastTransaction,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
