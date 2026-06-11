import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_bloc.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_event.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_state.dart';
import 'package:manshan/src/salary/presentation/widget/salary_date_range_sheet.dart';
import 'package:manshan/src/salary/presentation/widget/salary_employee_row.dart';
import 'package:manshan/src/salary/presentation/widget/salary_keypad.dart';
import 'package:manshan/src/salary/presentation/widget/salary_payment_options.dart';
import 'package:manshan/src/salary/presentation/widget/transaction_history_list.dart';

class SalaryView extends StatelessWidget {
  const SalaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: BlocListener<SalaryBloc, SalaryState>(
          listenWhen: (p, c) =>
              p.submitStatus != c.submitStatus &&
              (c.submitStatus == EmployeeStatus.success ||
                  c.submitStatus == EmployeeStatus.failure),
          listener: (context, state) {
            if (state.submitStatus == EmployeeStatus.success) {
              context.read<SalaryBloc>().add(LoadTransactionHistoryEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text(state.message,
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  backgroundColor: const Color(0xFF00D084),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  margin: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 0),
                ),
              );
            } else if (state.submitStatus == EmployeeStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.error_outline,
                          color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(state.errorMessage,
                            style: TextStyle(fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFFEF4444),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r)),
                  margin: EdgeInsets.fromLTRB(16.r, 16.r, 16.r, 0),
                ),
              );
            }
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: const SalaryEmployeeRow(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
                  child: const _AmountCard(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                  child: const _DateRangeSelector(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 0),
                  child: const SalaryPaymentOptions(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                  child: const SalaryKeypad(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                  child: const _SendButton(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 8.h),
                  child: _buildHistoryHeader(),
                ),
              ),
              const TransactionHistoryList(),
              SliverToBoxAdapter(child: SizedBox(height: 140.h)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 56.h, 20.w, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (b) => const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                ).createShader(b),
                child: Text(
                  "Send Money",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                "Pay employee salaries instantly",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: const Color(0xFF4A4A6A),
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: const Color(0xFF111118),
              borderRadius: BorderRadius.circular(12.r),
              border:
                  Border.all(color: Colors.white.withOpacity(0.06)),
            ),
            child: Icon(Icons.history_rounded,
                color: Colors.white.withOpacity(0.7), size: 18.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryHeader() {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 16.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          "Transaction History",
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalaryBloc, SalaryState>(
      buildWhen: (p, c) =>
          p.amount != c.amount ||
          p.selectedEmployees != c.selectedEmployees,
      builder: (context, state) {
        final display = state.amount.isEmpty ? "0" : state.amount;
        final hasSelection = state.selectedEmployees.isNotEmpty;

        return Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A1040), Color(0xFF0D0D1A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: const Color(0xFF6C63FF).withOpacity(0.2),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -20,
                right: -10,
                child: Container(
                  width: 100.r,
                  height: 100.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      const Color(0xFF6C63FF).withOpacity(0.15),
                      Colors.transparent,
                    ]),
                  ),
                ),
              ),
              Column(
                children: [
                  // Card chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 14.w, vertical: 7.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.06),
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 24.r,
                              height: 16.r,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6C63FF),
                                    Color(0xFF3B82F6)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "**** 7643",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white.withOpacity(0.6),
                                fontFamily: 'monospace',
                                letterSpacing: 1,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Icon(Icons.keyboard_arrow_down_rounded,
                                size: 16.sp,
                                color: Colors.white.withOpacity(0.4)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 18.h),

                  // Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "₹",
                        style: TextStyle(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w300,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        display,
                        style: TextStyle(
                          fontSize: 52.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -2,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  // Status pill
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: hasSelection
                          ? const Color(0xFF6C63FF).withOpacity(0.12)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: hasSelection
                            ? const Color(0xFF6C63FF).withOpacity(0.3)
                            : Colors.white.withOpacity(0.06),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasSelection
                                ? const Color(0xFF6C63FF)
                                : const Color(0xFF4A4A6A),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          hasSelection
                              ? "${state.selectedEmployees.length} employee${state.selectedEmployees.length > 1 ? 's' : ''} selected"
                              : "Select employees above",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: hasSelection
                                ? const Color(0xFF6C63FF)
                                : const Color(0xFF4A4A6A),
                            fontWeight: hasSelection
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DateRangeSelector extends StatelessWidget {
  const _DateRangeSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalaryBloc, SalaryState>(
      buildWhen: (p, c) =>
          p.fromDate != c.fromDate || p.toDate != c.toDate,
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _showDateSheet(context),
          child: Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: const Color(0xFF111118),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: state.fromDate != null
                    ? const Color(0xFF3B82F6).withOpacity(0.3)
                    : Colors.white.withOpacity(0.06),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.date_range_rounded,
                      size: 16.sp, color: const Color(0xFF3B82F6)),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Work Period",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color(0xFF4A4A6A),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        state.fromDate != null && state.toDate != null
                            ? "${_fmt(state.fromDate!)}  →  ${_fmt(state.toDate!)}"
                            : "Select from & to date",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: state.fromDate != null
                              ? Colors.white
                              : const Color(0xFF2A2A3A),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3B82F6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                        color:
                            const Color(0xFF3B82F6).withOpacity(0.2)),
                  ),
                  child: Text(
                    state.fromDate != null ? "Edit" : "Set",
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF3B82F6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _fmt(DateTime d) {
    const m = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return "${d.day} ${m[d.month - 1]}";
  }

  void _showDateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<SalaryBloc>(),
        child: const SalaryDateRangeSheet(),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalaryBloc, SalaryState>(
      buildWhen: (p, c) =>
          p.submitStatus != c.submitStatus ||
          p.selectedEmployees != c.selectedEmployees ||
          p.amount != c.amount ||
          p.fromDate != c.fromDate,
      builder: (context, state) {
        final isLoading = state.submitStatus == EmployeeStatus.loading;
        final isEnabled = state.selectedEmployees.isNotEmpty &&
            state.amount.isNotEmpty &&
            state.fromDate != null &&
            state.toDate != null;

        return GestureDetector(
          onTap: isEnabled && !isLoading
              ? () => context.read<SalaryBloc>().add(
                    SubmitBulkSalaryEvent(
                      fromDate: state.fromDate!,
                      toDate: state.toDate!,
                    ),
                  )
              : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            height: 58.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isEnabled
                    ? const [Color(0xFF6C63FF), Color(0xFF3B82F6)]
                    : [
                        const Color(0xFF6C63FF).withOpacity(0.25),
                        const Color(0xFF3B82F6).withOpacity(0.25),
                      ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: isEnabled
                  ? [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      )
                    ]
                  : [],
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.send_rounded,
                            color: Colors.white, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          "Send Money",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}