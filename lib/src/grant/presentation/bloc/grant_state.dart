import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/grant/domain/entity/grant_access.dart';
import 'package:manshan/src/grant/domain/entity/paginated_grant_user.dart';

class GrantState {
  final GrantStatus grantStatus;
  final GrantStatus revokeStatus;
  final GrantStatus fetchStatus;
  final GrantStatus usersStatus;
  final GrantStatus usersPaginationStatus;
  final PaginatedGrantUser grantUsers;
  final bool usersHasMore;
  final List<GrantAccess> myAccesses;
  final List<GrantAccess> requestsReceived;
  final List<GrantAccess> requestsSent;
  final GrantStatus acceptRejectStatus;
  final GrantStatus requestsReceivedStatus;
  final GrantStatus requestsSentStatus;
  final String message;
  final String errorMessage;

  const GrantState({
    required this.grantStatus,
    required this.revokeStatus,
    required this.fetchStatus,
    required this.usersStatus,
    required this.usersPaginationStatus,
    required this.grantUsers,
    required this.usersHasMore,
    required this.myAccesses,
    required this.requestsReceived,
    required this.requestsSent,
    required this.acceptRejectStatus,
    required this.requestsReceivedStatus,
    required this.requestsSentStatus,
    required this.message,
    required this.errorMessage,
  });

  factory GrantState.initial() {
    return GrantState(
      grantStatus: GrantStatus.initial,
      revokeStatus: GrantStatus.initial,
      fetchStatus: GrantStatus.initial,
        usersStatus: GrantStatus.initial,
        usersPaginationStatus: GrantStatus.initial,
        grantUsers: PaginatedGrantUser.initial(),
        usersHasMore: true,
      myAccesses: const [],      requestsReceived: const [],
      requestsSent: const [],
      acceptRejectStatus: GrantStatus.initial,
      requestsReceivedStatus: GrantStatus.initial,
      requestsSentStatus: GrantStatus.initial,      message: "",
      errorMessage: "",
    );
  }

  GrantState copyWith({
    GrantStatus? grantStatus,
    GrantStatus? revokeStatus,
    GrantStatus? fetchStatus,
    GrantStatus? usersStatus,
    GrantStatus? usersPaginationStatus,
    List<GrantAccess>? myAccesses,
    PaginatedGrantUser? grantUsers,
    bool? usersHasMore,
    List<GrantAccess>? requestsReceived,
    List<GrantAccess>? requestsSent,
    GrantStatus? acceptRejectStatus,
    GrantStatus? requestsReceivedStatus,
    GrantStatus? requestsSentStatus,
    String? message,
    String? errorMessage,
  }) {
    return GrantState(
      grantStatus: grantStatus ?? this.grantStatus,
      revokeStatus: revokeStatus ?? this.revokeStatus,
      fetchStatus: fetchStatus ?? this.fetchStatus,
      usersStatus: usersStatus ?? this.usersStatus,
      usersPaginationStatus: usersPaginationStatus ?? this.usersPaginationStatus,
      myAccesses: myAccesses ?? this.myAccesses,
      grantUsers: grantUsers ?? this.grantUsers,
      usersHasMore: usersHasMore ?? this.usersHasMore,
      requestsReceived: requestsReceived ?? this.requestsReceived,
      requestsSent: requestsSent ?? this.requestsSent,
      acceptRejectStatus: acceptRejectStatus ?? this.acceptRejectStatus,
      requestsReceivedStatus: requestsReceivedStatus ?? this.requestsReceivedStatus,
      requestsSentStatus: requestsSentStatus ?? this.requestsSentStatus,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
