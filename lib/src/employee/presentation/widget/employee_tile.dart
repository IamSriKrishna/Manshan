import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/src/employee/domain/entity/employee.dart';

class EmployeeTile extends StatelessWidget {
  final Employee employee;
  final int index;

  const EmployeeTile({
    super.key,
    required this.employee,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = employee.status.toLowerCase() == "active";
    final accent = _accent(index);

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 48.r,
            width: 48.r,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: accent.withOpacity(0.25), width: 0.5),
            ),
            child: Center(
              child: Text(
                employee.name.isNotEmpty
                    ? employee.name[0].toUpperCase()
                    : "?",
                style: TextStyle(
                  color: accent,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.name,
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
                    Text(
                      employee.role,
                      style: TextStyle(
                        color: const Color(0xFF4A4A6A),
                        fontSize: 11.sp,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Container(
                        width: 3.r,
                        height: 3.r,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF4A4A6A),
                        ),
                      ),
                    ),
                    Text(
                      employee.salaryType,
                      style: TextStyle(
                        color: const Color(0xFF4A4A6A),
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                employee.defaultSalary.isEmpty
                    ? "—"
                    : "₹${double.tryParse(employee.defaultSalary)!.round()}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF00D084).withOpacity(0.1)
                      : const Color(0xFFFF9500).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(7.r),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF00D084).withOpacity(0.2)
                        : const Color(0xFFFF9500).withOpacity(0.2),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  isActive ? "ACTIVE" : "INACTIVE",
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFF00D084)
                        : const Color(0xFFFF9500),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _accent(int i) {
    const colors = [
      Color(0xFF6C63FF),
      Color(0xFF3B82F6),
      Color(0xFF00D084),
      Color(0xFFFF9500),
      Color(0xFFEC4899),
    ];
    return colors[i % colors.length];
  }
}