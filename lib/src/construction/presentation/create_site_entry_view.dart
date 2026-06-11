import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/construction/domain/entity/construction_site.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_bloc.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_event.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_state.dart';

// ── Enums (mirror Python enums) ────────────────────────────────────────────

enum _ExpenseType {
  BRICK, CEMENT, STEEL, SAND, JELLY, M_SAND, P_SAND,
  PAINT, ELECTRICAL, PLUMBING, LABOUR, TRANSPORT,
  FOOD, MACHINERY, RENTAL, FUEL, OTHER;

  String get label => name.replaceAll('_', ' ');
}

enum _ExpenseUnit { BAG, TON, KG, PIECE, LOAD, LITER, OTHER;
  String get label => name;
}

class CreateSiteEntryView extends StatefulWidget {
  const CreateSiteEntryView({super.key});

  @override
  State<CreateSiteEntryView> createState() => _CreateSiteEntryViewState();
}

class _CreateSiteEntryViewState extends State<CreateSiteEntryView> {
  final _itemNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _vendorController = TextEditingController();
  final _notesController = TextEditingController();

  ConstructionSite? _selectedSite;
  _ExpenseType _selectedExpenseType = _ExpenseType.BRICK;
  _ExpenseUnit _selectedUnit = _ExpenseUnit.BAG;
  DateTime _purchaseDate = DateTime.now();

  @override
  void dispose() {
    _itemNameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _vendorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedSite == null) return;
    final itemName = _itemNameController.text.trim();
    final quantity = double.tryParse(_quantityController.text.trim()) ?? 0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0;

    if (itemName.isEmpty || quantity <= 0 || price <= 0) return;

