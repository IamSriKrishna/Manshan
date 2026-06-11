class GrantRequestModel {
  final int accessedUserId;

  const GrantRequestModel({required this.accessedUserId});

  Map<String, dynamic> toJson() => {"accessed_user_id": accessedUserId};
}
