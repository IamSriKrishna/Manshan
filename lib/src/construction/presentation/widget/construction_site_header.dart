import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConstructionHeader extends StatelessWidget {
  final int total;

  const ConstructionHeader({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Construction Sites",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "$total sites registered",
              style: TextStyle(fontSize: 12.sp, color: const Color(0xFF4A4A6A)),
            ),
          ],
        ),
        Container(
          height: 40.r,
          width: 40.r,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.domain_rounded, color: Colors.white, size: 20.sp),
        ),
      ],
    );
  }
}