    context.read<ConstructionBloc>().add(
      CreateSiteEntryRequestEvent(
        constructionSiteId: _selectedSite!.id,
        expenseType: _selectedExpenseType.name,
        itemName: itemName,
        quantity: quantity,
        unit: _selectedUnit.name,
        pricePerUnit: price,
        purchaseDate: _purchaseDate,
        vendorName: _vendorController.text.trim(),
        notes: _notesController.text.trim(),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
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
    if (picked != null) setState(() => _purchaseDate = picked);
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
              prev.entryStatus != curr.entryStatus &&
              curr.entryStatus == EmployeeStatus.success,
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
                            "Site Entry",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            "Log a material or expense",
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
                      // Site picker
                      _SectionLabel(label: "Construction Site"),
                      SizedBox(height: 12.h),
                      BlocBuilder<ConstructionBloc, ConstructionState>(
                        builder: (context, state) {
                          return _SitePicker(
                            sites: state.allSites.data,
                            selected: _selectedSite,
                            onSelect: (s) => setState(() => _selectedSite = s),
                          );
                        },
                      ),

                      SizedBox(height: 24.h),

                      // Expense type
                      _SectionLabel(label: "Expense Type"),
                      SizedBox(height: 12.h),
                      _ExpenseTypeGrid(
                        selected: _selectedExpenseType,
                        onSelect: (e) =>
                            setState(() => _selectedExpenseType = e),
                      ),

                      SizedBox(height: 24.h),

                      // Item details
                      _SectionLabel(label: "Item Details"),
                      SizedBox(height: 12.h),
                      _InputField(
                        controller: _itemNameController,
                        label: "Item Name",
                        hint: "e.g. OPC Cement 53 Grade",
                        icon: Icons.inventory_2_outlined,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: _InputField(
                              controller: _quantityController,
                              label: "Quantity",
                              hint: "e.g. 50",
                              icon: Icons.numbers_rounded,
                              inputType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: _InputField(
                              controller: _priceController,
                              label: "Price / Unit (₹)",
                              hint: "e.g. 380",
                              icon: Icons.currency_rupee_rounded,
                              inputType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 14.h),

                      // Unit
                      _SectionLabel(label: "Unit"),
                      SizedBox(height: 12.h),
                      _UnitRow(
                        selected: _selectedUnit,
                        onSelect: (u) => setState(() => _selectedUnit = u),
                      ),

                      SizedBox(height: 24.h),

                      // Purchase date
                      _SectionLabel(label: "Purchase Date"),
                      SizedBox(height: 12.h),
                      _DateField(
                        label: "Purchase Date",
                        date: _purchaseDate,
                        onTap: _pickDate,
                      ),

                      SizedBox(height: 24.h),

                      // Vendor & notes
                      _SectionLabel(label: "Vendor & Notes"),
                      SizedBox(height: 12.h),
                      _InputField(
                        controller: _vendorController,
                        label: "Vendor Name (Optional)",
                        hint: "e.g. Kerala Cement Stores",
                        icon: Icons.store_outlined,
                      ),
                      SizedBox(height: 12.h),
                      _NotesField(controller: _notesController),

                      SizedBox(height: 32.h),

                      // Total preview
                      _TotalPreview(
                        quantity: double.tryParse(
                              _quantityController.text.trim(),
                            ) ??
                            0,
                        price: double.tryParse(
                              _priceController.text.trim(),
                            ) ??
                            0,
                      ),

                      SizedBox(height: 20.h),

                      BlocBuilder<ConstructionBloc, ConstructionState>(
                        builder: (context, state) {
                          final isLoading =
                              state.entryStatus == EmployeeStatus.loading;
                          return _SubmitButton(
                            label: "Add Entry",
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

// ── Total preview ──────────────────────────────────────────────────────────

class _TotalPreview extends StatelessWidget {
  final double quantity;
  final double price;

  const _TotalPreview({required this.quantity, required this.price});

  @override
  Widget build(BuildContext context) {
    final total = quantity * price;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF6C63FF).withOpacity(0.12),
            const Color(0xFF3B82F6).withOpacity(0.08),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF6C63FF).withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Estimated Total",
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Text(
            "₹${total.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Site picker ────────────────────────────────────────────────────────────

class _SitePicker extends StatelessWidget {
  final List<ConstructionSite> sites;
  final ConstructionSite? selected;
  final ValueChanged<ConstructionSite> onSelect;

  const _SitePicker({
    required this.sites,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    if (sites.isEmpty) {
      return Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: const Color(0xFF111118),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Center(
          child: Text(
            "No construction sites available",
            style: TextStyle(fontSize: 12.sp, color: const Color(0xFF4A4A6A)),
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(maxHeight: 180.h),
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
          itemCount: sites.length,
          separatorBuilder: (_, __) =>
              Container(height: 0.5, color: Colors.white.withOpacity(0.04)),
          itemBuilder: (context, index) {
            final site = sites[index];
            final isSelected = selected?.id == site.id;
            return GestureDetector(
              onTap: () => onSelect(site),
              child: Container(
                color: isSelected
                    ? const Color(0xFF3B82F6).withOpacity(0.08)
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
                        color: const Color(0xFF3B82F6).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Icons.domain_rounded,
                        color: const Color(0xFF3B82F6),
                        size: 16.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            site.siteName,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            site.location,
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
                        color: const Color(0xFF3B82F6),
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

// ── Expense type grid ──────────────────────────────────────────────────────

class _ExpenseTypeGrid extends StatelessWidget {
  final _ExpenseType selected;
  final ValueChanged<_ExpenseType> onSelect;

  const _ExpenseTypeGrid({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _ExpenseType.values.map((e) {
        final isSelected = e == selected;
        return GestureDetector(
          onTap: () => onSelect(e),
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
              e.label,
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

// ── Unit row ───────────────────────────────────────────────────────────────

class _UnitRow extends StatelessWidget {
  final _ExpenseUnit selected;
  final ValueChanged<_ExpenseUnit> onSelect;

  const _UnitRow({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: _ExpenseUnit.values.map((u) {
        final isSelected = u == selected;
        return GestureDetector(
          onTap: () => onSelect(u),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF3B82F6).withOpacity(0.15)
                  : const Color(0xFF111118),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF3B82F6).withOpacity(0.5)
                    : Colors.white.withOpacity(0.06),
                width: isSelected ? 1 : 0.5,
              ),
            ),
            child: Text(
              u.label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFF3B82F6)
                    : const Color(0xFF4A4A6A),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Shared local widgets ───────────────────────────────────────────────────

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

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.inputType = TextInputType.text,
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