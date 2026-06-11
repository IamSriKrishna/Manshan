import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/src/dashboard/domain/entity/dashboard.dart';

class DashboardTotalCostCard extends StatelessWidget {
  final Dashboard dashboard;
  const DashboardTotalCostCard({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.h,
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1040), Color(0xFF0D0D1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: const Color(0xFF6C63FF).withOpacity(0.18),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          // Glow blob top-right
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 140.r,
              height: 140.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF6C63FF).withOpacity(0.22),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Glow blob bottom-left
          Positioned(
            bottom: -40,
            left: -20,
            child: Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF3B82F6).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "TOTAL BALANCE",
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: const Color(0xFF6C63FF),
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        dashboard.totalCost,
                        style: TextStyle(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "₹1,546 spent last week",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF4A4A6A),
                        ),
                      ),
                    ],
                  ),
                  _TrendBadge(label: "+16.86%"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32.w,
                        height: 22.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.12),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 0.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "•••• •••• •••• 4291",
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF4A4A6A),
                          letterSpacing: 2.5,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                        ).createShader(bounds),
                        child: Text(
                          "MANSHAN",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      SizedBox(
                        width: 38.w,
                        child: Stack(
                          children: [
                            Container(
                              width: 22.r,
                              height: 22.r,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF6C63FF),
                              ),
                            ),
                            Positioned(
                              left: 14.w,
                              child: Container(
                                width: 22.r,
                                height: 22.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFF3B82F6).withOpacity(0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  final String label;
  const _TrendBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: const Color(0xFF00D084).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: const Color(0xFF00D084).withOpacity(0.25),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.trending_up_rounded,
            size: 12.sp,
            color: const Color(0xFF00D084),
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF00D084),
            ),
          ),
        ],
      ),
    );
  }
}