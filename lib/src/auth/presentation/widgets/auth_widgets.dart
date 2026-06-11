import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthWidgets {
  static Widget authTopBar() {
    return SizedBox(
      height: 45.h,
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 18.sp,
          ),
          const Spacer(),
          SizedBox(
            width: 76.w,
            height: 34.h,
            child: authLogo(),
          ),
        ],
      ),
    );
  }

  static Widget authTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 28.sp,
        fontWeight: FontWeight.w900,
        color: Colors.black,
      ),
    );
  }

static Widget signInImage() {
  return Center(
    child: Image.asset(
      "assets/sign_in.png",
      width: double.infinity,
      height: 300.h,
      fit: BoxFit.cover,
    ),
  );
}

  static Widget authLogo() {
    return Image.asset(
      "assets/logo.png",
      color: Colors.black,
      fit: BoxFit.contain,
    );
  }
}