import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/src/auth/presentation/bloc/rule_bloc.dart';

class PasswordRules extends StatelessWidget {
  const PasswordRules({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RuleBloc, RuleState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your password must have:",
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w800,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 8.h),

            _rule("Minimum 8 characters", state.hasMinLength),
            _rule("1 upper case letter (A-Z)", state.hasUppercase),
            _rule("1 lower case letter (a-z)", state.hasLowercase),
            _rule("1 special character (!@#\$%)", state.hasSpecialChar),
          ],
        );
      },
    );
  }

  Widget _rule(String text, bool active) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Icon(
            active ? Icons.check : Icons.circle,
            size: active ? 13.sp : 5.sp,
            color: active ? Colors.black : Colors.black.withOpacity(0.35),
          ),
          SizedBox(width: 7.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 11.sp,
              color: active ? Colors.black : Colors.black.withOpacity(0.55),
              fontWeight: active ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}