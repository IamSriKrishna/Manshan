import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:manshan/core/service/service_locator.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_bloc.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_event.dart';
import 'package:manshan/src/construction/presentation/construction_view.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_bloc.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_event.dart';

class Construction extends StatelessWidget {
  const Construction({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConstructionBloc>(
          create: (_) =>
              sl<ConstructionBloc>()..add(GetAllConstructionSitesRequestEvent()),
        ),
        // EmployeeBloc is needed by CreateEmployeeSiteAssignmentView
        // to populate the employee selection list
        BlocProvider<EmployeeBloc>(
          create: (_) =>
              sl<EmployeeBloc>()..add(GetAllEmployeeRequestEvent()),
        ),
      ],
      child: const ConstructionView(),
    );
  }
}