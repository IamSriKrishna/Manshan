import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/core/service/service_locator.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_bloc.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_event.dart';
import 'package:manshan/src/salary/presentation/salary_view.dart';

class SalaryScreen extends StatelessWidget {
  const SalaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SalaryBloc>()
        ..add(LoadEmployeesEvent())
        ..add(LoadTransactionHistoryEvent()),
      child: const SalaryView(),
    );
  }
}