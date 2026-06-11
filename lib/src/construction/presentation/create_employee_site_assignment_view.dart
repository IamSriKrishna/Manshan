import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:manshan/core/enum/employee_role.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/construction/domain/entity/construction_site.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_bloc.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_event.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_state.dart';
import 'package:manshan/src/employee/domain/entity/employee.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_bloc.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_state.dart';

class CreateEmployeeSiteAssignmentView extends StatefulWidget {
  const CreateEmployeeSiteAssignmentView({super.key});

  @override
  State<CreateEmployeeSiteAssignmentView> createState() =>
      _CreateEmployeeSiteAssignmentViewState();
}

class _CreateEmployeeSiteAssignmentViewState
    extends State<CreateEmployeeSiteAssignmentView> {
  final _notesController = TextEditingController();

  Employee? _selectedEmployee;
  ConstructionSite? _selectedSite;
  DateTime _fromDate = DateTime.now();
  DateTime _toDate = DateTime.now().add(const Duration(days: 30));
  EmployeeRole _selectedWorkType = EmployeeRole.SITHAL;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedEmployee == null || _selectedSite == null) return;

    context.read<ConstructionBloc>().add(
      CreateEmployeeSiteAssignmentRequestEvent(
        employeeId: _selectedEmployee!.id,
        constructionSiteId: _selectedSite!.id,
        fromDate: _fromDate,
        toDate: _toDate,
        workType: _selectedWorkType.value,
        notes: _notesController.text.trim(),
      ),
    );
  }

  Future<void> _pickDate(bool isFrom) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? _fromDate : _toDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6C63FF),
              surface: Color(0xFF1A1A2E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => isFrom ? _fromDate = picked : _toDate = picked);
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
        body: BlocListener<ConstructionBloc, ConstructionState>(
          listenWhen: (prev, curr) =>
              prev.assignmentStatus != curr.assignmentStatus &&
              curr.assignmentStatus == EmployeeStatus.success,
          listener: (context, state) => Get.back(),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 56.h, 16.w, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          height: 40.r,
                          width: 40.r,
                          decoration: BoxDecoration(
                            color: const Color(0xFF111118),
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.06),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 14.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Assign Employee",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            "Select site and employee",
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: const Color(0xFF4A4A6A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 32.h),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Construction site picker
                      _SectionLabel(label: "Construction Site"),
                      SizedBox(height: 12.h),
                      BlocBuilder<ConstructionBloc, ConstructionState>(
                        builder: (context, state) {
                          final sites = state.allSites.data;
                          return _SelectionList<ConstructionSite>(
                            items: sites,
                            selectedItem: _selectedSite,
                            labelBuilder: (s) => s.siteName,
                            subLabelBuilder: (s) => s.location,
                            iconBuilder: (_) => Icons.domain_rounded,
                            accentColor: const Color(0xFF3B82F6),
                            onSelect: (s) =>
                                setState(() => _selectedSite = s),
                            emptyLabel: "No sites available",
                          );
                        },
                      ),

                      SizedBox(height: 24.h),

                      // Employee picker
                      _SectionLabel(label: "Employee"),
                      SizedBox(height: 12.h),
                      BlocBuilder<EmployeeBloc, EmployeeState>(
                        builder: (context, state) {
                          final employees = state.allEmployee.data;
                          return _SelectionList<Employee>(
                            items: employees,
                            selectedItem: _selectedEmployee,
                            labelBuilder: (e) => e.name,
                            subLabelBuilder: (e) => e.role,
                            iconBuilder: (_) => Icons.person_outline_rounded,
                            accentColor: const Color(0xFF6C63FF),
                            onSelect: (e) =>
                                setState(() => _selectedEmployee = e),
                            emptyLabel: "No employees available",
                          );
                        },
                      ),

                      SizedBox(height: 24.h),

                      // Work type
                      _SectionLabel(label: "Work Type"),
                      SizedBox(height: 12.h),
                      _RoleGrid(
                        selected: _selectedWorkType,
                        onSelect: (r) =>
                            setState(() => _selectedWorkType = r),
                      ),

                      SizedBox(height: 24.h),

                      // Date range
                      _SectionLabel(label: "Assignment Period"),
                      SizedBox(height: 12.h),
                      _DateField(
                        label: "From Date",
                        date: _fromDate,
                        onTap: () => _pickDate(true),
                      ),
                      SizedBox(height: 12.h),
                      _DateField(
                        label: "To Date",
                        date: _toDate,
                        onTap: () => _pickDate(false),
                      ),

                      SizedBox(height: 24.h),

                      // Notes
                      _SectionLabel(label: "Notes (Optional)"),
                      SizedBox(height: 12.h),
                      _NotesField(controller: _notesController),

                      SizedBox(height: 32.h),

                      BlocBuilder<ConstructionBloc, ConstructionState>(
                        builder: (context, state) {
                          final isLoading =
                              state.assignmentStatus == EmployeeStatus.loading;
                          return _SubmitButton(
                            label: "Assign Employee",
                            isLoading: isLoading,
                            onTap: isLoading ? null : _submit,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Selection list ─────────────────────────────────────────────────────────

class _SelectionList<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final String Function(T) labelBuilder;
  final String Function(T) subLabelBuilder;
  final IconData Function(T) iconBuilder;
  final Color accentColor;
  final ValueChanged<T> onSelect;
  final String emptyLabel;

  const _SelectionList({
    required this.items,
    required this.selectedItem,
    required this.labelBuilder,
    required this.subLabelBuilder,
    required this.iconBuilder,
    required this.accentColor,
    required this.onSelect,
    required this.emptyLabel,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFF111118),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Center(
          child: Text(
            emptyLabel,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF4A4A6A),
            ),
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 220.h),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 6.h),
          itemCount: items.length,
          separatorBuilder: (_, __) => Container(
            height: 0.5,
            color: Colors.white.withOpacity(0.04),
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            final isSelected = selectedItem == item;
            return GestureDetector(
              onTap: () => onSelect(item),
              child: Container(
                color: isSelected
                    ? accentColor.withOpacity(0.08)
                    : Colors.transparent,
                padding: EdgeInsets.symmetric(
                  horizontal: 14.w,
                  vertical: 11.h,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 36.r,
                      width: 36.r,
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        iconBuilder(item),
                        color: accentColor,
                        size: 16.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            labelBuilder(item),
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            subLabelBuilder(item),
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: const Color(0xFF4A4A6A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: accentColor,
                        size: 18.sp,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Role grid ──────────────────────────────────────────────────────────────

class _RoleGrid extends StatelessWidget {
  final EmployeeRole selected;
  final ValueChanged<EmployeeRole> onSelect;

  const _RoleGrid({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: EmployeeRole.values.map((role) {
        final isSelected = role == selected;
        return GestureDetector(
          onTap: () => onSelect(role),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF6C63FF).withOpacity(0.15)
                  : const Color(0xFF111118),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF6C63FF).withOpacity(0.5)
                    : Colors.white.withOpacity(0.06),
                width: isSelected ? 1 : 0.5,
              ),
            ),
            child: Text(
              role.label,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFF4A4A6A),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Date field, notes, section label, submit — reused from create_construction_site_view

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 14.h,
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
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;

  const _DateField({
    required this.label,
    required this.date,
    required this.onTap,
  });

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF111118),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 16.sp,
                color: const Color(0xFF6C63FF),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF4A4A6A),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${date.day} ${_monthName(date.month)} ${date.year}",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFF4A4A6A),
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesField extends StatelessWidget {
  final TextEditingController controller;
  const _NotesField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.06)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.notes_rounded,
              size: 16.sp,
              color: const Color(0xFF6C63FF),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notes",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xFF4A4A6A),
                  ),
                ),
                SizedBox(height: 4.h),
                TextField(
                  controller: controller,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: "Any additional notes...",
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF2A2A3A),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback? onTap;

  const _SubmitButton({
    required this.label,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? [
                    const Color(0xFF6C63FF).withOpacity(0.5),
                    const Color(0xFF3B82F6).withOpacity(0.5),
                  ]
                : const [Color(0xFF6C63FF), Color(0xFF3B82F6)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 22.r,
                  height: 22.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}