import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/core/service/service_locator.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_bloc.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_event.dart';
import 'package:manshan/src/employee/presentation/employee_view.dart';

class Employee extends StatelessWidget {
  const Employee({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (_) => sl<EmployeeBloc>()..add(GetAllEmployeeRequestEvent()),
      child: EmployeeView(),
    );
  }
}