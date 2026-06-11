import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordText extends StatelessWidget {
  const ForgotPasswordText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Forgot your password?",
        style: TextStyle(
          fontSize: 10.sp,
          color: Colors.black.withOpacity(0.35),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}