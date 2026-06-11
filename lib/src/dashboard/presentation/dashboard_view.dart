import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:manshan/src/auth/presentation/bloc/auth_state.dart';
import 'package:manshan/src/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:manshan/src/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:manshan/src/dashboard/presentation/widget/dashboard_appbar.dart';
import 'package:manshan/src/dashboard/presentation/widget/dashboard_cost_breakdown_card.dart';
import 'package:manshan/src/dashboard/presentation/widget/dashboard_last_transaction_card.dart';
import 'package:manshan/src/dashboard/presentation/widget/dashboard_quick_actions.dart';
import 'package:manshan/src/dashboard/presentation/widget/dashboard_total_cost_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, auth) {
            return BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, dashboard) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    DashboardAppbar(name: auth.user.name),
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 32.h),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          DashboardTotalCostCard(
                            dashboard: dashboard.dashboard,
                          ),
                          SizedBox(height: 14.h),
                          const DashboardQuickActions(),
                          SizedBox(height: 14.h),
                          DashboardCostBreakdownCard(
                            dashboard: dashboard.dashboard,
                          ),
                          SizedBox(height: 12.h),
                          DashboardLastTransactionCard(
                            transactions: dashboard.lastTransaction,
                          ),
                          SizedBox(height: 80.h),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}