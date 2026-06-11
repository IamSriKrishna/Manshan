import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/src/employee/domain/entity/employee.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_bloc.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_event.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_state.dart';

class SalaryEmployeeRow extends StatelessWidget {
  const SalaryEmployeeRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalaryBloc, SalaryState>(
      builder: (context, state) {
        final employees = state.employees.data ;

        return SizedBox(
          height: 90.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: employees.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _AddButton();
              final emp = employees[index - 1];
              final isSelected =
                  state.selectedEmployees.any((e) => e.id == emp.id);
              return _EmployeeAvatar(
                employee: emp,
                isSelected: isSelected,
                index: index - 1,
              );
            },
          ),
        );
      },
    );
  }
}

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: const Color(0xFF111118),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.add_rounded,
              color: Colors.white.withOpacity(0.6),
              size: 22.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Add",
            style: TextStyle(
              fontSize: 11.sp,
              color: const Color(0xFF4A4A6A),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeAvatar extends StatelessWidget {
  final Employee employee;
  final bool isSelected;
  final int index;

  const _EmployeeAvatar({
    required this.employee,
    required this.isSelected,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final accent = _accent(index);

    return GestureDetector(
      onTap: () => context
          .read<SalaryBloc>()
          .add(ToggleEmployeeSelectionEvent(employee)),
      child: Padding(
        padding: EdgeInsets.only(right: 16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withOpacity(0.15),
                    border: Border.all(
                      color: isSelected ? accent : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      employee.name.isNotEmpty
                          ? employee.name[0].toUpperCase()
                          : "?",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: accent,
                      ),
                    ),
                  ),
                ),
                if (isSelected)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16.r,
                      height: 16.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accent,
                        border: Border.all(
                            color: const Color(0xFF0A0A0F), width: 1.5),
                      ),
                      child: Icon(Icons.check_rounded,
                          size: 9.sp, color: Colors.white),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 6.h),
            SizedBox(
              width: 52.w,
              child: Text(
                employee.name.split(" ").first,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isSelected ? Colors.white : const Color(0xFF4A4A6A),
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
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