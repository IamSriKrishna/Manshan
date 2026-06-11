import 'package:flutter/material.dart';
import 'package:manshan/core/extra/grant_extra.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/grant/domain/entity/grant_access.dart';

class GrantAccessTile extends StatelessWidget {
  final GrantAccess access;
  final String? displayName;
  final VoidCallback? onRevoke;
  final bool isRevoking;
  final VoidCallback? onAccept;
  final bool isAccepting;
  final VoidCallback? onReject;
  final bool isRejecting;

  const GrantAccessTile({
    super.key,
    required this.access,
    this.displayName,
    this.onRevoke,
    this.isRevoking = false,
    this.onAccept,
    this.isAccepting = false,
    this.onReject,
    this.isRejecting = false,
  });

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final name = displayName ?? access.accessedUserName;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: GrantDimens.pagePadding,
        vertical: GrantDimens.itemGap / 2,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: GrantColors.card,
        borderRadius: BorderRadius.circular(GrantDimens.cardRadius),
        border: Border.all(color: GrantColors.cardBorder),
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: GrantStatusHelper.getStatusDimColor(
                    accessStatusToString(access.status)),
                child: Text(
                  _initials(name),
                  style: TextStyle(
                    color: GrantStatusHelper.getStatusColor(
                        accessStatusToString(access.status)),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: GrantStatusHelper.getStatusColor(
                        accessStatusToString(access.status)),
                    shape: BoxShape.circle,
                    border: Border.all(color: GrantColors.card, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Name, date & status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GrantTextStyles.accessName,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: GrantStatusHelper.getStatusDimColor(
                            accessStatusToString(access.status)),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: GrantStatusHelper.getStatusColor(
                                  accessStatusToString(access.status))
                              .withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            GrantStatusHelper.getStatusIcon(
                                accessStatusToString(access.status)),
                            size: 10,
                            color: GrantStatusHelper.getStatusColor(
                                accessStatusToString(access.status)),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            GrantStatusHelper.getStatusLabel(
                                accessStatusToString(access.status)),
                            style: GrantTextStyles.statusBadge.copyWith(
                              color: GrantStatusHelper.getStatusColor(
                                  accessStatusToString(access.status)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 10,
                      color: GrantColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Since ${_formatDate(access.createdAt)}',
                      style: GrantTextStyles.dateLabel,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Actions
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    if (onAccept != null || onReject != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (onAccept != null)
            _RequestActionButton(
              icon: Icons.check_rounded,
              label: 'Accept',
              color: GrantColors.success,
              isLoading: isAccepting,
              onTap: onAccept!,
            ),
          if (onReject != null) ...[
            const SizedBox(height: 8),
            _RequestActionButton(
              icon: Icons.close_rounded,
              label: 'Reject',
              color: GrantColors.danger,
              isLoading: isRejecting,
              onTap: onReject!,
            ),
          ],
        ],
      );
    }

    if (onRevoke != null) {
      return GestureDetector(
        onTap: isRevoking ? null : onRevoke,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: GrantColors.dangerDim,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GrantColors.danger.withOpacity(0.2)),
          ),
          child: isRevoking
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: GrantColors.danger,
                  ),
                )
              : const Icon(
                  Icons.remove_circle_outline_rounded,
                  color: GrantColors.danger,
                  size: 16,
                ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _RequestActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const _RequestActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.22)),
        ),
        child: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: color,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: color, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: GrantTextStyles.chipLabel.copyWith(
                      color: color,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
