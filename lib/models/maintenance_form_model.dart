class MaintenanceFormModel {
  String? formId;
  final String userId;

  // bank info
  final String bankName;
  final String branchName;
  final String managerName; //contact
  final String managerPhone; //contact
  String? addressDetails;

  // maintenance info
  final String maintenanceType;
  String? maintenanceDetails;
  String requestStatus;

  MaintenanceFormModel({
    required this.formId,
    required this.userId,
    // bank info
    required this.bankName,
    required this.branchName,
    required this.managerName,
    required this.managerPhone,
    required this.addressDetails,
    // maintenance info
    required this.maintenanceType,
    required this.maintenanceDetails,
    this.requestStatus = 'pending',
  });

  factory MaintenanceFormModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceFormModel(
      formId: json['formId'] ?? '',
      userId: json['userId'] ?? '',
      bankName: json['bankName'] ?? '',
      branchName: json['branchName'] ?? '',
      managerName: json['managerName'] ?? '',
      managerPhone: json['managerPhone'] ?? '',
      addressDetails: json['addressDetails'] ?? 'No details',
      maintenanceType: json['maintenanceType'] ?? 'Other',
      maintenanceDetails: json['maintenanceDetails'] ?? 'No details',
      requestStatus: json['requestStatus'] ?? 'pending',
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'formId': formId,
      'userId': userId,
      // bank info
      'bankName': bankName,
      'branchName': branchName,
      'managerName': managerName,
      'managerPhone': managerPhone,
      'addressDetails': addressDetails,
      // maintenance info
      'maintenanceType': maintenanceType,
      'maintenanceDetails': maintenanceDetails,
      'requestStatus': requestStatus,
    };
  }
}
