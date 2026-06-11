import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_bloc.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_event.dart';

class SalaryKeypad extends StatelessWidget {
  const SalaryKeypad({super.key});

  static const _keys = [
    ["1", "2", "3"],
    ["4", "5", "6"],
    ["7", "8", "9"],
    [".", "0", "⌫"],
  ];

  static const _quickAmounts = ["2000", "5000", "10000", "15000", "20000"];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Quick amounts
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: _quickAmounts.map((amt) {
              return GestureDetector(
                onTap: () {
                  context.read<SalaryBloc>().add(ClearAmountEvent());
                  for (final ch in amt.split('')) {
                    context.read<SalaryBloc>().add(AppendDigitEvent(ch));
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(right: 8.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF111118),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Text(
                    "₹$amt",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 16.h),

        // Keys
        ...List.generate(_keys.length, (row) {
          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: List.generate(3, (col) {
                final key = _keys[row][col];
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (key == "⌫") {
                        context.read<SalaryBloc>().add(DeleteDigitEvent());
                      } else {
                        context.read<SalaryBloc>().add(AppendDigitEvent(key));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      height: 56.h,
                      decoration: BoxDecoration(
                        color: key == "⌫"
                            ? const Color(0xFF1A1A2E)
                            : const Color(0xFF111118),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      child: Center(
                        child: key == "⌫"
                            ? Icon(
                                Icons.backspace_outlined,
                                size: 18.sp,
                                color: Colors.white.withOpacity(0.6),
                              )
                            : Text(
                                key,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ],
    );
  }
}
