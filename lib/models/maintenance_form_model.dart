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

  //// will ignore these data
  String? permission;
  final String buildingNo;
  final String floorNo;
  final String apartmentNo;

  ////
  MaintenanceFormModel({
    required this.formId,
    required this.bankName,
    required this.branchName,
    required this.name,
    required this.phone,
    required this.addressDetails,

    required this.maintenanceType,
    required this.maintenanceDetails,
    this.requestStatus = 'pending',

    required this.buildingNo,
    required this.floorNo,
    required this.apartmentNo,
    required this.permission,
  });

  factory MaintenanceFormModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceFormModel(
      formId: json['formId'],

      bankName: 'bankName',
      branchName: 'branchName',
      name: json['name'],
      phone: json['phone'],
      addressDetails: json['addressDetails'],

      maintenanceType: json['maintenanceType'],
      maintenanceDetails: json['maintenanceDetails'],
      requestStatus: json['requestStatus'] ?? 'pending',

      buildingNo: json['buildingNo'],
      floorNo: json['floorNo'],
      apartmentNo: json['apartmentNo'],
      permission: json['permission'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formId': formId,

      'bankName': bankName,
      'branchName': branchName,
      'name': name,
      'phone': phone,
      'addressDetails': addressDetails,

      'maintenanceType': maintenanceType,
      'maintenanceDetails': maintenanceDetails,
      'requestStatus': requestStatus,

      'buildingNo': buildingNo,
      'floorNo': floorNo,
      'apartmentNo': apartmentNo,
      'permission': permission,
    };
  }
}
