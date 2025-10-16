class UserInfoModel {
  final String userId;
  final String email;
  final String role;

  // Common fields (Admin, Technician)
  final String? name;
  final String? phone;

  // Bank fields
  final String? bankName;
  final String? branchName;
  final String? managerName;
  final String? managerPhone;
  final String? branchAddress;

  // Technician field
  final String? jobTitle;

  final String? createdAt;

  UserInfoModel({
    required this.userId,
    required this.email,
    required this.role,
    this.name,
    this.phone,
    this.bankName,
    this.branchName,
    this.managerName,
    this.managerPhone,
    this.branchAddress,
    this.jobTitle,
    this.createdAt,
  });

  /// ✅ Convert Firestore data → Model safely
  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      userId: json['userId'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      name: json['name'],
      phone: json['phone'],
      bankName: json['bankName'],
      branchName: json['branchName'],
      managerName: json['managerName'],
      managerPhone: json['managerPhone'],
      branchAddress: json['branchAddress'],
      jobTitle: json['jobTitle'],
      createdAt: json['createdAt'],
    );
  }

  /// ✅ Convert Model → Map (for Firestore writes)
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'role': role,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (bankName != null) 'bankName': bankName,
      if (branchName != null) 'branchName': branchName,
      if (managerName != null) 'managerName': managerName,
      if (managerPhone != null) 'managerPhone': managerPhone,
      if (branchAddress != null) 'branchAddress': branchAddress,
      if (jobTitle != null) 'jobTitle': jobTitle,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}
