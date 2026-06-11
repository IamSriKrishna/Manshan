import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConstructionSummaryCard extends StatelessWidget {
  final int total;
  final int ongoing;
  final int completed;

  const ConstructionSummaryCard({
    super.key,
    required this.total,
    required this.ongoing,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D1A10), Color(0xFF0D0D1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.18),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 130.r,
              height: 130.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF3B82F6).withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -20,
            child: Container(
              width: 110.r,
              height: 110.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00D084).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    title: "Total",
                    value: "$total",
                    icon: Icons.domain_rounded,
                    accent: const Color(0xFF6C63FF),
                  ),
                ),
                _Divider(),
                Expanded(
                  child: _SummaryItem(
                    title: "Ongoing",
                    value: "$ongoing",
                    icon: Icons.construction_rounded,
                    accent: const Color(0xFF00D084),
                  ),
                ),
                _Divider(),
                Expanded(
                  child: _SummaryItem(
                    title: "Completed",
                    value: "$completed",
                    icon: Icons.check_circle_outline_rounded,
                    accent: const Color(0xFF3B82F6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color accent;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 38.r,
            width: 38.r,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13.r),
              border: Border.all(color: accent.withOpacity(0.2), width: 0.5),
            ),
            child: Icon(icon, color: accent, size: 19.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            title,
            style: TextStyle(fontSize: 11.sp, color: const Color(0xFF4A4A6A)),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.5,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      color: Colors.white.withOpacity(0.07),
    );
  }
}
