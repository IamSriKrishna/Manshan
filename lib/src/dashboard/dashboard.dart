import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/core/service/service_locator.dart';
import 'package:manshan/src/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:manshan/src/dashboard/presentation/bloc/dashboard_event.dart';
import 'package:manshan/src/dashboard/presentation/dashboard_view.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DashboardBloc>()
        ..add(DashboardRequestEvent())
        ..add(LastTransactionRequestEvent()),
      child: DashboardView(),
    );
  }
}
