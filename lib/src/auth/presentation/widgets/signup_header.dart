import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupHeader extends StatelessWidget {
  const SignupHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.close, size: 24.sp, color: Colors.black),

        SizedBox(height: 26.h),

        Text(
          "Create account",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 6.h),

        RichText(
          text: TextSpan(
            text: "Have an account? ",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black.withOpacity(0.65),
            ),
            children: const [
              TextSpan(
                text: "Login",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}