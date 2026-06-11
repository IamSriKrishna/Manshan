import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:manshan/core/service/service_locator.dart';
import 'package:manshan/src/grant/grant.dart';
import 'package:manshan/src/grant/presentation/bloc/grant_bloc.dart';
import 'package:manshan/src/salary/salary.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.send_rounded,
            label: "Payment",
            subtitle: "Send salary",
            gradient: const [Color(0xFF6C63FF), Color(0xFF4F46E5)],
            onTap: () {
              Get.to(() => SalaryScreen());
            },
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _ActionCard(
            icon: Icons.person_add_rounded,
            label: "Access",
            subtitle: "access to user",
            gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            onTap: () {
              Get.to(
                () => BlocProvider(
                  create: (context) => sl<GrantBloc>(),
                  child: GrantView(),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _ActionCard(
            icon: Icons.upcoming_rounded,
            label: "Upcoming",
            subtitle: "Due payments",
            gradient: const [Color(0xFF0EA5E9), Color(0xFF0369A1)],
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: const Color(0xFF111118),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: gradient[0].withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 18.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: TextStyle(fontSize: 10.sp, color: const Color(0xFF4A4A6A)),
            ),
          ],
        ),
      ),
    );
  }
}
