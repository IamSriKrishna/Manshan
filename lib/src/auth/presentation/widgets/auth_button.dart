import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const AuthButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: onTap == null ? Colors.black.withOpacity(0.45) : Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.r),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}