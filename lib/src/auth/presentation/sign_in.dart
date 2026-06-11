import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_state.dart';
import 'package:manshan/src/auth/presentation/controller/signin_controller.dart';
import 'package:manshan/src/auth/presentation/widgets/auth_button.dart';
import 'package:manshan/src/auth/presentation/widgets/auth_text_field.dart';
import 'package:manshan/src/auth/presentation/widgets/auth_widgets.dart';
import 'package:manshan/src/auth/presentation/widgets/signin_auth_listener.dart';
import 'package:manshan/src/auth/presentation/widgets/signup_text.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInState();
}

class _SignInState extends State<SignInView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignInAuthListener(
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final isLoading = state.signinStatus == AuthStatus.loading;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.w),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthWidgets.authTopBar(),

                      SizedBox(height: 18.h),

                      AuthWidgets.signInImage(),

                      SizedBox(height: 26.h),

                      AuthTextField(
                        title: "E-Mail",
                        icon: Icons.email_outlined,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      SizedBox(height: 12.h),

                      AuthTextField(
                        title: "Password",
                        icon: Icons.lock_outline,
                        controller: passwordController,
                        obscureText: true,
                      ),

                      SizedBox(height: 22.h),

                      AuthButton(
                        title: isLoading ? "PLEASE WAIT..." : "SIGN IN",
                        onTap: isLoading
                            ? null
                            : () {
                                SignInController.signIn(
                                  context: context,
                                  emailController: emailController,
                                  passwordController: passwordController,
                                );
                              },
                      ),

                      SizedBox(height: 18.h),

                      const SignUpText(),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
