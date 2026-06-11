import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/employee/data/model/employee_model.dart';
import 'package:manshan/src/employee/domain/entity/employee.dart';
import 'package:manshan/src/salary/domain/entity/salary_transaction.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_bloc.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_state.dart';

class TransactionHistoryList extends StatelessWidget {
  const TransactionHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalaryBloc, SalaryState>(
      builder: (context, state) {
        final isLoading = state.historyStatus == EmployeeStatus.loading;
        final transactions = state.transactionHistory.data;
        final employees = state.employees.data;

        if (isLoading) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 32.h),
              child: Center(
                child: SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF6C63FF),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        if (transactions.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.h),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 36.sp,
                    color: const Color(0xFF2A2A3A),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "No transactions yet",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF4A4A6A),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final grouped = _groupByDate(transactions);

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 16.h, 0, 8.h),
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4A4A6A),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  ...entry.value.map(
                    (tx) => _TransactionTile(
                      tx: tx,
                      employee: employees.firstWhere(
                        (e) => e.id == tx.employeeId,
                        orElse: () => EmployeeModel.initial(),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Map<String, List<SalaryTransaction>> _groupByDate(
    List<SalaryTransaction> txs,
  ) {
    final map = <String, List<SalaryTransaction>>{};
    final now = DateTime.now();
    for (final tx in txs) {
      final d = tx.salaryDate;
      String label;
      if (d.year == now.year && d.month == now.month && d.day == now.day) {
        label = "Today";
      } else if (d.year == now.year &&
          d.month == now.month &&
          d.day == now.day - 1) {
        label = "Yesterday";
      } else {
        const months = [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec",
        ];
        label = "${d.day} ${months[d.month - 1]} ${d.year}";
      }
      map.putIfAbsent(label, () => []).add(tx);
    }
    return map;
  }
}

class _TransactionTile extends StatelessWidget {
  final SalaryTransaction tx;
  final Employee employee;

  const _TransactionTile({required this.tx, required this.employee});

  @override
  Widget build(BuildContext context) {
    final isPaid = tx.paymentStatus.toUpperCase() == "PAID";
    final amount = _parseAmount(tx.enteredAmount);
    final name = employee.name.isNotEmpty
        ? employee.name
        : "Employee #${tx.employeeId}";
    final initial = name.isNotEmpty ? name[0].toUpperCase() : "?";
    final accent = _accentForId(tx.employeeId);

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withOpacity(0.12),
              border: Border.all(color: accent.withOpacity(0.25)),
            ),
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Name + time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Text(
                      _formatTime(tx.salaryDate),
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: const Color(0xFF4A4A6A),
                      ),
                    ),
                    if (employee.role.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Container(
                          width: 3.r,
                          height: 3.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF2A2A3A),
                          ),
                        ),
                      ),
                      Text(
                        employee.role,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: const Color(0xFF4A4A6A),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          SizedBox(width: 10.w),

          // Amount + badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "-₹$amount",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isPaid
                      ? const Color(0xFF00D084).withOpacity(0.1)
                      : const Color(0xFFFF9500).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: isPaid
                        ? const Color(0xFF00D084).withOpacity(0.2)
                        : const Color(0xFFFF9500).withOpacity(0.2),
                  ),
                ),
                child: Text(
                  tx.paymentMode.isNotEmpty
                      ? tx.paymentMode.toUpperCase()
                      : tx.paymentStatus.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: isPaid
                        ? const Color(0xFF00D084)
                        : const Color(0xFFFF9500),
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _accentForId(int id) {
    const colors = [
      Color(0xFF6C63FF),
      Color(0xFF3B82F6),
      Color(0xFF00D084),
      Color(0xFFFF9500),
      Color(0xFFEC4899),
    ];
    return colors[id % colors.length];
  }

  String _parseAmount(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9.]'), '');
    final value = double.tryParse(cleaned) ?? 0;
    return value.toStringAsFixed(2);
  }

  String _formatTime(DateTime d) {
    final h = d.hour == 0
        ? 12
        : d.hour > 12
        ? d.hour - 12
        : d.hour;
    final m = d.minute.toString().padLeft(2, '0');
    final p = d.hour >= 12 ? "PM" : "AM";
    return "$h:$m $p";
  }
}
