class SignupRequestModel {
  final String name;
  final String email;
  final String password;

  const SignupRequestModel({
    this.name = "",
    this.email = "",
    this.password = "",
  });

  Map<String, dynamic> toJson() {
    return {"name": name.trim(), "email": email.trim(), "password": password};
  }
}
