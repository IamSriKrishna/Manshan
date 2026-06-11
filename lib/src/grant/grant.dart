import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/core/extra/grant_extra.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/grant/domain/entity/grant_user.dart';
import 'package:manshan/src/grant/presentation/bloc/grant_bloc.dart';
import 'package:manshan/src/grant/presentation/bloc/grant_event.dart';
import 'package:manshan/src/grant/presentation/bloc/grant_state.dart';
import 'package:manshan/src/grant/presentation/widgets/grant_access_tile.dart';
import 'package:manshan/src/grant/presentation/widgets/grant_action_pannel.dart';
import 'package:manshan/src/grant/presentation/widgets/grant_empty_state.dart';
import 'package:manshan/src/grant/presentation/widgets/grant_user_select.dart';

class GrantView extends StatefulWidget {
  const GrantView({super.key});

  @override
  State<GrantView> createState() => _GrantViewState();
}

class _GrantViewState extends State<GrantView> {
  GrantUser? _selectedUser;
  final ScrollController _listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchInitial();
    _listScrollController.addListener(_onScroll);
  }

  void _fetchInitial() {
    final bloc = context.read<GrantBloc>();
    bloc.add(LoadRequestsReceivedEvent());
    bloc.add(LoadRequestsSentEvent());
    bloc.add(GetGrantUsersEvent());
  }

  void _onScroll() {
    if (_listScrollController.position.pixels >=
        _listScrollController.position.maxScrollExtent - 200) {
      context.read<GrantBloc>().add(LoadMoreGrantUsersEvent());
    }
  }

  @override
  void dispose() {
    _listScrollController.dispose();
    super.dispose();
  }

  void _onGrant(GrantState state) {
    if (_selectedUser == null) return;
    final alreadyRequested = state.requestsSent.any(
      (a) => a.accessedUserId == _selectedUser!.id && a.status != AccessStatus.rejected,
    );
    if (alreadyRequested) return;
    HapticFeedback.mediumImpact();
    context.read<GrantBloc>().add(
      GrantAccessRequestEvent(accessedUserId: _selectedUser!.id),
    );
  }

  void _onRevoke(int accessedUserId) {
    HapticFeedback.lightImpact();
    context.read<GrantBloc>().add(
      RevokeAccessRequestEvent(accessedUserId: accessedUserId),
    );
  }

  void _showSnack(BuildContext ctx, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: isError ? GrantColors.danger : GrantColors.success,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              msg,
              style: GrantTextStyles.accessMeta.copyWith(
                color: GrantColors.textPrimary,
              ),
            ),
          ],
        ),
        backgroundColor: GrantColors.card,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GrantBloc, GrantState>(
      listenWhen: (prev, curr) =>
          prev.grantStatus != curr.grantStatus ||
          prev.revokeStatus != curr.revokeStatus,
      listener: (ctx, state) {
        if (state.grantStatus == GrantStatus.success) {
          _showSnack(
            ctx,
            state.message.isNotEmpty ? state.message : 'Access granted',
          );
        } else if (state.grantStatus == GrantStatus.failure) {
          _showSnack(ctx, state.errorMessage, isError: true);
        }
        if (state.revokeStatus == GrantStatus.success) {
          _showSnack(
            ctx,
            state.message.isNotEmpty ? state.message : 'Access revoked',
          );
        } else if (state.revokeStatus == GrantStatus.failure) {
          _showSnack(ctx, state.errorMessage, isError: true);
        }
      },
      builder: (ctx, state) {
        return Scaffold(
          backgroundColor: GrantColors.base,
          body: SafeArea(
            child: CustomScrollView(
              controller: _listScrollController,
              slivers: [
                // ── App Bar ────────────────────────────────────────────
                SliverToBoxAdapter(child: _buildAppBar(context)),

                const SliverToBoxAdapter(
                  child: SizedBox(height: GrantDimens.sectionGap),
                ),

                // ── User selector ──────────────────────────────────────
                SliverToBoxAdapter(
                  child: GrantUserSelector(
                    users: state.grantUsers.data,
                    requestsSent: state.requestsSent,
                    selectedUser: _selectedUser,
                    isLoading: state.usersStatus == GrantStatus.loading,
                    onUserSelected: (user) =>
                        setState(() => _selectedUser = user),
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: GrantDimens.sectionGap),
                ),

                // ── Action panel ───────────────────────────────────────
                SliverToBoxAdapter(
                  child: GrantActionPanel(
                    selectedUser: _selectedUser,
                    requestsSent: state.requestsSent,
                    isGranting: state.grantStatus == GrantStatus.loading,
                    isRevoking: state.revokeStatus == GrantStatus.loading,
                    onGrant: () => _onGrant(state),
                    onRevoke: () {
                      if (_selectedUser != null) {
                        _onRevoke(_selectedUser!.id);
                      }
                    },
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: GrantDimens.sectionGap),
                ),

                // ── Incoming requests header ────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GrantDimens.pagePadding,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'REQUESTS RECEIVED',
                          style: GrantTextStyles.sectionTitle,
                        ),
                        const Spacer(),
                        if (state.requestsReceived.isNotEmpty)
                          _CountBadge(count: state.requestsReceived.length),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 14)),

                if (state.requestsReceivedStatus == GrantStatus.loading)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(
                          color: GrantColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                else if (state.requestsReceived.isEmpty)
                  const SliverToBoxAdapter(
                    child: GrantEmptyState(
                      title: 'No incoming requests',
                      subtitle:
                          'Incoming access requests will appear here for you to accept or reject.',
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((ctx, i) {
                      final access = state.requestsReceived[i];
                      return GrantAccessTile(
                        access: access,
                        displayName: access.userName,
                        onAccept: access.status == AccessStatus.pending
                            ? () => context.read<GrantBloc>().add(
                                  AcceptAccessRequestEvent(
                                    accessedUserId: access.userId,
                                  ),
                                )
                            : null,
                        isAccepting:
                            state.acceptRejectStatus == GrantStatus.loading,
                        onReject: access.status == AccessStatus.pending
                            ? () => context.read<GrantBloc>().add(
                                  RejectAccessRequestEvent(
                                    accessedUserId: access.userId,
                                  ),
                                )
                            : null,
                        isRejecting:
                            state.acceptRejectStatus == GrantStatus.loading,
                      );
                    }, childCount: state.requestsReceived.length),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: GrantDimens.sectionGap),
                ),

                // ── Sent requests header ────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GrantDimens.pagePadding,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'REQUESTS SENT',
                          style: GrantTextStyles.sectionTitle,
                        ),
                        const Spacer(),
                        if (state.requestsSent.isNotEmpty)
                          _CountBadge(count: state.requestsSent.length),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 14)),

                if (state.requestsSentStatus == GrantStatus.loading)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(
                          color: GrantColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                else if (state.requestsSent.isEmpty)
                  const SliverToBoxAdapter(
                    child: GrantEmptyState(
                      title: 'No requests sent',
                      subtitle:
                          'Requests you send to other users will appear here with their status.',
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((ctx, i) {
                      final access = state.requestsSent[i];
                      return GrantAccessTile(
                        access: access,
                        displayName: access.accessedUserName,
                        onRevoke: access.status != AccessStatus.rejected
                            ? () => _onRevoke(access.accessedUserId)
                            : null,
                        isRevoking: state.revokeStatus == GrantStatus.loading,
                      );
                    }, childCount: state.requestsSent.length),
                  ),

                // ── Pagination loader ──────────────────────────────────
                if (state.usersPaginationStatus == GrantStatus.loading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: GrantColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        GrantDimens.pagePadding,
        16,
        GrantDimens.pagePadding,
        0,
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: GrantColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: GrantColors.cardBorder),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: GrantColors.textSecondary,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Title
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Access Control',
                style: TextStyle(
                  color: GrantColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Manage who can view your data',
                style: GrantTextStyles.dateLabel.copyWith(
                  color: GrantColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),

          // Shield icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: GrantColors.primaryDim,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GrantColors.primary.withOpacity(0.25)),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: GrantColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: GrantColors.primaryDim,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: GrantColors.primary.withOpacity(0.3)),
      ),
      child: Text(
        '$count',
        style: GrantTextStyles.chipLabel.copyWith(
          color: GrantColors.primary,
          fontSize: 11,
        ),
      ),
    );
  }
}
