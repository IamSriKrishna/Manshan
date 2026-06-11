import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_bloc.dart';
import 'package:manshan/src/salary/presentation/bloc/salary_event.dart';

class SalaryDateRangeSheet extends StatefulWidget {
  const SalaryDateRangeSheet({super.key});

  @override
  State<SalaryDateRangeSheet> createState() => _SalaryDateRangeSheetState();
}

class _SalaryDateRangeSheetState extends State<SalaryDateRangeSheet> {
  DateTime? _from;
  DateTime? _to;

  @override
  void initState() {
    super.initState();
    final state = context.read<SalaryBloc>().state;
    _from = state.fromDate;
    _to = state.toDate;
  }

  Future<void> _pickFrom() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _from ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: _darkTheme,
    );
    if (picked != null) setState(() => _from = picked);
  }

  Future<void> _pickTo() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _to ?? _from ?? DateTime.now(),
      firstDate: _from ?? DateTime(2020),
      lastDate: DateTime(2100),
      builder: _darkTheme,
    );
    if (picked != null) setState(() => _to = picked);
  }

  Widget _darkTheme(BuildContext ctx, Widget? child) {
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C63FF),
          surface: Color(0xFF1A1A2E),
          onSurface: Colors.white,
        ),
        dialogBackgroundColor: const Color(0xFF111118),
      ),
      child: child!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm = _from != null && _to != null;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          Row(
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
              SizedBox(width: 10.w),
              Text(
                "Select Work Period",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Quick presets
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: _presets().map((preset) {
                return GestureDetector(
                  onTap: () => setState(() {
                    _from = preset.$2;
                    _to = preset.$3;
                  }),
                  child: Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Text(
                      preset.$1,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 16.h),

          // From date
          _DateTile(
            label: "FROM DATE",
            date: _from,
            accent: const Color(0xFF6C63FF),
            onTap: _pickFrom,
          ),

          SizedBox(height: 10.h),

          // Arrow
          Center(
            child: Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_downward_rounded,
                  size: 14.sp, color: const Color(0xFF4A4A6A)),
            ),
          ),

          SizedBox(height: 10.h),

          // To date
          _DateTile(
            label: "TO DATE",
            date: _to,
            accent: const Color(0xFF3B82F6),
            onTap: _pickTo,
          ),

          SizedBox(height: 24.h),

          // Confirm
          GestureDetector(
            onTap: canConfirm
                ? () {
                    context.read<SalaryBloc>().add(
                          UpdateDateRangeEvent(
                            fromDate: _from!,
                            toDate: _to!,
                          ),
                        );
                    Navigator.pop(context);
                  }
                : null,
            child: Container(
              width: double.infinity,
              height: 52.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: canConfirm
                      ? const [Color(0xFF6C63FF), Color(0xFF3B82F6)]
                      : [
                          const Color(0xFF6C63FF).withOpacity(0.3),
                          const Color(0xFF3B82F6).withOpacity(0.3),
                        ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  "Confirm Period",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<(String, DateTime, DateTime)> _presets() {
    final now = DateTime.now();
    final startOfWeek =
        now.subtract(Duration(days: now.weekday - 1));
    final startOfMonth = DateTime(now.year, now.month, 1);
    final yesterday = now.subtract(const Duration(days: 1));
    return [
      ("Today", now, now),
      ("Yesterday", yesterday, yesterday),
      ("This Week", startOfWeek, now),
      ("This Month", startOfMonth, now),
    ];
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final DateTime? date;
  final Color accent;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.date,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: date != null
              ? accent.withOpacity(0.06)
              : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: date != null
                ? accent.withOpacity(0.25)
                : Colors.white.withOpacity(0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.calendar_today_outlined,
                  size: 15.sp, color: accent),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: accent.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    date != null ? _fmt(date!) : "Tap to select",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: date != null
                          ? Colors.white
                          : const Color(0xFF2A2A3A),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.edit_calendar_outlined,
              size: 16.sp,
              color: date != null ? accent : const Color(0xFF2A2A3A),
            ),
          ],
        ),
      ),
    );
  }

  String _fmt(DateTime d) {
    const months = [
      "January","February","March","April","May","June",
      "July","August","September","October","November","December"
    ];
    const days = ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
    return "${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]} ${d.year}";
  }
}