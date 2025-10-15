class UserInfoModel {
  final String userId;
  final String email;
  final String name;
  final String phone;
  final String role;

  // Bank fields
  final String? bankName;
  final String? branchName;
  final String? managerName;
  final String? managerPhone;
  final String? branchAddress;

  // Technician field
  final String? jobTitle;

  UserInfoModel({
    required this.userId,
    required this.email,
    required this.name,
    required this.phone,
    required this.role,
    this.bankName,
    this.branchName,
    this.managerName,
    this.managerPhone,
    this.branchAddress,
    this.jobTitle,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      userId: json['userId'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      bankName: json['bankName'],
      branchName: json['branchName'],
      managerName: json['managerName'],
      managerPhone: json['managerPhone'],
      branchAddress: json['branchAddress'],
      jobTitle: json['jobTitle'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'bankName': bankName,
      'branchName': branchName,
      'managerName': managerName,
      'managerPhone': managerPhone,
      'branchAddress': branchAddress,
      'jobTitle': jobTitle,
    };
  }
}
