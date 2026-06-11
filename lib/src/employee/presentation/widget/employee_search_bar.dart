import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmployeeSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const EmployeeSearchBar({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: const Color(0xFF4A4A6A),
            size: 20.sp,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
              decoration: InputDecoration(
                hintText: "Search employee...",
                hintStyle: TextStyle(
                  color: const Color(0xFF4A4A6A),
                  fontSize: 13.sp,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: const Color(0xFF4A4A6A),
              size: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}