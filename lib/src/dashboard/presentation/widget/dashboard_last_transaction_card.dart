import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/src/dashboard/domain/entity/last_transaction.dart';
import 'package:manshan/src/dashboard/domain/entity/paginated_last_transaction.dart';

class DashboardLastTransactionCard extends StatelessWidget {
  final PaginatedLastTransaction transactions;

  const DashboardLastTransactionCard({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final items = transactions.data.toList();

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "TRANSACTIONS",
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A4A6A),
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Recent activity",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 13.sp,
                      color: Colors.white.withOpacity(0.5),
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      "Filter",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          if (items.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 32.sp,
                    color: const Color(0xFF2A2A3A),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "No transactions yet",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: const Color(0xFF4A4A6A),
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  _TransactionTile(transaction: items[i], index: i),
                  if (i < items.length - 1)
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.h),
                      height: 0.5,
                      color: Colors.white.withOpacity(0.04),
                    ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final LastTransaction transaction;
  final int index;

  const _TransactionTile({required this.transaction, required this.index});

  @override
  Widget build(BuildContext context) {
    final title = transaction.notes.isEmpty
        ? "Employee #${transaction.employeeId}"
        : transaction.notes;

    final accent = _accentColor(index);

    return Row(
      children: [
        Container(
          height: 44.r,
          width: 44.r,
          decoration: BoxDecoration(
            color: accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(13.r),
            border: Border.all(
              color: accent.withOpacity(0.2),
              width: 0.5,
            ),
          ),
          child: Icon(_icon(index), color: accent, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                _formatDate(transaction.salaryDate),
                style: TextStyle(
                  fontSize: 11.sp,
                  color: const Color(0xFF4A4A6A),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "-${_formatAmount(transaction.enteredAmount)}",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: _statusColor(transaction).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: _statusColor(transaction).withOpacity(0.2),
                  width: 0.5,
                ),
              ),
              child: Text(
                _statusText(transaction),
                style: TextStyle(
                  fontSize: 9.sp,
                  color: _statusColor(transaction),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _statusColor(LastTransaction t) {
    final status =
        (t.paymentStatus.isEmpty ? t.paymentMode : t.paymentStatus)
            .toUpperCase();
    if (status.contains("PAID") ||
        status.contains("CASH") ||
        status.contains("COMPLETE")) {
      return const Color(0xFF00D084);
    }
    if (status.contains("PENDING")) return const Color(0xFFFF9500);
    return const Color(0xFF6C63FF);
  }

  String _statusText(LastTransaction t) {
    if (t.paymentMode.isNotEmpty) return t.paymentMode.toUpperCase();
    if (t.paymentStatus.isNotEmpty) return t.paymentStatus.toUpperCase();
    return "PENDING";
  }

  Color _accentColor(int i) {
    const colors = [
      Color(0xFF6C63FF),
      Color(0xFF3B82F6),
      Color(0xFF00D084),
      Color(0xFFFF9500),
      Color(0xFFEC4899),
    ];
    return colors[i % colors.length];
  }

  IconData _icon(int i) {
    const icons = [
      Icons.payments_rounded,
      Icons.work_outline_rounded,
      Icons.construction_rounded,
      Icons.account_balance_wallet_outlined,
      Icons.person_outline_rounded,
    ];
    return icons[i % icons.length];
  }

  String _formatAmount(String value) {
    final amount = double.tryParse(
          value.replaceAll('₹', '').replaceAll(',', '').trim(),
        ) ??
        0;
    return "₹${amount.toStringAsFixed(2)}";
  }

  String _formatDate(DateTime date) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    ];
    final hour = date.hour == 0
        ? 12
        : date.hour > 12
            ? date.hour - 12
            : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? "PM" : "AM";
    return "${date.day} ${months[date.month - 1]}, $hour:$minute $period";
  }
}