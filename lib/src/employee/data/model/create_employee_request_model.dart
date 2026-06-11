class CreateEmployeeRequestModel {
  final String name;
  final String phone;
  final String role;
  final String image;
  final String salaryType;
  final double defaultSalary;
  final DateTime joiningDate;

  const CreateEmployeeRequestModel({
    this.name = "",
    this.phone = "",
    this.role = "",
    this.image = "",
    this.salaryType = "",
    this.defaultSalary = 0,
    required this.joiningDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "phone": phone,
      "role": role,
      "image": image,
      "salary_type": salaryType,
      "default_salary": defaultSalary,
      "joining_date": joiningDate.toUtc().toIso8601String(),
    };
  }
}
