class ComplaintsFormModel {
  String? formId;
  final String userId;
  final String complaintNumber;
  final String name;
  final String phone;
  final String buildingNumber;
  final String unitType;
  final String unitNumber;
  final String complaintsType;
  final String complaintDetails;
  final bool complainIsActive;

  ComplaintsFormModel({
    required this.formId,
    required this.userId,
    required this.complaintNumber,
    required this.name,
    required this.phone,
    required this.buildingNumber,
    required this.unitType,
    required this.unitNumber,
    required this.complaintsType,
    required this.complaintDetails,
    required this.complainIsActive,
  });

  factory ComplaintsFormModel.fromJson(Map<String, dynamic> json) {
    return ComplaintsFormModel(
      formId: json['formId'],
      userId: json['userId'],
      complaintNumber: json['complaintNumber'],
      name: json['name'],
      phone: json['phone'],
      buildingNumber: json['buildingNumber'],
      unitType: json['unitType'],
      unitNumber: json['unitNumber'],
      complaintsType: json['complaintsType'],
      complaintDetails: json['complaintDetails'],
      complainIsActive: json['complainIsActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formId': formId,
      'userId': userId,
      'complaintNumber': complaintNumber,
      'name': name,
      'phone': phone,
      'buildingNumber': buildingNumber,
      'unitType': unitType,
      'unitNumber': unitNumber,
      'complaintsType': complaintsType,
      'complaintDetails': complaintDetails,
      'complainIsActive': complainIsActive,
    };
  }
}
