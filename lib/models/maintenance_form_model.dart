class MaintenanceFormModel {
  String? formId;
  final String userId;

  // Bank info
  final String bankName;
  final String branchName;
  final String managerName;
  final String managerPhone;
  String? addressDetails;

  // Maintenance info
  final String maintenanceType;
  String? maintenanceDetails;
  String requestStatus;

  // 👇 New fields
  String? assignedTechnicianId;
  String? assignedTechnicianName;

  MaintenanceFormModel({
    required this.formId,
    required this.userId,
    required this.bankName,
    required this.branchName,
    required this.managerName,
    required this.managerPhone,
    required this.addressDetails,
    required this.maintenanceType,
    required this.maintenanceDetails,
    this.requestStatus = 'pending',
    this.assignedTechnicianId,
    this.assignedTechnicianName,
  });

  factory MaintenanceFormModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceFormModel(
      formId: json['formId'],
      userId: json['userId'],
      bankName: json['bankName'],
      branchName: json['branchName'],
      managerName: json['managerName'],
      managerPhone: json['managerPhone'],
      addressDetails: json['addressDetails'],
      maintenanceType: json['maintenanceType'],
      maintenanceDetails: json['maintenanceDetails'],
      requestStatus: json['requestStatus'] ?? 'pending',
      assignedTechnicianId: json['assignedTechnicianId'],
      assignedTechnicianName: json['assignedTechnicianName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formId': formId,
      'userId': userId,
      'bankName': bankName,
      'branchName': branchName,
      'managerName': managerName,
      'managerPhone': managerPhone,
      'addressDetails': addressDetails,
      'maintenanceType': maintenanceType,
      'maintenanceDetails': maintenanceDetails,
      'requestStatus': requestStatus,
      'assignedTechnicianId': assignedTechnicianId,
      'assignedTechnicianName': assignedTechnicianName,
    };
  }
}
