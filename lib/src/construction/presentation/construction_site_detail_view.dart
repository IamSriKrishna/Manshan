
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:manshan/core/service/service_locator.dart';
import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/construction/domain/entity/construction_site.dart';
import 'package:manshan/src/construction/domain/entity/employee_site_assignment.dart';
import 'package:manshan/src/construction/domain/entity/site_entry.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_bloc.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_event.dart';
import 'package:manshan/src/construction/presentation/bloc/construction_state.dart';

class ConstructionSiteDetail extends StatelessWidget {
  final ConstructionSite site;
  const ConstructionSiteDetail({super.key, required this.site});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ConstructionBloc>(
      create: (_) => sl<ConstructionBloc>()
        ..add(GetSiteAssignmentsRequestEvent(siteId: site.id))
        ..add(GetSiteEntriesRequestEvent(siteId: site.id)),
      child: ConstructionSiteDetailView(site: site),
    );
  }
}

class ConstructionSiteDetailView extends StatefulWidget {
  final ConstructionSite site;
  const ConstructionSiteDetailView({super.key, required this.site});

  @override
  State<ConstructionSiteDetailView> createState() =>
      _ConstructionSiteDetailViewState();
}

class _ConstructionSiteDetailViewState
    extends State<ConstructionSiteDetailView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _assignmentsScroll = ScrollController();
  final _entriesScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _assignmentsScroll.addListener(() {
      if (_assignmentsScroll.position.pixels >=
          _assignmentsScroll.position.maxScrollExtent - 200) {
        context
            .read<ConstructionBloc>()
            .add(LoadMoreSiteAssignmentsEvent(siteId: widget.site.id));
      }
    });

    _entriesScroll.addListener(() {
      if (_entriesScroll.position.pixels >=
          _entriesScroll.position.maxScrollExtent - 200) {
        context
            .read<ConstructionBloc>()
            .add(LoadMoreSiteEntriesEvent(siteId: widget.site.id));
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _assignmentsScroll.dispose();
    _entriesScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final site = widget.site;
    final statusColor = _statusColor(site.status);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0F),
        body: Column(
          children: [
            _SiteHeader(site: site, statusColor: statusColor),

            // ── Tab bar ─────────────────────────────────────────────────
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
              decoration: BoxDecoration(
                color: const Color(0xFF111118),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: Colors.white.withOpacity(0.06)),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF3B82F6)],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFF4A4A6A),
                labelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline_rounded, size: 15.sp),
                        SizedBox(width: 6.w),
                        const Text("Employees"),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_rounded, size: 15.sp),
                        SizedBox(width: 6.w),
                        const Text("Expenses"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 14.h),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _AssignmentsTab(
                    scrollController: _assignmentsScroll,
                    siteId: widget.site.id,
                  ),
                  _EntriesTab(
                    scrollController: _entriesScroll,
                    siteId: widget.site.id,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toUpperCase()) {
      case "ONGOING":   return const Color(0xFF00D084);
      case "COMPLETED": return const Color(0xFF3B82F6);
      case "PAUSED":    return const Color(0xFFFF9500);
      case "CANCELLED": return const Color(0xFFEF4444);
      default:          return const Color(0xFF4A4A6A);
    }
  }
}

// ── Site header ────────────────────────────────────────────────────────────

class _SiteHeader extends StatelessWidget {
  final ConstructionSite site;
  final Color statusColor;

  const _SiteHeader({required this.site, required this.statusColor});

