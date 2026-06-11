import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/core/service/service_locator.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:manshan/src/auth/presentation/sign_in.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: const SignInView(),
    );
  }
}