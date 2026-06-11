import 'package:flutter/material.dart';
import 'package:manshan/core/extra/grant_extra.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/grant/domain/entity/grant_access.dart';
import 'package:manshan/src/grant/domain/entity/grant_user.dart';
import 'grant_user_chip.dart';

class GrantUserSelector extends StatefulWidget {
  final List<GrantUser> users;
  final List<GrantAccess> requestsSent;
  final GrantUser? selectedUser;
  final ValueChanged<GrantUser> onUserSelected;
  final bool isLoading;

  const GrantUserSelector({
    super.key,
    required this.users,
    required this.requestsSent,
    required this.selectedUser,
    required this.onUserSelected,
    this.isLoading = false,
  });

  @override
  State<GrantUserSelector> createState() => _GrantUserSelectorState();
}

class _GrantUserSelectorState extends State<GrantUserSelector> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _isGranted(GrantUser user) {
    return widget.requestsSent.any((a) =>
      a.accessedUserId == user.id && a.status != AccessStatus.rejected);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: GrantDimens.pagePadding),
          child: Row(
            children: [
              Text('USERS', style: GrantTextStyles.sectionTitle),
              const Spacer(),
              if (widget.users.isNotEmpty)
                Text(
                  '${widget.users.length} members',
                  style: GrantTextStyles.dateLabel.copyWith(
                    color: GrantColors.textMuted,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        SizedBox(
          height: 130,
          child: widget.isLoading
              ? _buildShimmer()
              : widget.users.isEmpty
                  ? _buildEmpty()
                  : ListView.separated(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                          horizontal: GrantDimens.pagePadding),
                      itemCount: widget.users.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 6),
                      itemBuilder: (context, i) {
                        final user = widget.users[i];
                        return GrantUserChip(
                          name: user.name,
                          email: user.email,
                          isSelected: widget.selectedUser?.id == user.id,
                          isAlreadyGranted: _isGranted(user),
                          onTap: () => widget.onUserSelected(user),
                        );
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildShimmer() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding:
          const EdgeInsets.symmetric(horizontal: GrantDimens.pagePadding),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(width: 6),
      itemBuilder: (_, __) => const _ShimmerChip(),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Text(
        'No users available',
        style: GrantTextStyles.userEmail,
      ),
    );
  }
}

class _ShimmerChip extends StatefulWidget {
  const _ShimmerChip();

  @override
  State<_ShimmerChip> createState() => _ShimmerChipState();
}

class _ShimmerChipState extends State<_ShimmerChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => SizedBox(
        width: 76,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            CircleAvatar(
              radius: 29,
              backgroundColor:
                  GrantColors.card.withOpacity(0.4 + _anim.value * 0.4),
            ),
            const SizedBox(height: 10),
            Container(
              width: 44,
              height: 9,
              decoration: BoxDecoration(
                color: GrantColors.card.withOpacity(0.4 + _anim.value * 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}