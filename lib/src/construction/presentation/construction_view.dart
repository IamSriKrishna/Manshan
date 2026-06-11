import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_bloc.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_event.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_state.dart';
import 'package:manshan/src/construction/presentation/widget/construction_paginated.dart';
import 'package:manshan/src/construction/presentation/widget/construction_search.dart';
import 'package:manshan/src/construction/presentation/widget/construction_site_header.dart';
import 'package:manshan/src/construction/presentation/widget/construction_site_tile.dart';
import 'package:manshan/src/construction/presentation/widget/construction_summary_card.dart';
import 'package:manshan/src/construction/presentation/create_construction_site_view.dart';
import 'package:manshan/src/construction/presentation/create_employee_site_assignment_view.dart';
import 'package:manshan/src/construction/presentation/create_site_entry_view.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_bloc.dart';

class ConstructionView extends StatefulWidget {
  const ConstructionView({super.key});

  @override
  State<ConstructionView> createState() => _ConstructionViewState();
}

class _ConstructionViewState extends State<ConstructionView> {
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
      context.read<ConstructionBloc>().add(LoadMoreConstructionSitesEvent());
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
        floatingActionButton: _ActionButtons(),
        body: BlocBuilder<ConstructionBloc, ConstructionState>(
          builder: (context, state) {
            final sites = state.allSites.data;
            final isLoading = state.siteStatus == EmployeeStatus.loading;
            final isPaginating =
                state.paginationStatus == EmployeeStatus.loading;
            final ongoingCount = sites
                .where((s) => s.status.toUpperCase() == "ONGOING")
                .length;
            final completedCount = sites
                .where((s) => s.status.toUpperCase() == "COMPLETED")
                .length;

            return CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 56.h, 16.w, 0),
                  sliver: SliverToBoxAdapter(
                    child: ConstructionHeader(total: state.allSites.total),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 0),
                  sliver: SliverToBoxAdapter(
                    child: ConstructionSummaryCard(
                      total: state.allSites.total,
                      ongoing: ongoingCount,
                      completed: completedCount,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                  sliver: SliverToBoxAdapter(
                    child: ConstructionSearchBar(onChanged: (_) {}),
                  ),
                ),
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
                                Color(0xFF3B82F6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                else if (sites.isEmpty)
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 60.h, 16.w, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Icon(
                            Icons.domain_outlined,
                            size: 40.sp,
                            color: const Color(0xFF2A2A3A),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            "No construction sites found",
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
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
                    sliver: SliverList.separated(
                      itemCount: sites.length,
                      separatorBuilder: (_, __) => SizedBox(height: 10.h),
                      itemBuilder: (context, index) => ConstructionSiteTile(
                        site: sites[index],
                        index: index,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: isPaginating
                        ? const ConstructionPaginationLoader()
                        : !state.hasMore
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Center(
                                  child: Text(
                                    "All sites loaded",
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
                SliverToBoxAdapter(child: SizedBox(height: 120.h)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ActionButtons extends StatefulWidget {
  @override
  State<_ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<_ActionButtons>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _FabMenuItem(
                  value: _animation.value,
                  icon: Icons.add_business_rounded,
                  label: "New Site",
                  onTap: () {
                    _toggle();
                    final bloc = context.read<ConstructionBloc>();
                    Get.to(() => BlocProvider.value(
                          value: bloc,
                          child: const CreateConstructionSiteView(),
                        ));
                  },
                ),
                SizedBox(height: 10.h * _animation.value),
                _FabMenuItem(
                  value: _animation.value,
                  icon: Icons.person_add_alt_1_rounded,
                  label: "Assign Employee",
                  onTap: () {
                    _toggle();
                    final constructionBloc = context.read<ConstructionBloc>();
                    final employeeBloc = context.read<EmployeeBloc>();
                    Get.to(() => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(value: constructionBloc),
                            BlocProvider.value(value: employeeBloc),
                          ],
                          child: const CreateEmployeeSiteAssignmentView(),
                        ));
                  },
                ),
                SizedBox(height: 10.h * _animation.value),
                _FabMenuItem(
                  value: _animation.value,
                  icon: Icons.receipt_long_rounded,
                  label: "Site Entry",
                  onTap: () {
                    _toggle();
                    final bloc = context.read<ConstructionBloc>();
                    Get.to(() => BlocProvider.value(
                          value: bloc,
                          child: const CreateSiteEntryView(),
                        ));
                  },
                ),
                SizedBox(height: 12.h * _animation.value),
              ],
            );
          },
        ),
        GestureDetector(
          onTap: _toggle,
          child: Container(
            height: 52.r,
            width: 52.r,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: AnimatedRotation(
              turns: _expanded ? 0.125 : 0,
              duration: const Duration(milliseconds: 220),
              child: Icon(Icons.add_rounded, color: Colors.white, size: 26.sp),
            ),
          ),
        ),
      ],
    );
  }
}

class _FabMenuItem extends StatelessWidget {
  final double value;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FabMenuItem({
    required this.value,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (value == 0) return const SizedBox.shrink();
    return Opacity(
      opacity: value,
      child: Transform.translate(
        offset: Offset(0, 10 * (1 - value)),
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 0.5,
                  ),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Container(
                height: 40.r,
                width: 40.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 0.5,
                  ),
                ),
                child: Icon(icon, color: const Color(0xFF6C63FF), size: 18.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}