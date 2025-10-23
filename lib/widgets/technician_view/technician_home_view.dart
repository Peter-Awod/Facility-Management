import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../cubit/user_info_cubit/user_info_cubit.dart';
import '../../shared/constants.dart';
import '../login/login.dart';
import 'technician_request_details_view.dart';

class TechnicianHomeView extends StatelessWidget {
  const TechnicianHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text(
          'My Assigned Requests',
          style: TextStyle(color: kSecondaryColor),
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout,color: kSecondaryColor,),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                UserInfoCubit.get(context).clearUserInfo();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('maintenance_form')
            .where('assignedTechnicianId', isEqualTo: currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No assigned requests yet.'));
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data() as Map<String, dynamic>;
              final docId = requests[index].id;

              final status = data['requestStatus'] ?? 'pending';
              final color = _getStatusColor(status);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    data['maintenanceType'] ?? 'No type',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Bank: ${data['bankName'] ?? 'N/A'}'),
                      Text('Branch: ${data['branchName'] ?? 'N/A'}'),
                      Text(
                        'Status: $status',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _showRequestDetails(context, data),
                  trailing: _buildStatusAction(context, docId, status),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// ✅ Action button depending on request status
  Widget? _buildStatusAction(
    BuildContext context,
    String docId,
    String status,
  ) {
    if (status == 'assigned') {
      return IconButton(
        icon: const Icon(Icons.play_arrow, color: Colors.blue),
        tooltip: 'Start (In Progress)',
        onPressed: () async {
          await FirebaseFirestore.instance
              .collection('maintenance_form')
              .doc(docId)
              .update({'requestStatus': 'in-progress'});

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request marked as In Progress')),
          );
        },
      );
    } else if (status == 'in-progress') {
      return IconButton(
        icon: const Icon(Icons.check_circle, color: Colors.green),
        tooltip: 'Mark Completed',
        onPressed: () => _confirmCompletion(context, docId),
      );
    } else {
      return const Icon(Icons.check, color: Colors.grey);
    }
  }

  /// ✅ Confirmation dialog before marking as completed
  void _confirmCompletion(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Completion'),
        content: const Text(
          'Are you sure you want to mark this request as completed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kSecondaryColor),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('maintenance_form')
                  .doc(docId)
                  .update({'requestStatus': 'completed'});

              if (context.mounted) Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Request marked as Completed')),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  /// ✅ Show details screen
  void _showRequestDetails(BuildContext context, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RequestDetailsScreen(data: data)),
    );
  }

  /// ✅ Status color helper
  Color _getStatusColor(String status) {
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


