import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/grant/domain/usecase/grant_usecases.dart';
import 'package:manshan/src/grant/domain/entity/paginated_grant_user.dart';
import 'package:manshan/src/grant/presentation/bloc/grant_event.dart';
import 'package:manshan/src/grant/presentation/bloc/grant_state.dart';

class GrantBloc extends Bloc<GrantEvent, GrantState> {
  final GrantAccessUsecase grantAccessUsecase;
  final RevokeAccessUsecase revokeAccessUsecase;
  final GetMyAccessesUsecase getMyAccessesUsecase;
  final GetGrantUsersUsecase getGrantUsersUsecase;
  final AcceptAccessRequestUsecase acceptAccessRequestUsecase;
  final RejectAccessRequestUsecase rejectAccessRequestUsecase;
  final GetRequestsReceivedUsecase getRequestsReceivedUsecase;
  final GetRequestsSentUsecase getRequestsSentUsecase;

  GrantBloc({
    required this.grantAccessUsecase,
    required this.revokeAccessUsecase,
    required this.getMyAccessesUsecase,
    required this.getGrantUsersUsecase,
    required this.acceptAccessRequestUsecase,
    required this.rejectAccessRequestUsecase,
    required this.getRequestsReceivedUsecase,
    required this.getRequestsSentUsecase,
  }) : super(GrantState.initial()) {
    on<GrantAccessRequestEvent>(_onGrantAccess);
    on<RevokeAccessRequestEvent>(_onRevokeAccess);
    on<LoadMyAccessesEvent>(_onLoadMyAccesses);
    on<GetGrantUsersEvent>(_onGetGrantUsers);
    on<LoadMoreGrantUsersEvent>(_onLoadMoreGrantUsers);
    on<AcceptAccessRequestEvent>(_onAcceptRequest);
    on<RejectAccessRequestEvent>(_onRejectRequest);
    on<LoadRequestsReceivedEvent>(_onLoadRequestsReceived);
    on<LoadRequestsSentEvent>(_onLoadRequestsSent);
  }

  // pagination for grant users
  int _usersCurrentPage = 1;
  static const int _usersLimit = 15;
  bool _usersIsFetching = false;

  Future<void> _onGrantAccess(
    GrantAccessRequestEvent event,
    Emitter<GrantState> emit,
  ) async {
    emit(state.copyWith(grantStatus: GrantStatus.loading));

    final result = await grantAccessUsecase(
      accessedUserId: event.accessedUserId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          grantStatus: GrantStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) {
        final granted = response.data;
        final updated = granted != null
            ? [granted, ...state.myAccesses]
            : state.myAccesses;
        emit(
          state.copyWith(
            grantStatus: GrantStatus.success,
            myAccesses: updated,
            message: response.message,
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 100));
    emit(state.copyWith(grantStatus: GrantStatus.initial));
  }

  Future<void> _onRevokeAccess(
    RevokeAccessRequestEvent event,
    Emitter<GrantState> emit,
  ) async {
    emit(state.copyWith(revokeStatus: GrantStatus.loading));

    final result = await revokeAccessUsecase(
      accessedUserId: event.accessedUserId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          revokeStatus: GrantStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) {
        final filtered = state.requestsSent
            .where((e) => e.accessedUserId != event.accessedUserId)
            .toList();
        emit(
          state.copyWith(
            revokeStatus: GrantStatus.success,
            requestsSent: filtered,
            message: response.message,
          ),
        );
      },
    );

    await Future.delayed(const Duration(milliseconds: 100));
    emit(state.copyWith(revokeStatus: GrantStatus.initial));
  }

  Future<void> _onLoadMyAccesses(
    LoadMyAccessesEvent event,
    Emitter<GrantState> emit,
  ) async {
    emit(state.copyWith(fetchStatus: GrantStatus.loading));

    final result = await getMyAccessesUsecase();

    result.fold(
      (failure) => emit(
        state.copyWith(
          fetchStatus: GrantStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (response) => emit(
        state.copyWith(
          fetchStatus: GrantStatus.success,
          myAccesses: response.data ?? const [],
        ),
      ),
    );
  }

  Future<void> _onGetGrantUsers(
    GetGrantUsersEvent event,
    Emitter<GrantState> emit,
  ) async {
    _usersCurrentPage = event.page;
    _usersIsFetching = false;
    emit(state.copyWith(usersStatus: GrantStatus.loading));

    final result = await getGrantUsersUsecase(
      page: _usersCurrentPage,
      limit: event.limit,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        usersStatus: GrantStatus.failure,
        errorMessage: failure.message,
      )),
      (response) => emit(state.copyWith(
        usersStatus: GrantStatus.success,
        grantUsers: response.data ?? PaginatedGrantUser.initial(),
        usersHasMore: (response.data?.data.length ?? 0) >= event.limit,
      )),
    );
  }

