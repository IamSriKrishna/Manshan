import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.title,
    required this.icon,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 4.h),

        SizedBox(
          height: 40.h,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            cursorColor: Colors.black,
            style: TextStyle(fontSize: 13.sp, color: Colors.black),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              suffixIcon: Icon(
                icon,
                size: 17.sp,
                color: Colors.black.withOpacity(0.45),
              ),
              enabledBorder: _border(Colors.black.withOpacity(0.20), 1),
              focusedBorder: _border(Colors.black, 1.6),
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
