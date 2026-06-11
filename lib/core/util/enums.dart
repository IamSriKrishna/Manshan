enum AuthStatus { initial, loading, loaded, failed }

enum DashboardStatus { initial, loading, loaded, failed }

enum EmployeeStatus { initial, loading, success, failure }
 
enum GrantStatus { initial, loading, success, failure }

enum AccessStatus { pending, accepted, rejected }

String accessStatusToString(AccessStatus status) {
  switch (status) {
    case AccessStatus.pending:
      return 'PENDING';
    case AccessStatus.accepted:
      return 'ACCEPTED';
    case AccessStatus.rejected:
      return 'REJECTED';
  }
}

AccessStatus stringToAccessStatus(String status) {
  final upperStatus = status.toUpperCase();
  switch (upperStatus) {
    case 'PENDING':
      return AccessStatus.pending;
    case 'ACCEPTED':
      return AccessStatus.accepted;
    case 'REJECTED':
      return AccessStatus.rejected;
    default:
      return AccessStatus.pending;
  }
}
