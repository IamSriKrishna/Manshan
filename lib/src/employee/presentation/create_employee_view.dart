import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:manshan/core/enum/employee_role.dart';
import 'package:manshan/core/enum/employee_salary_type.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_bloc.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_event.dart';
import 'package:manshan/src/employee/presentation/bloc/employee_state.dart';

class CreateEmployeeView extends StatefulWidget {
  const CreateEmployeeView({super.key});

  @override
  State<CreateEmployeeView> createState() => _CreateEmployeeViewState();
}

class _CreateEmployeeViewState extends State<CreateEmployeeView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _salaryController = TextEditingController();

  EmployeeRole _selectedRole = EmployeeRole.SITHAL;
  EmployeeSalaryType _selectedSalaryType = EmployeeSalaryType.DAILY;
  DateTime _joiningDate = DateTime.now();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final salary = double.tryParse(_salaryController.text.trim()) ?? 0;

    if (name.isEmpty || phone.isEmpty || salary <= 0) return;

    context.read<EmployeeBloc>().add(
      CreateEmployeeRequestEvent(
        name: name,
        phone: phone,
        role: _selectedRole.value,
        salaryType: _selectedSalaryType.value,
        defaultSalary: salary,
        joiningDate: _joiningDate,
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _joiningDate,
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
    if (picked != null) setState(() => _joiningDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: BlocListener<EmployeeBloc, EmployeeState>(
          listenWhen: (prev, curr) =>
              prev.createStatus != curr.createStatus &&
              curr.createStatus == EmployeeStatus.success,
          listener: (context, state) {
            context.read<EmployeeBloc>().add(GetAllEmployeeRequestEvent());
            Get.back();
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App bar
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
                            "Add Employee",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            "Fill in the details below",
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
                      // Basic info section
                      _SectionLabel(label: "Basic Info"),
                      SizedBox(height: 12.h),
                      _InputField(
                        controller: _nameController,
                        label: "Full Name",
                        hint: "e.g. Ramesh Kumar",
                        icon: Icons.person_outline_rounded,
                        inputType: TextInputType.name,
                      ),
                      SizedBox(height: 12.h),
                      _InputField(
                        controller: _phoneController,
                        label: "Phone Number",
                        hint: "e.g. 9876543210",
                        icon: Icons.phone_outlined,
                        inputType: TextInputType.phone,
                        maxLength: 10,
                      ),

                      SizedBox(height: 24.h),

                      // Role section
                      _SectionLabel(label: "Role"),
                      SizedBox(height: 12.h),
                      _RoleGrid(
                        selected: _selectedRole,
                        onSelect: (role) =>
                            setState(() => _selectedRole = role),
                      ),

                      SizedBox(height: 24.h),

                      // Salary section
                      _SectionLabel(label: "Salary"),
                      SizedBox(height: 12.h),
                      _SalaryTypeRow(
                        selected: _selectedSalaryType,
                        onSelect: (type) =>
                            setState(() => _selectedSalaryType = type),
                      ),
                      SizedBox(height: 12.h),
                      _InputField(
                        controller: _salaryController,
                        label: "Default Salary (₹)",
                        hint: "e.g. 850",
                        icon: Icons.currency_rupee_rounded,
                        inputType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),

                      SizedBox(height: 24.h),

                      // Joining date
                      _SectionLabel(label: "Joining Date"),
                      SizedBox(height: 12.h),
                      GestureDetector(
                        onTap: _pickDate,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF111118),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.06),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8.r),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF6C63FF,
                                  ).withOpacity(0.1),
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
                                      "Joining Date",
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: const Color(0xFF4A4A6A),
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      "${_joiningDate.day} ${_monthName(_joiningDate.month)} ${_joiningDate.year}",
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
                      ),

                      SizedBox(height: 32.h),

                      // Submit button
                      BlocBuilder<EmployeeBloc, EmployeeState>(
                        builder: (context, state) {
                          final isLoading =
                              state.createStatus == EmployeeStatus.loading;
                          return GestureDetector(
                            onTap: isLoading ? null : _submit,
                            child: Container(
                              width: double.infinity,
                              height: 54.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isLoading
                                      ? [
                                          const Color(
                                            0xFF6C63FF,
                                          ).withOpacity(0.5),
                                          const Color(
                                            0xFF3B82F6,
                                          ).withOpacity(0.5),
                                        ]
                                      : const [
                                          Color(0xFF6C63FF),
                                          Color(0xFF3B82F6),
                                        ],
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
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : Text(
                                        "Add Employee",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
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

  String _monthName(int month) {
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
    return months[month - 1];
  }
}

// ── Section label ──────────────────────────────────────────────────────────

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

// ── Input field ────────────────────────────────────────────────────────────

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
              color: const Color(0xFF6C63FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 16.sp, color: const Color(0xFF6C63FF)),
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

// ── Salary type row ────────────────────────────────────────────────────────

class _SalaryTypeRow extends StatelessWidget {
  final EmployeeSalaryType selected;
  final ValueChanged<EmployeeSalaryType> onSelect;

  const _SalaryTypeRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: EmployeeSalaryType.values.map((type) {
        final isSelected = type == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(type),
            child: Container(
              margin: EdgeInsets.only(
                right: type != EmployeeSalaryType.values.last ? 8.w : 0,
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6C63FF).withOpacity(0.15)
                    : const Color(0xFF111118),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF6C63FF).withOpacity(0.5)
                      : Colors.white.withOpacity(0.06),
                  width: isSelected ? 1 : 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  type.label,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? const Color(0xFF6C63FF)
                        : const Color(0xFF4A4A6A),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