  String _monthName(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec",
    ];
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 56.h, 16.w, 18.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D0D1A), Color(0xFF0A0A0F)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.05)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 40.r,
                  width: 40.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF111118),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.white.withOpacity(0.06)),
                  ),
                  child: Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16.sp),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      site.siteName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(Icons.place_outlined,
                            size: 11.sp, color: const Color(0xFF4A4A6A)),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            site.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFF4A4A6A)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(9.r),
                  border: Border.all(
                      color: statusColor.withOpacity(0.3), width: 0.5),
                ),
                child: Text(
                  site.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _HeaderChip(
                icon: Icons.person_outline_rounded,
                label: site.clientName.isEmpty ? "No client" : site.clientName,
                accent: const Color(0xFF6C63FF),
              ),
              SizedBox(width: 8.w),
              _HeaderChip(
                icon: Icons.play_arrow_rounded,
                label:
                    "${site.startDate.day} ${_monthName(site.startDate.month)} ${site.startDate.year}",
                accent: const Color(0xFF00D084),
              ),
              SizedBox(width: 8.w),
              _HeaderChip(
                icon: Icons.flag_outlined,
                label:
                    "${site.endDate.day} ${_monthName(site.endDate.month)} ${site.endDate.year}",
                accent: const Color(0xFFFF9500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;

  const _HeaderChip({
    required this.icon,
    required this.label,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(9.r),
        border: Border.all(color: accent.withOpacity(0.18), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.sp, color: accent),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Assignments tab ────────────────────────────────────────────────────────

class _AssignmentsTab extends StatelessWidget {
  final ScrollController scrollController;
  final int siteId;

  const _AssignmentsTab({
    required this.scrollController,
    required this.siteId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConstructionBloc, ConstructionState>(
      builder: (context, state) {
        final isLoading =
            state.assignmentsLoadStatus == EmployeeStatus.loading;
        final isPaginating =
            state.assignmentsPaginationStatus == EmployeeStatus.loading;
        final assignments = state.siteAssignments.data;

        if (isLoading) {
          return Center(
            child: SizedBox(
              width: 26.r,
              height: 26.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
              ),
            ),
          );
        }

        if (assignments.isEmpty) {
          return _EmptyState(
            icon: Icons.people_outline_rounded,
            label: "No employees assigned",
          );
        }

        return ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
          physics: const BouncingScrollPhysics(),
          itemCount: assignments.length + (isPaginating ? 1 : 0),
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            if (index == assignments.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF6C63FF)),
                    ),
                  ),
                ),
              );
            }
            return _AssignmentTile(
                assignment: assignments[index], index: index);
          },
        );
      },
    );
  }
}

class _AssignmentTile extends StatelessWidget {
  final EmployeeSiteAssignment assignment;
  final int index;

  const _AssignmentTile({required this.assignment, required this.index});

  String _monthName(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec",
    ];
    return months[m - 1];
  }

  Color _accent(int i) {
    const colors = [
      Color(0xFF6C63FF), Color(0xFF3B82F6), Color(0xFF00D084),
      Color(0xFFFF9500), Color(0xFFEC4899),
    ];
    return colors[i % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent(index);
    final from = assignment.fromDate;
    final to = assignment.toDate;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            height: 44.r,
            width: 44.r,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(13.r),
              border: Border.all(color: accent.withOpacity(0.25), width: 0.5),
            ),
            child: Center(
              child: Text(
                "#${assignment.employeeId}",
                style: TextStyle(
                  color: accent,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      assignment.workType,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "EMP #${assignment.employeeId}",
                        style: TextStyle(
                          color: accent,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Icon(Icons.date_range_outlined,
                        size: 11.sp, color: const Color(0xFF4A4A6A)),
                    SizedBox(width: 4.w),
                    Text(
                      "${from.day} ${_monthName(from.month)} — ${to.day} ${_monthName(to.month)} ${to.year}",
                      style: TextStyle(
                          fontSize: 11.sp, color: const Color(0xFF4A4A6A)),
                    ),
                  ],
                ),
                if (assignment.notes.isNotEmpty) ...[
                  SizedBox(height: 5.h),
                  Text(
                    assignment.notes,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: const Color(0xFF4A4A6A),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Entries tab ────────────────────────────────────────────────────────────

class _EntriesTab extends StatelessWidget {
  final ScrollController scrollController;
  final int siteId;

  const _EntriesTab({
    required this.scrollController,
    required this.siteId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConstructionBloc, ConstructionState>(
      builder: (context, state) {
        final isLoading = state.entriesLoadStatus == EmployeeStatus.loading;
        final isPaginating =
            state.entriesPaginationStatus == EmployeeStatus.loading;
        final entries = state.siteEntries.data;

        if (isLoading) {
          return Center(
            child: SizedBox(
              width: 26.r,
              height: 26.r,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
              ),
            ),
          );
        }

        if (entries.isEmpty) {
          return _EmptyState(
            icon: Icons.receipt_long_outlined,
            label: "No site entries yet",
          );
        }

        return ListView.separated(
          controller: scrollController,
          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
          physics: const BouncingScrollPhysics(),
          itemCount: entries.length + (isPaginating ? 1 : 0),
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            if (index == entries.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Center(
                  child: SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF3B82F6)),
                    ),
                  ),
                ),
              );
            }
            return _EntryTile(entry: entries[index], index: index);
          },
        );
      },
    );
  }
}

