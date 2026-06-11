import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/core/extra/logout_dailog.dart';

class DashboardAppbar extends StatelessWidget {
  final String name;
  const DashboardAppbar({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFF0A0A0F),
      elevation: 0,
      floating: true,
      expandedHeight: 72.h,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: const Color(0xFF0A0A0F),
          padding: EdgeInsets.fromLTRB(20.w, 48.h, 20.w, 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Good Morning, ",
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: const Color(0xFF8A8A9A),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.1,
                            ),
                          ),
                          TextSpan(
                            text: name,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "Here's your financial overview",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color(0xFF4A4A5A),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  showLogoutDialog(context);
                },
                child: Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.dangerous,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}