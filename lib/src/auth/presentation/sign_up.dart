import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/src/auth/presentation/bloc/rule_bloc.dart';

import 'package:manshan/src/auth/presentation/widgets/password_rules.dart';
import 'package:manshan/src/auth/presentation/widgets/signup_button.dart';
import 'package:manshan/src/auth/presentation/widgets/signup_header.dart';
import 'package:manshan/src/auth/presentation/widgets/signup_terms_text.dart';
import 'package:manshan/src/auth/presentation/widgets/signup_text_field.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RuleBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 18.h),

                const SignupHeader(),

                SizedBox(height: 36.h),

                const SignupTextField(title: "Email"),

                SizedBox(height: 16.h),

                SignupTextField(
                  title: "Password",
                  obscureText: true,
                  suffixIcon: Icons.visibility_off_outlined,
                  onChanged: (value) {
                    context.read<RuleBloc>().add(
                          PasswordChanged(value),
                        );
                  },
                ),

                SizedBox(height: 16.h),

                const SignupTextField(
                  title: "Confirm password",
                  obscureText: true,
                  suffixIcon: Icons.visibility_outlined,
                ),

                SizedBox(height: 16.h),

                const PasswordRules(),

                SizedBox(height: 42.h),

                SignupButton(
                  title: "Continue",
                  onTap: () {},
                ),

                SizedBox(height: 24.h),

                const SignupTermsText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}