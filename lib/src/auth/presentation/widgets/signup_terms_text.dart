import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupTermsText extends StatelessWidget {
  const SignupTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          text: "By registering, you accept Manshan's ",
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black.withOpacity(0.55),
            fontWeight: FontWeight.w500,
          ),
          children: const [
            TextSpan(
              text: "Terms & Conditions\n",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
            TextSpan(text: "and "),
            TextSpan(
              text: "Privacy Policy.",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}