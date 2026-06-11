class SigninRequestModel {
  final String email;
  final String password;

  const SigninRequestModel({this.email = "", this.password = ""});

  Map<String, dynamic> toJson() {
    return {"email": email, "password": password};
  }
}
