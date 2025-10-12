class MaintenanceFormModel {
  String? formId;

  // bank info
  final String bankName;
  final String branchName;
  final String name; //contact
  final String phone; //contact
  String? addressDetails;

  // maintenance info
  final String maintenanceType;
  String? maintenanceDetails;
  String requestStatus;

  MaintenanceFormModel({
    required this.formId,
    // bank info
    required this.bankName,
    required this.branchName,
    required this.name,
    required this.phone,
    required this.addressDetails,
    // maintenance info
    required this.maintenanceType,
    required this.maintenanceDetails,
    this.requestStatus = 'pending',
  });

  factory MaintenanceFormModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceFormModel(
      formId: json['formId'],
      // bank info
      bankName: 'bankName',
      branchName: 'branchName',
      name: json['name'],
      phone: json['phone'],
      addressDetails: json['addressDetails'],
      // maintenance info
      maintenanceType: json['maintenanceType'],
      maintenanceDetails: json['maintenanceDetails'],
      requestStatus: json['requestStatus'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formId': formId,
      // bank info
      'bankName': bankName,
      'branchName': branchName,
      'name': name,
      'phone': phone,
      'addressDetails': addressDetails,
      // maintenance info
      'maintenanceType': maintenanceType,
      'maintenanceDetails': maintenanceDetails,
      'requestStatus': requestStatus,
    };
  }
}
