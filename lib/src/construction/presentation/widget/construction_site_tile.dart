import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:manshan/src/construction/domain/entity/construction_site.dart';
import 'package:manshan/src/construction/presentation/construction_site_detail_view.dart';

class ConstructionSiteTile extends StatelessWidget {
  final ConstructionSite site;
  final int index;

  const ConstructionSiteTile({
    super.key,
    required this.site,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _accent(index);
    final statusColor = _statusColor(site.status);

    return GestureDetector(
      onTap: () {
        Get.to(() => ConstructionSiteDetail(site: site));
      },
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: const Color(0xFF111118),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 48.r,
                  width: 48.r,
                  decoration: BoxDecoration(
                    color: accent.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                        color: accent.withOpacity(0.25), width: 0.5),
                  ),
                  child: Center(
                    child: Icon(Icons.location_city_rounded,
                        color: accent, size: 22.sp),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        site.siteName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.place_outlined,
                              size: 11.sp, color: const Color(0xFF4A4A6A)),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              site.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: const Color(0xFF4A4A6A),
                                  fontSize: 11.sp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(7.r),
                    border: Border.all(
                        color: statusColor.withOpacity(0.2), width: 0.5),
                  ),
                  child: Text(
                    site.status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(height: 0.5, color: Colors.white.withOpacity(0.05)),
            SizedBox(height: 12.h),
            Row(
              children: [
                _InfoChip(
                  icon: Icons.person_outline_rounded,
                  label:
                      site.clientName.isEmpty ? "—" : site.clientName,
                ),
                SizedBox(width: 10.w),
                _InfoChip(
                  icon: Icons.calendar_today_outlined,
                  label:
                      "${site.startDate.day} ${_monthName(site.startDate.month)} ${site.startDate.year}",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "ONGOING":   return const Color(0xFF00D084);
      case "COMPLETED": return const Color(0xFF3B82F6);
      case "PAUSED":    return const Color(0xFFFF9500);
      case "CANCELLED": return const Color(0xFFEF4444);
      default:          return const Color(0xFF4A4A6A);
    }
  }

  Color _accent(int i) {
    const colors = [
      Color(0xFF6C63FF), Color(0xFF3B82F6), Color(0xFF00D084),
      Color(0xFFFF9500), Color(0xFFEC4899),
    ];
    return colors[i % colors.length];
  }

  String _monthName(int month) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec",
    ];
    return months[month - 1];
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11.sp, color: const Color(0xFF4A4A6A)),
        SizedBox(width: 4.w),
        Text(label,
            style: TextStyle(
                color: const Color(0xFF4A4A6A), fontSize: 11.sp)),
      ],
    );
  }
}