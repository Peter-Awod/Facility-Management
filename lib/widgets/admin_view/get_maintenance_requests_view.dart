import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared/constants.dart';
import 'cubit/admin_users_cubit.dart';
import 'cubit/admin_users_states.dart';

class GetMaintenanceRequestsView extends StatefulWidget {
  const GetMaintenanceRequestsView({super.key});

  @override
  State<GetMaintenanceRequestsView> createState() => _GetMaintenanceRequestsViewState();
}

class _GetMaintenanceRequestsViewState extends State<GetMaintenanceRequestsView> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AdminUsersCubit()..fetchUsers(),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          title: const Text(
            "All Maintenance Requests",
            style: TextStyle(color: kSecondaryColor),
          ),
          backgroundColor: kPrimaryColor,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('maintenance_form').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No maintenance requests yet.",
                  style: TextStyle(color: kSecondaryColor),
                ),
              );
            }

            final requests = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final data = requests[index].data() as Map<String, dynamic>;
                final docId = requests[index].id;

                final status = data['requestStatus'] ?? 'pending';
                final color = _getStatusColor(status);

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
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
                        Text('Details: ${data['maintenanceDetails'] ?? 'N/A'}'),
                        Text(
                          'Status: $status',
                          style: TextStyle(color: color, fontWeight: FontWeight.bold),
                        ),
                        if (data['assignedTechnicianName'] != null)
                          Text('Technician: ${data['assignedTechnicianName']}'),
                      ],
                    ),
                    trailing: status == 'pending'
                        ? IconButton(
                      icon: const Icon(Icons.person_add, color: kSecondaryColor),
                      onPressed: () {
                        _showAssignDialog(context, BlocProvider.of<AdminUsersCubit>(context), docId);
                      },
                    )
                        : null,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  /// ✅ Show technician assignment dialog
  void _showAssignDialog(
      BuildContext context, AdminUsersCubit adminCubit, String docId) async {
    // Fetch technicians if not already loaded
    if (adminCubit.state is! AdminUsersLoadedState) {
      await adminCubit.fetchUsers();
    }

    final state = adminCubit.state;
    if (state is! AdminUsersLoadedState) return;

    final technicians = state.users
        .where((u) => (u['role'] ?? '').toString().toLowerCase() == 'technician')
        .toList();

    if (technicians.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No technicians found')),
      );
      return;
    }

    // Always initialize as null so no invalid value exists
    String? selectedTechId;
    String? selectedTechName;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Assign Technician"),
              content: DropdownButtonFormField<String>(
                value: selectedTechId,
                isExpanded: true,
                hint: const Text("Select Technician"),
                items: technicians.map((tech) {
                  final techId = tech['userId'] ?? '';
                  final name = tech['name'] ?? 'Unnamed';
                  return DropdownMenuItem<String>(
                    value: techId,
                    child: Text(name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedTechId = value;
                    selectedTechName = technicians
                        .firstWhere((t) => t['userId'] == value)['name'];
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Technician',
                  border: OutlineInputBorder(),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSecondaryColor,
                  ),
                  onPressed: () async {
                    if (selectedTechId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please select a technician first')),
                      );
                      return;
                    }

                    await FirebaseFirestore.instance
                        .collection('maintenance_form')
                        .doc(docId)
                        .update({
                      'assignedTechnicianId': selectedTechId,
                      'assignedTechnicianName': selectedTechName,
                      'requestStatus': 'assigned',
                    });

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Technician assigned successfully')),
                      );
                    }
                  },
                  child: const Text("Assign"),
                ),
              ],
            );
          },
        );
      },
    );
  }


  /// Color for each status
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
