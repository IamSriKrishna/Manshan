import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' hide Transition;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_bloc.dart';
import 'package:manshan/src/employee/presentation/create_employee_view.dart';

class EmployeeHeader extends StatelessWidget {
  final int total;

  const EmployeeHeader({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Employees",
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "Manage your workers",
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF4A4A6A),
              ),
            ),
          ],
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => Get.to(
            () => BlocProvider.value(
              value: context.read<EmployeeBloc>(),
              child: const CreateEmployeeView(),
            ),
            transition: Transition.cupertino,
          ),
          child: Container(
            height: 42.r,
            width: 42.r,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(Icons.add_rounded, color: Colors.white, size: 24.sp),
          ),
        ),
      ],
    );
  }
}