import 'package:flutter/material.dart' hide Navigator;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:manshan/core/service/service_locator.dart';
import 'package:manshan/core/service/storage_service.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_event.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_state.dart';
import 'package:manshan/src/auth/sign_in.dart';
import 'package:manshan/src/dashboard/navigator.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}
class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuth();
    });
  }

  Future<void> checkAuth() async {
    final storage = sl<StorageService>();

    if (storage.token.isEmpty) {
      Get.offAll(() => const SignIn());
      return;
    }

    context.read<AuthBloc>().add(AuthMeRequestedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state.authMeStatus == AuthStatus.loaded) {
          Get.offAll(() => const Navigator());
        }

        if (state.authMeStatus == AuthStatus.failed) {
          await sl<StorageService>().clearToken();
          Get.offAll(() => const SignIn());
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}