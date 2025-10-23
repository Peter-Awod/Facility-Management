import 'package:flutter/material.dart';

import '../../shared/constants.dart';

class RequestDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const RequestDetailsScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: kSecondaryColor,
          ),
        ),
        title: const Text('Request Details',
          style: TextStyle(color: kSecondaryColor),),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              data['maintenanceType'] ?? 'No type',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: kSecondaryColor),
            ),
            const Divider(),
            _detailRow('Bank Name', data['bankName']),
            _detailRow('Branch Name', data['branchName']),
            _detailRow('Manager Name', data['managerName']),
            _detailRow('Manager Phone', data['managerPhone']),
            _detailRow('Maintenance Details', data['maintenanceDetails']),
            _detailRow('Request Status', data['requestStatus']),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(color: kSecondaryColor,fontWeight: FontWeight.bold,)),
          Expanded(child: Text(value ?? 'N/A',style: const TextStyle(color: Colors.white,))),
        ],
      ),
    );
  }
}