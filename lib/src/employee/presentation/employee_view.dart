import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_bloc.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_event.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_state.dart';
import 'package:manshan/src/employee/presentation/widget/employee_header.dart';
import 'package:manshan/src/employee/presentation/widget/employee_pagination_loader.dart';
import 'package:manshan/src/employee/presentation/widget/employee_search_bar.dart';
import 'package:manshan/src/employee/presentation/widget/employee_summary_card.dart';
import 'package:manshan/src/employee/presentation/widget/employee_tile.dart';

class EmployeeView extends StatefulWidget {
  const EmployeeView({super.key});

  @override
  State<EmployeeView> createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<EmployeeBloc>().add(LoadMoreEmployeeEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, state) {
            final employees = state.allEmployee.data;
            final isLoading = state.employeeStatus == EmployeeStatus.loading;
            final isPaginating =
                state.paginationStatus == EmployeeStatus.loading;
            final activeCount =
                employees.where((e) => e.status.toLowerCase() == "active").length;
            final inactiveCount = employees.length - activeCount;

            return CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Header
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 56.h, 16.w, 0),
                  sliver: SliverToBoxAdapter(
                    child: EmployeeHeader(
                      total: state.allEmployee.total,
                    ),
                  ),
                ),

                // Summary card
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0),
                  sliver: SliverToBoxAdapter(
                    child: EmployeeSummaryCard(
                      total: state.allEmployee.total,
                      active: activeCount,
                      inactive: inactiveCount,
                    ),
                  ),
                ),

                // Search bar
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                  sliver: SliverToBoxAdapter(
                    child: EmployeeSearchBar(onChanged: (_) {}),
                  ),
                ),

                // Loading shimmer
                if (isLoading)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0),
                    sliver: SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40.h),
                          child: SizedBox(
                            width: 26.r,
                            height: 26.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF6C63FF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else if (employees.isEmpty)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 60.h, 16.w, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            size: 40.sp,
                            color: const Color(0xFF2A2A3A),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "No employees found",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF4A4A6A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  // Employee list
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                    sliver: SliverList.separated(
                      itemCount: employees.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) => EmployeeTile(
                        employee: employees[index],
                        index: index,
                      ),
                    ),
                  ),

                  // Pagination loader
                  SliverToBoxAdapter(
                    child: isPaginating
                        ? const EmployeePaginationLoader()
                        : !state.hasMore
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Center(
                                  child: Text(
                                    "All employees loaded",
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                      color: const Color(0xFF2A2A3A),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(height: 32.h),
                  ),
                ],
                SliverToBoxAdapter(child: SizedBox(height: 100.h,),)
              ],
            );
          },
        ),
      ),
    );
  }
}