class _EntryTile extends StatelessWidget {
  final SiteEntry entry;
  final int index;

  const _EntryTile({required this.entry, required this.index});

  String _monthName(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec",
    ];
    return months[m - 1];
  }

  Color _expenseColor(String type) {
    switch (type.toUpperCase()) {
      case "BRICK":
      case "CEMENT":
      case "STEEL":
      case "SAND":
      case "JELLY":
      case "M_SAND":
      case "P_SAND":    return const Color(0xFF6C63FF);
      case "ELECTRICAL":
      case "PLUMBING":  return const Color(0xFFFF9500);
      case "LABOUR":    return const Color(0xFF00D084);
      case "TRANSPORT":
      case "FUEL":      return const Color(0xFF3B82F6);
      case "FOOD":      return const Color(0xFFEC4899);
      default:          return const Color(0xFF4A4A6A);
    }
  }

  IconData _expenseIcon(String type) {
    switch (type.toUpperCase()) {
      case "BRICK":       return Icons.dashboard_rounded;
      case "CEMENT":      return Icons.circle_rounded;
      case "STEEL":       return Icons.bolt_rounded;
      case "SAND":
      case "JELLY":
      case "M_SAND":
      case "P_SAND":      return Icons.grain_rounded;
      case "PAINT":       return Icons.format_paint_rounded;
      case "ELECTRICAL":  return Icons.electrical_services_rounded;
      case "PLUMBING":    return Icons.water_drop_outlined;
      case "LABOUR":      return Icons.engineering_rounded;
      case "TRANSPORT":   return Icons.local_shipping_outlined;
      case "FOOD":        return Icons.restaurant_outlined;
      case "MACHINERY":   return Icons.construction_rounded;
      case "RENTAL":      return Icons.handshake_outlined;
      case "FUEL":        return Icons.local_gas_station_outlined;
      default:            return Icons.receipt_long_rounded;
    }
  }

  String _formatAmount(String raw) {
    final d = double.tryParse(raw);
    if (d == null) return raw.length > 10 ? "${raw.substring(0, 8)}…" : raw;
    if (d >= 1000000) return "${(d / 1000000).toStringAsFixed(1)}M";
    if (d >= 1000) return "${(d / 1000).toStringAsFixed(1)}K";
    return d.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final accent = _expenseColor(entry.expenseType);
    final date = entry.purchaseDate;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            height: 44.r,
            width: 44.r,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(13.r),
              border: Border.all(color: accent.withOpacity(0.25), width: 0.5),
            ),
            child: Icon(_expenseIcon(entry.expenseType),
                color: accent, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.itemName.isEmpty
                            ? entry.expenseType
                            : entry.itemName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        entry.expenseType.replaceAll('_', ' '),
                        style: TextStyle(
                          color: accent,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    Text(
                      "${entry.quantity} ${entry.unit}",
                      style: TextStyle(
                          fontSize: 11.sp, color: const Color(0xFF4A4A6A)),
                    ),
                    if (entry.vendorName.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Container(
                          width: 3.r,
                          height: 3.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF4A4A6A),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          entry.vendorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: const Color(0xFF4A4A6A)),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 10.sp, color: const Color(0xFF4A4A6A)),
                    SizedBox(width: 4.w),
                    Text(
                      "${date.day} ${_monthName(date.month)} ${date.year}",
                      style: TextStyle(
                          fontSize: 10.sp, color: const Color(0xFF4A4A6A)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.totalAmount.isEmpty
                    ? "—"
                    : "₹${_formatAmount(entry.totalAmount)}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "₹${entry.pricePerUnit}/unit",
                style: TextStyle(
                    color: const Color(0xFF4A4A6A), fontSize: 10.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Empty state ────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String label;

  const _EmptyState({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40.sp, color: const Color(0xFF2A2A3A)),
          SizedBox(height: 12.h),
          Text(label,
              style: TextStyle(
                  fontSize: 14.sp, color: const Color(0xFF4A4A6A))),
        ],
      ),
    );
  }
}