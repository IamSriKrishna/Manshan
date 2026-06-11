import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_bloc.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_event.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_state.dart';

class SalaryPaymentOptions extends StatelessWidget {
  const SalaryPaymentOptions({super.key});

  static const _modes = ["CASH", "BANK", "UPI", "CHEQUE"];
  static const _types = ["DAILY", "WEEKLY", "MONTHLY"];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalaryBloc, SalaryState>(
      buildWhen: (p, c) =>
          p.paymentMode != c.paymentMode || p.salaryType != c.salaryType,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment mode
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _modes.map((mode) {
                  final isSelected = state.paymentMode == mode;
                  return GestureDetector(
                    onTap: () => context.read<SalaryBloc>().add(
                      UpdatePaymentModeEvent(mode),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(right: 8.w),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF6C63FF).withOpacity(0.15)
                            : const Color(0xFF111118),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF6C63FF).withOpacity(0.5)
                              : Colors.white.withOpacity(0.06),
                        ),
                      ),
                      child: Text(
                        mode,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? const Color(0xFF6C63FF)
                              : const Color(0xFF4A4A6A),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 10.h),

            // Salary type
            Row(
              children: _types.map((type) {
                final isSelected = state.salaryType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => context.read<SalaryBloc>().add(
                      UpdateSalaryTypeEvent(type),
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: type != _types.last ? 8.w : 0,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF3B82F6).withOpacity(0.12)
                            : const Color(0xFF111118),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF3B82F6).withOpacity(0.4)
                              : Colors.white.withOpacity(0.06),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          type,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFF4A4A6A),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
