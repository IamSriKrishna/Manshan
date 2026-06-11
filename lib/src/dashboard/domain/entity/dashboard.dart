class Dashboard {
  final int totalEmployee;
  final int totalSites;
  final int ongoingSites;
  final int completedSites;
  final String salaryCost;
  final String materialCost;
  final String otherExpenses;
  final String totalCost;

  const Dashboard({
    required this.totalCost,
    required this.totalEmployee,
    required this.totalSites,
    required this.ongoingSites,
    required this.otherExpenses,
    required this.materialCost,
    required this.salaryCost,
    required this.completedSites,
  });

  factory Dashboard.initial() {
    return Dashboard(
      totalCost: "",
      totalEmployee: 0,
      totalSites: 0,
      ongoingSites: 0,
      otherExpenses: "",
      materialCost: "",
      salaryCost: "",
      completedSites: 0,
    );
  }
}
