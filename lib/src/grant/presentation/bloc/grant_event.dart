abstract class GrantEvent {}

class GrantAccessRequestEvent extends GrantEvent {
  final int accessedUserId;
  GrantAccessRequestEvent({required this.accessedUserId});
}

class RevokeAccessRequestEvent extends GrantEvent {
  final int accessedUserId;
  RevokeAccessRequestEvent({required this.accessedUserId});
}

class LoadMyAccessesEvent extends GrantEvent {}

class GetGrantUsersEvent extends GrantEvent {
  final int page;
  final int limit;
  GetGrantUsersEvent({this.page = 1, this.limit = 15});
}

class LoadMoreGrantUsersEvent extends GrantEvent {}

class AcceptAccessRequestEvent extends GrantEvent {
  final int accessedUserId;
  AcceptAccessRequestEvent({required this.accessedUserId});
}

class RejectAccessRequestEvent extends GrantEvent {
  final int accessedUserId;
  RejectAccessRequestEvent({required this.accessedUserId});
}

class LoadRequestsReceivedEvent extends GrantEvent {}

class LoadRequestsSentEvent extends GrantEvent {}
