import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/src/dashboard/domain/entity/dashboard.dart';

class DashboardSitesCard extends StatelessWidget {
  final Dashboard dashboard;
  const DashboardSitesCard({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sites overview",
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 12.h),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 2.2,
            children: [
              _StatTile(
                icon: Icons.domain,
                label: "Total sites",
                value: "${dashboard.totalSites}",
                iconBg: Color(0xFFEEF2FF),
                iconColor: Color(0xFF4F46E5)
              ),
              _StatTile(
                icon: Icons.loop,
                label: "Ongoing",
                value: "${dashboard.ongoingSites}",
                iconBg: Color(0xFFEEF2FF),
                iconColor: Color(0xFF4F46E5)
              ),
              _StatTile(
                icon: Icons.check_circle_outline,
                label: "Completed",
                value: "${dashboard.completedSites}",
                iconBg: Color(0xFFEEF2FF),
                iconColor: Color(0xFF4F46E5)
              ),
              _StatTile(
                icon: Icons.group_outlined,
                label: "Employees",
                value: "${dashboard.totalEmployee}",
                iconBg: Color(0xFFEEF2FF),
                iconColor: Color(0xFF4F46E5)
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconBg;
  final Color iconColor;
const _StatTile({
  required this.icon,
  required this.label,
  required this.value,
  required this.iconBg,
  required this.iconColor,
});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 20.r, height: 20.r,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(6.r)),
              child: Icon(icon, size: 12.sp, color: iconColor),
            ),
            SizedBox(width: 5.w),
            Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.grey)),
          ]),
          SizedBox(height: 6.h),
          Text(value, style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}