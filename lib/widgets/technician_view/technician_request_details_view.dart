import 'package:flutter/material.dart';
import '../../shared/constants.dart';

class TechnicianRequestDetailsView extends StatelessWidget {
  final Map<String, dynamic> requestData;
  final Function(String newStatus)? onStatusChange;

  const TechnicianRequestDetailsView({
    super.key,
    required this.requestData,
    this.onStatusChange,
  });

  @override
  Widget build(BuildContext context) {
    final status = requestData['requestStatus'] ?? 'pending';
    final maintenanceType = requestData['maintenanceType'] ?? '';
    final maintenanceDetails = requestData['maintenanceDetails'] ?? '';
    final bankName = requestData['bankName'] ?? '';
    final branchName = requestData['branchName'] ?? '';
    final managerName = requestData['managerName'] ?? '';
    final managerPhone = requestData['managerPhoneNumber'] ?? '';
    final assignedTechnicianName = requestData['assignedTechnicianName'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Details', style: TextStyle(color: kSecondaryColor)),
        backgroundColor: kPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _infoTile('Status', status, _statusColor(status)),
            _infoTile('Maintenance Type', maintenanceType),
            _infoTile('Details', maintenanceDetails),
            const Divider(),
            _infoTile('Bank', bankName),
            _infoTile('Branch', branchName),
            _infoTile('Manager', managerName),
            _infoTile('Manager Phone', managerPhone),
            const Divider(),
            _infoTile('Assigned Technician', assignedTechnicianName),
            const SizedBox(height: 24),
            if (status == 'assigned' || status == 'in-progress')
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    String newStatus = status == 'assigned'
                        ? 'in-progress'
                        : 'completed';
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Confirm Status Change'),
                        content: Text('Change status to "$newStatus"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Yes'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true && onStatusChange != null) {
                      onStatusChange!(newStatus);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    status == 'assigned' ? Colors.blue : Colors.green,
                  ),
                  child: Text(
                    status == 'assigned'
                        ? 'Mark In-Progress'
                        : 'Mark Completed',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: TextStyle(color: color ?? Colors.black87)),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'assigned':
        return Colors.purple;
      case 'in-progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }
}
