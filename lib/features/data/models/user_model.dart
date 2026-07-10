class UserModel {
  const UserModel({
    required this.id,
    required this.fullName,
  });

  final int id;
  final String fullName;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num).toInt(),
      fullName: json['full_name'] as String,
    );
  }
}