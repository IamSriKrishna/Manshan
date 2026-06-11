import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupTextField extends StatelessWidget {
  final String title;
  final bool obscureText;
  final IconData? suffixIcon;
  final ValueChanged<String>? onChanged;

  const SignupTextField({
    super.key,
    required this.title,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 6.h),

        SizedBox(
          height: 44.h,
          child: TextField(
            onChanged: onChanged,
            obscureText: obscureText,
            cursorColor: Colors.black,
            style: TextStyle(fontSize: 14.sp, color: Colors.black),
            decoration: InputDecoration(
              hintText: "Enter",
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.black.withOpacity(0.45),
              ),
              suffixIcon: suffixIcon == null
                  ? null
                  : Icon(
                      suffixIcon,
                      size: 19.sp,
                      color: Colors.black.withOpacity(0.65),
                    ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              enabledBorder: _border(Colors.black.withOpacity(0.18)),
              focusedBorder: _border(Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: color, width: 1),
    );
  }
}