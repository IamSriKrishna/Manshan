import 'package:bottom_navigator/bottom_navigator.dart';
import 'package:flutter/cupertino.dart' hide NavigatorState;
import 'package:flutter/material.dart' hide NavigatorState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/core/service/service_locator.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_event.dart';
import 'package:manshan/src/construction/presentation/construction.dart';
import 'package:manshan/src/dashboard/dashboard.dart';
import 'package:manshan/src/dashboard/presentation/bloc/navigator_bloc.dart';
import 'package:manshan/src/employee/employee.dart';

class Navigator extends StatefulWidget {
  const Navigator({super.key});

  @override
  State<Navigator> createState() => _NavigatorState();
}

class _NavigatorState extends State<Navigator> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<NavigatorBloc>()),
        BlocProvider(
          create: (context) => sl<AuthBloc>()..add(AuthMeRequestedEvent()),
        ),
      ],
      child: BlocBuilder<NavigatorBloc, NavigatorState>(
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            body: _screens[state.index],
            bottomNavigationBar: FloatingNavBottomBar(
              blurAmount: 0,
              backgroundColor: CupertinoColors.black,
              unselectedItemColor: CupertinoColors.systemGrey,
              indicatorColors: [Colors.transparent],
              margin:  EdgeInsets.symmetric(horizontal: 90.w, vertical: 20.h),
              onTap: (value) {
                context.read<NavigatorBloc>().add(
                  SelectScreenEvent(index: value),
                );
              },
              borderRadius: 10,
              items: [
                BottomNavItem(
                  icon: Icons.home,
                  label: 'Home',
                  screen: Dashboard(),
                ),
                BottomNavItem(icon: Icons.person, label: 'Employee'),
                BottomNavItem(icon: Icons.build, label: 'Construction'),
              ],
              currentIndex: state.index,
            ),
          );
        },
      ),
    );
  }

  final List<Widget> _screens = [
    Dashboard(),
    Employee(),
    Construction(),
  ];
}
