import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/src/dashboard/domain/entity/dashboard.dart';

class DashboardCostBreakdownCard extends StatelessWidget {
  final Dashboard dashboard;

  const DashboardCostBreakdownCard({super.key, required this.dashboard});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "COST BREAKDOWN",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A4A6A),
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "This month",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C63FF).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Icon(
                  Icons.donut_large_rounded,
                  size: 16.sp,
                  color: const Color(0xFF6C63FF),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _BreakdownRow(
            icon: Icons.account_balance_wallet_outlined,
            title: "Salary",
            amount: dashboard.salaryCost,
            totalCost: dashboard.totalCost,
            accentColor: const Color(0xFF6C63FF),
          ),
          SizedBox(height: 14.h),
          _BreakdownRow(
            icon: Icons.inventory_2_outlined,
            title: "Material",
            amount: dashboard.materialCost,
            totalCost: dashboard.totalCost,
            accentColor: const Color(0xFF3B82F6),
          ),
          SizedBox(height: 14.h),
          _BreakdownRow(
            icon: Icons.more_horiz_rounded,
            title: "Others",
            amount: dashboard.otherExpenses,
            totalCost: dashboard.totalCost,
            accentColor: const Color(0xFF00D084),
          ),
        ],
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;
  final String totalCost;
  final Color accentColor;

  const _BreakdownRow({
    required this.icon,
    required this.title,
    required this.amount,
    required this.totalCost,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = _percentage(amount, totalCost);
    final progress = (percentage / 100).clamp(0.0, 1.0);

    return Row(
      children: [
        Container(
          height: 38.r,
          width: 38.r,
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(11.r),
            border: Border.all(
              color: accentColor.withOpacity(0.2),
              width: 0.5,
            ),
          ),
          child: Icon(icon, size: 16.sp, color: accentColor),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                  Text(
                    "${percentage.toStringAsFixed(0)}%",
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: accentColor.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 5.h,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 14.w),
        Text(
          amount.isEmpty ? "₹0" : amount,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  double _percentage(String amount, String totalCost) {
    final a = _parse(amount);
    final t = _parse(totalCost);
    if (t <= 0 || a <= 0) return 0;
    return (a / t) * 100;
  }

  double _parse(String value) =>
      double.tryParse(value.replaceAll('₹', '').replaceAll(',', '').trim()) ?? 0;
}