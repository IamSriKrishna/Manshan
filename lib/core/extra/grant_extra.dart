import 'package:flutter/material.dart';

// ─── Color Tokens ────────────────────────────────────────────────────────────
class GrantColors {
  GrantColors._();

  static const Color base = Color(0xFF0A0A0F);
  static const Color surface = Color(0xFF13131A);
  static const Color card = Color(0xFF1E1E2E);
  static const Color cardBorder = Color(0xFF2A2A3E);
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDim = Color(0x336C63FF);
  static const Color danger = Color(0xFFFF6584);
  static const Color dangerDim = Color(0x33FF6584);
  static const Color success = Color(0xFF2ECC71);
  static const Color successDim = Color(0x332ECC71);
  static const Color warning = Color(0xFFFFA500);
  static const Color warningDim = Color(0x33FFA500);
  static const Color textPrimary = Color(0xFFF0F0FF);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color textMuted = Color(0xFF44445A);
}

// ─── Text Styles ─────────────────────────────────────────────────────────────
class GrantTextStyles {
  GrantTextStyles._();

  static const TextStyle sectionTitle = TextStyle(
    color: GrantColors.textPrimary,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 2.5,
  );

  static const TextStyle userName = TextStyle(
    color: GrantColors.textPrimary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle userEmail = TextStyle(
    color: GrantColors.textSecondary,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );

  static const TextStyle chipLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  static const TextStyle accessName = TextStyle(
    color: GrantColors.textPrimary,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle accessMeta = TextStyle(
    color: GrantColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle dateLabel = TextStyle(
    color: GrantColors.textMuted,
    fontSize: 11,
    fontFamily: 'monospace',
    letterSpacing: 0.5,
  );

  static const TextStyle emptyTitle = TextStyle(
    color: GrantColors.textSecondary,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle emptySubtitle = TextStyle(
    color: GrantColors.textMuted,
    fontSize: 13,
  );

  static const TextStyle statusBadge = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
  );
}

// ─── Status Utilities ────────────────────────────────────────────────────────
class GrantStatusHelper {
  GrantStatusHelper._();

  static Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return GrantColors.warning;
      case 'ACCEPTED':
        return GrantColors.success;
      case 'REJECTED':
        return GrantColors.danger;
      default:
        return GrantColors.textMuted;
    }
  }

  static Color getStatusDimColor(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return GrantColors.warningDim;
      case 'ACCEPTED':
        return GrantColors.successDim;
      case 'REJECTED':
        return GrantColors.dangerDim;
      default:
        return GrantColors.textMuted.withOpacity(0.2);
    }
  }

  static String getStatusLabel(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return 'PENDING';
      case 'ACCEPTED':
        return 'ACCEPTED';
      case 'REJECTED':
        return 'REJECTED';
      default:
        return status;
    }
  }

  static IconData getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'PENDING':
        return Icons.schedule_rounded;
      case 'ACCEPTED':
        return Icons.check_circle_rounded;
      case 'REJECTED':
        return Icons.cancel_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}

// ─── Spacing & Radius ─────────────────────────────────────────────────────────
class GrantDimens {
  GrantDimens._();

  static const double pagePadding = 20.0;
  static const double cardRadius = 16.0;
  static const double chipRadius = 8.0;
  static const double avatarSize = 52.0;
  static const double avatarSizeSm = 42.0;
  static const double sectionGap = 24.0;
  static const double itemGap = 10.0;
}