  Future<void> _onLoadMoreGrantUsers(
    LoadMoreGrantUsersEvent event,
    Emitter<GrantState> emit,
  ) async {
    if (_usersIsFetching || !state.usersHasMore) return;
    _usersIsFetching = true;

    emit(state.copyWith(usersPaginationStatus: GrantStatus.loading));
    _usersCurrentPage++;

    final result = await getGrantUsersUsecase(page: _usersCurrentPage, limit: _usersLimit);

    result.fold((failure) {
      _usersCurrentPage--;
      emit(state.copyWith(usersPaginationStatus: GrantStatus.failure));
    }, (response) {
      final newData = response.data?.data ?? [];
      final merged = PaginatedGrantUser(
        data: [...state.grantUsers.data, ...newData],
        total: response.data?.total ?? state.grantUsers.total,
        page: response.data?.page ?? _usersCurrentPage,
        limit: response.data?.limit ?? _usersLimit,
      );
      emit(state.copyWith(
        usersPaginationStatus: GrantStatus.success,
        grantUsers: merged,
        usersHasMore: newData.length >= _usersLimit,
      ));
    });

    _usersIsFetching = false;
  }

  Future<void> _onAcceptRequest(
    AcceptAccessRequestEvent event,
    Emitter<GrantState> emit,
  ) async {
    emit(state.copyWith(acceptRejectStatus: GrantStatus.loading));

    final result = await acceptAccessRequestUsecase(
      accessedUserId: event.accessedUserId,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        acceptRejectStatus: GrantStatus.failure,
        errorMessage: failure.message,
      )),
      (response) {
        final accepted = response.data;
        final updated = state.requestsReceived
            .map((e) => e.id == accepted?.id ? accepted ?? e : e)
            .toList();
        emit(state.copyWith(
          acceptRejectStatus: GrantStatus.success,
          requestsReceived: updated,
          message: response.message,
        ));
      },
    );

    await Future.delayed(const Duration(milliseconds: 100));
    emit(state.copyWith(acceptRejectStatus: GrantStatus.initial));
  }

  Future<void> _onRejectRequest(
    RejectAccessRequestEvent event,
    Emitter<GrantState> emit,
  ) async {
    emit(state.copyWith(acceptRejectStatus: GrantStatus.loading));

    final result = await rejectAccessRequestUsecase(
      accessedUserId: event.accessedUserId,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        acceptRejectStatus: GrantStatus.failure,
        errorMessage: failure.message,
      )),
      (response) {
        final filtered = state.requestsReceived
            .where((e) => e.accessedUserId != event.accessedUserId)
            .toList();
        emit(state.copyWith(
          acceptRejectStatus: GrantStatus.success,
          requestsReceived: filtered,
          message: response.message,
        ));
      },
    );

    await Future.delayed(const Duration(milliseconds: 100));
    emit(state.copyWith(acceptRejectStatus: GrantStatus.initial));
  }

  Future<void> _onLoadRequestsReceived(
    LoadRequestsReceivedEvent event,
    Emitter<GrantState> emit,
  ) async {
    emit(state.copyWith(requestsReceivedStatus: GrantStatus.loading));

    final result = await getRequestsReceivedUsecase();

    result.fold(
      (failure) => emit(state.copyWith(
        requestsReceivedStatus: GrantStatus.failure,
        errorMessage: failure.message,
      )),
      (response) => emit(state.copyWith(
        requestsReceivedStatus: GrantStatus.success,
        requestsReceived: response.data ?? const [],
      )),
    );
  }

  Future<void> _onLoadRequestsSent(
    LoadRequestsSentEvent event,
    Emitter<GrantState> emit,
  ) async {
    emit(state.copyWith(requestsSentStatus: GrantStatus.loading));

    final result = await getRequestsSentUsecase();

    result.fold(
      (failure) => emit(state.copyWith(
        requestsSentStatus: GrantStatus.failure,
        errorMessage: failure.message,
      )),
      (response) => emit(state.copyWith(
        requestsSentStatus: GrantStatus.success,
        requestsSent: response.data ?? const [],
      )),
    );
  }
}
