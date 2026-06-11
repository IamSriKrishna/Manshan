import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:manshan/src/auth/presentation/sign_up.dart';

class SignUpText extends StatelessWidget {
  const SignUpText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
              text: "Sign Up",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Get.to(() => const SignUp());
                },
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}