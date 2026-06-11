// ignore_for_file: constant_identifier_names

enum EmployeeRole {
  SITHAL,
  PERIYAL,
  KOTHANAR,
  CARPENTER,
  CENTRING_WORKER,
  BAR_BENDER,
  ELECTRICIAN,
  PLUMBER,
  PAINTER,
  TILE_WORKER,
  WELDER,
  DRIVER,
  WATCHMAN,
  SUPERVISOR,
  SITE_ENGINEER,
  CONTRACTOR,
  OTHER;

  String get label {
    switch (this) {
      case EmployeeRole.SITHAL:
        return "Sithal";
      case EmployeeRole.PERIYAL:
        return "Periyal";
      case EmployeeRole.KOTHANAR:
        return "Kothanar";
      case EmployeeRole.CARPENTER:
        return "Carpenter";
      case EmployeeRole.CENTRING_WORKER:
        return "Centring Worker";
      case EmployeeRole.BAR_BENDER:
        return "Bar Bender";
      case EmployeeRole.ELECTRICIAN:
        return "Electrician";
      case EmployeeRole.PLUMBER:
        return "Plumber";
      case EmployeeRole.PAINTER:
        return "Painter";
      case EmployeeRole.TILE_WORKER:
        return "Tile Worker";
      case EmployeeRole.WELDER:
        return "Welder";
      case EmployeeRole.DRIVER:
        return "Driver";
      case EmployeeRole.WATCHMAN:
        return "Watchman";
      case EmployeeRole.SUPERVISOR:
        return "Supervisor";
      case EmployeeRole.SITE_ENGINEER:
        return "Site Engineer";
      case EmployeeRole.CONTRACTOR:
        return "Contractor";
      case EmployeeRole.OTHER:
        return "Other";
    }
  }

  String get value => name;
}
