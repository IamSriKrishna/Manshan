// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_bloc.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_event.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_state.dart';

class CreateConstructionSiteView extends StatefulWidget {
  const CreateConstructionSiteView({super.key});

  @override
  State<CreateConstructionSiteView> createState() =>
      _CreateConstructionSiteViewState();
}

class _CreateConstructionSiteViewState
    extends State<CreateConstructionSiteView> {
  final _siteNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _clientNameController = TextEditingController();

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 90));
  String _selectedStatus = "ONGOING";

  static const _statuses = ["ONGOING", "COMPLETED", "PAUSED", "CANCELLED"];

  @override
  void dispose() {
    _siteNameController.dispose();
    _locationController.dispose();
    _clientNameController.dispose();
    super.dispose();
  }

  void _submit() {
    final siteName = _siteNameController.text.trim();
    final location = _locationController.text.trim();
    final clientName = _clientNameController.text.trim();

    if (siteName.isEmpty || location.isEmpty || clientName.isEmpty) return;

    context.read<ConstructionBloc>().add(
      CreateConstructionSiteRequestEvent(
        siteName: siteName,
        location: location,
        clientName: clientName,
        startDate: _startDate,
        endDate: _endDate,
        status: _selectedStatus,
      ),
    );
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF3B82F6),
              surface: Color(0xFF1A1A2E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => isStart ? _startDate = picked : _endDate = picked);
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
              prev.createSiteStatus != curr.createSiteStatus &&
              curr.createSiteStatus == EmployeeStatus.success,
          listener: (context, state) {
            context
                .read<ConstructionBloc>()
                .add(GetAllConstructionSitesRequestEvent());
            Get.back();
          },
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
                            "New Site",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            "Fill in the site details",
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
                      _SectionLabel(label: "Site Info"),
                      SizedBox(height: 12.h),
                      _InputField(
                        controller: _siteNameController,
                        label: "Site Name",
                        hint: "e.g. Greenfield Residency",
                        icon: Icons.domain_rounded,
                      ),
                      SizedBox(height: 12.h),
                      _InputField(
                        controller: _locationController,
                        label: "Location",
                        hint: "e.g. Kochi, Kerala",
                        icon: Icons.place_outlined,
                      ),
                      SizedBox(height: 12.h),
                      _InputField(
                        controller: _clientNameController,
                        label: "Client Name",
                        hint: "e.g. Mr. Suresh Nair",
                        icon: Icons.person_outline_rounded,
                      ),
                      SizedBox(height: 24.h),
                      _SectionLabel(label: "Status"),
                      SizedBox(height: 12.h),
                      _StatusGrid(
                        selected: _selectedStatus,
                        onSelect: (s) =>
                            setState(() => _selectedStatus = s),
                        statuses: _statuses,
                      ),
                      SizedBox(height: 24.h),
                      _SectionLabel(label: "Timeline"),
                      SizedBox(height: 12.h),
                      _DateField(
                        label: "Start Date",
                        date: _startDate,
                        onTap: () => _pickDate(true),
                      ),
                      SizedBox(height: 12.h),
                      _DateField(
                        label: "End Date",
                        date: _endDate,
                        onTap: () => _pickDate(false),
                      ),
                      SizedBox(height: 32.h),
                      BlocBuilder<ConstructionBloc, ConstructionState>(
                        builder: (context, state) {
                          final isLoading =
                              state.createSiteStatus == EmployeeStatus.loading;
                          return _SubmitButton(
                            label: "Create Site",
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

// ── Shared widgets ─────────────────────────────────────────────────────────

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

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType inputType;
  final int? maxLength;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.inputType = TextInputType.text,
    this.maxLength,
  });

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
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 16.sp, color: const Color(0xFF3B82F6)),
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
                SizedBox(height: 4.h),
                TextField(
                  controller: controller,
                  keyboardType: inputType,
                  maxLength: maxLength,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF2A2A3A),
                      fontWeight: FontWeight.w400,
                    ),
                    counterText: "",
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
                color: const Color(0xFF3B82F6).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                size: 16.sp,
                color: const Color(0xFF3B82F6),
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

class _StatusGrid extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  final List<String> statuses;

  const _StatusGrid({
    required this.selected,
    required this.onSelect,
    required this.statuses,
  });

  Color _statusColor(String s) {
    switch (s) {
      case "ONGOING":
        return const Color(0xFF00D084);
      case "COMPLETED":
        return const Color(0xFF3B82F6);
      case "PAUSED":
        return const Color(0xFFFF9500);
      case "CANCELLED":
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6C63FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: statuses.map((s) {
        final isSelected = s == selected;
        final color = _statusColor(s);
        return GestureDetector(
          onTap: () => onSelect(s),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.15) : const Color(0xFF111118),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isSelected
                    ? color.withOpacity(0.5)
                    : Colors.white.withOpacity(0.06),
                width: isSelected ? 1 : 0.5,
              ),
            ),
            child: Text(
              s,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? color : const Color(0xFF4A4A6A),
              ),
            ),
          ),
        );
      }).toList(),
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