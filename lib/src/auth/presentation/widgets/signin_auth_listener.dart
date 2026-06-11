import 'package:flutter/material.dart' hide Navigator;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_state.dart';
import 'package:manshan/src/dashboard/navigator.dart';

import '../bloc/auth_bloc.dart';

class SignInAuthListener extends StatelessWidget {
  final Widget child;

  const SignInAuthListener({
    super.key,
    required this.child,
  });

  void _showSnackBar(BuildContext context, String message) {
    if (message.isEmpty) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return previous.signinStatus != current.signinStatus;
      },
      listener: (context, state) {
        if (state.signinStatus == AuthStatus.failed) {
          _showSnackBar(context, state.errorMessage);
        }

     

        if (state.signinStatus == AuthStatus.loaded) {
          _showSnackBar(context, state.message);

          Get.off(()=> const Navigator());
          
        }
      },
      child: child,
    );
  }
}