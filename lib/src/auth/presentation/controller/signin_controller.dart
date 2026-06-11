import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_event.dart';

import '../bloc/auth_bloc.dart';

class SignInController {
  static void signIn({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) {
    FocusScope.of(context).unfocus();

    context.read<AuthBloc>().add(
          SignInRequestedEvent(
            email: emailController.text,
            password: passwordController.text,
          ),
        );
  }
}