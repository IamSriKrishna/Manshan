import 'package:manshan/core/util/enums.dart';
import 'package:manshan/src/construction/domain/entity/paginated_construction_site.dart';
import 'package:manshan/src/construction/domain/entity/paginated_employee_site_assignment.dart';
import 'package:manshan/src/construction/domain/entity/paginated_site_entry.dart';

class ConstructionState {
  final EmployeeStatus siteStatus;
  final EmployeeStatus paginationStatus;
  final EmployeeStatus createSiteStatus;
  final EmployeeStatus assignmentStatus;
  final EmployeeStatus entryStatus;
  final PaginatedConstructionSite allSites;
  final String message;
  final String errorMessage;
  final bool hasMore;

  // Detail screen state
  final EmployeeStatus assignmentsLoadStatus;
  final EmployeeStatus assignmentsPaginationStatus;
  final PaginatedEmployeeSiteAssignment siteAssignments;
  final bool hasMoreAssignments;

  final EmployeeStatus entriesLoadStatus;
  final EmployeeStatus entriesPaginationStatus;
  final PaginatedSiteEntry siteEntries;
  final bool hasMoreEntries;

  const ConstructionState({
    required this.siteStatus,
    required this.paginationStatus,
    required this.createSiteStatus,
    required this.assignmentStatus,
    required this.entryStatus,
    required this.allSites,
    required this.message,
    required this.errorMessage,
    required this.hasMore,
    required this.assignmentsLoadStatus,
    required this.assignmentsPaginationStatus,
    required this.siteAssignments,
    required this.hasMoreAssignments,
    required this.entriesLoadStatus,
    required this.entriesPaginationStatus,
    required this.siteEntries,
    required this.hasMoreEntries,
  });

  factory ConstructionState.initial() {
    return ConstructionState(
      siteStatus: EmployeeStatus.initial,
      paginationStatus: EmployeeStatus.initial,
      createSiteStatus: EmployeeStatus.initial,
      assignmentStatus: EmployeeStatus.initial,
      entryStatus: EmployeeStatus.initial,
      allSites: PaginatedConstructionSite.initial(),
      message: "",
      errorMessage: "",
      hasMore: true,
      assignmentsLoadStatus: EmployeeStatus.initial,
      assignmentsPaginationStatus: EmployeeStatus.initial,
      siteAssignments: PaginatedEmployeeSiteAssignment.initial(),
      hasMoreAssignments: true,
      entriesLoadStatus: EmployeeStatus.initial,
      entriesPaginationStatus: EmployeeStatus.initial,
      siteEntries: PaginatedSiteEntry.initial(),
      hasMoreEntries: true,
    );
  }

  ConstructionState copyWith({
    EmployeeStatus? siteStatus,
    EmployeeStatus? paginationStatus,
    EmployeeStatus? createSiteStatus,
    EmployeeStatus? assignmentStatus,
    EmployeeStatus? entryStatus,
    PaginatedConstructionSite? allSites,
    String? message,
    String? errorMessage,
    bool? hasMore,
    EmployeeStatus? assignmentsLoadStatus,
    EmployeeStatus? assignmentsPaginationStatus,
    PaginatedEmployeeSiteAssignment? siteAssignments,
    bool? hasMoreAssignments,
    EmployeeStatus? entriesLoadStatus,
    EmployeeStatus? entriesPaginationStatus,
    PaginatedSiteEntry? siteEntries,
    bool? hasMoreEntries,
  }) {
    return ConstructionState(
      siteStatus: siteStatus ?? this.siteStatus,
      paginationStatus: paginationStatus ?? this.paginationStatus,
      createSiteStatus: createSiteStatus ?? this.createSiteStatus,
      assignmentStatus: assignmentStatus ?? this.assignmentStatus,
      entryStatus: entryStatus ?? this.entryStatus,
      allSites: allSites ?? this.allSites,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMore: hasMore ?? this.hasMore,
      assignmentsLoadStatus:
          assignmentsLoadStatus ?? this.assignmentsLoadStatus,
      assignmentsPaginationStatus:
          assignmentsPaginationStatus ?? this.assignmentsPaginationStatus,
      siteAssignments: siteAssignments ?? this.siteAssignments,
      hasMoreAssignments: hasMoreAssignments ?? this.hasMoreAssignments,
      entriesLoadStatus: entriesLoadStatus ?? this.entriesLoadStatus,
      entriesPaginationStatus:
          entriesPaginationStatus ?? this.entriesPaginationStatus,
      siteEntries: siteEntries ?? this.siteEntries,
      hasMoreEntries: hasMoreEntries ?? this.hasMoreEntries,
    );
  }
}