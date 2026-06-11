import 'package:flutter/material.dart';
import 'package:manshan/core/extra/grant_extra.dart';

class GrantUserChip extends StatefulWidget {
  final String name;
  final String email;
  final bool isSelected;
  final bool isAlreadyGranted;
  final VoidCallback onTap;

  const GrantUserChip({
    super.key,
    required this.name,
    required this.email,
    required this.isSelected,
    required this.isAlreadyGranted,
    required this.onTap,
  });

  @override
  State<GrantUserChip> createState() => _GrantUserChipState();
}

class _GrantUserChipState extends State<GrantUserChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _initials {
    final parts = widget.name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return widget.name.isNotEmpty ? widget.name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final isGranted = widget.isAlreadyGranted;
    final Color ringColor = isGranted
        ? GrantColors.success
        : widget.isSelected
            ? GrantColors.primary
            : GrantColors.textMuted.withOpacity(0.3);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Avatar with glow ring
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) {
                return Container(
                  width: GrantDimens.avatarSize + 8,
                  height: GrantDimens.avatarSize + 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: widget.isSelected
                        ? [
                            BoxShadow(
                              color: ringColor.withOpacity(
                                  0.45 * _pulseAnim.value),
                              blurRadius: 18 * _pulseAnim.value,
                              spreadRadius: 3 * _pulseAnim.value,
                            ),
                          ]
                        : [],
                  ),
                  child: child,
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ringColor,
                    width: widget.isSelected || isGranted ? 2.5 : 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(3),
                child: CircleAvatar(
                  radius: GrantDimens.avatarSize / 2,
                  backgroundColor: widget.isSelected
                      ? GrantColors.primaryDim
                      : GrantColors.card,
                  child: Text(
                    _initials,
                    style: TextStyle(
                      color: widget.isSelected
                          ? GrantColors.primary
                          : GrantColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Name
            Text(
              widget.name.split(' ').first,
              style: GrantTextStyles.userName.copyWith(
                fontSize: 11,
                color: widget.isSelected
                    ? GrantColors.textPrimary
                    : GrantColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              maxLines: 1,
            ),

            const SizedBox(height: 3),

            // Status badge
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isGranted
                  ? _badge('ACCESS', GrantColors.success)
                  : widget.isSelected
                      ? _badge('SELECTED', GrantColors.primary)
                      : const SizedBox(height: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String label, Color color) {
    return Container(
      key: ValueKey(label),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: GrantTextStyles.chipLabel.copyWith(color: color),
      ),
    );
  }
}