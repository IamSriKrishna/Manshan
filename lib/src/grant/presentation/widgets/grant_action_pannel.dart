import 'package:flutter/material.dart';
import 'package:manshan/core/extra/grant_extra.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/grant/domain/entity/grant_access.dart';
import 'package:manshan/src/grant/domain/entity/grant_user.dart';

class GrantActionPanel extends StatelessWidget {
  final GrantUser? selectedUser;
  final List<GrantAccess> requestsSent;
  final bool isGranting;
  final bool isRevoking;
  final VoidCallback onGrant;
  final VoidCallback onRevoke;

  const GrantActionPanel({
    super.key,
    required this.selectedUser,
    required this.requestsSent,
    required this.isGranting,
    required this.isRevoking,
    required this.onGrant,
    required this.onRevoke,
  });

  GrantAccess? get _selectedRequest {
    if (selectedUser == null) return null;
    try {
      return requestsSent
          .firstWhere((a) => a.accessedUserId == selectedUser!.id);
    } catch (_) {
      return null;
    }
  }

  bool get _hasActiveRequest {
    final request = _selectedRequest;
    return request != null && request.status != AccessStatus.rejected;
  }

  bool get _isAccepted => _selectedRequest?.status == AccessStatus.accepted;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      child: selectedUser == null
          ? _buildPrompt()
          : _buildPanel(),
    );
  }

  Widget _buildPrompt() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: GrantDimens.pagePadding),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GrantColors.surface,
        borderRadius: BorderRadius.circular(GrantDimens.cardRadius),
        border: Border.all(color: GrantColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: GrantColors.primaryDim,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.touch_app_rounded,
                color: GrantColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Select a user above to send, cancel, or revoke an access request',
              style: GrantTextStyles.accessMeta,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanel() {
    final hasRequest = _hasActiveRequest;
    final requestStatus = _selectedRequest?.status;
    final statusLabel = requestStatus == AccessStatus.accepted
        ? 'Accepted'
        : requestStatus == AccessStatus.pending
            ? 'Request pending'
            : requestStatus == AccessStatus.rejected
                ? 'Request denied'
                : 'No request';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: GrantDimens.pagePadding),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GrantColors.card,
        borderRadius: BorderRadius.circular(GrantDimens.cardRadius),
        border: Border.all(
          color: hasRequest
              ? GrantColors.success.withOpacity(0.25)
              : GrantColors.primary.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (hasRequest ? GrantColors.success : GrantColors.primary)
                .withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: hasRequest
                ? GrantColors.successDim
                : GrantColors.primaryDim,
            child: Text(
              _initials(selectedUser!.name),
              style: TextStyle(
                color: hasRequest ? GrantColors.success : GrantColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name & status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedUser!.name, style: GrantTextStyles.userName),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasRequest
                            ? GrantColors.success
                            : GrantColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      statusLabel,
                      style: GrantTextStyles.accessMeta.copyWith(
                        color: hasRequest
                            ? GrantColors.success
                            : GrantColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Action button
          _ActionButton(
            label: hasRequest ? (_isAccepted ? 'Revoke' : 'Cancel') : 'Request',
            icon: hasRequest ? Icons.remove_circle_outline_rounded : Icons.send,
            color: hasRequest ? GrantColors.danger : GrantColors.primary,
            dimColor: hasRequest ? GrantColors.dangerDim : GrantColors.primaryDim,
            isLoading: hasRequest ? isRevoking : isGranting,
            onTap: hasRequest ? onRevoke : onGrant,
          ),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color dimColor;
  final bool isLoading;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.dimColor,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: dimColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
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
                  Icon(icon, color: color, size: 15),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: GrantTextStyles.chipLabel.copyWith(
                      color: color,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}