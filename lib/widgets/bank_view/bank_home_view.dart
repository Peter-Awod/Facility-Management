import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/user_info_cubit/user_info_cubit.dart';
import '../../cubit/user_info_cubit/user_info_states.dart';
import '../../shared/constants.dart';
import '../login/login.dart';
import 'maintenance_form.dart';

class BankHomeView extends StatefulWidget {
  const BankHomeView({super.key});

  @override
  State<BankHomeView> createState() => _BankHomeViewState();
}

class _BankHomeViewState extends State<BankHomeView> {
  final _firestore = FirebaseFirestore.instance;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ Safely load user info after context is available
    final cubit = UserInfoCubit.get(context);
    if (cubit.userInfoModel == null) {
      cubit.getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text(
          "Bank Dashboard",
          style: TextStyle(color: kSecondaryColor),
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: kSecondaryColor),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: kSecondaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MaintenanceForm()),
          );
        },
        icon: const Icon(Icons.add, color: kButtonsColor),
        label: const Text(
          "New Request",
          style: TextStyle(color: kButtonsColor),
        ),
      ),
      body: BlocBuilder<UserInfoCubit, UserInfoStates>(
        builder: (context, state) {
          final cubit = UserInfoCubit.get(context);

          if (state is UserInfoLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserInfoErrorState) {
            return Center(
              child: Text(
                state.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final user = cubit.userInfoModel;
          if (user == null || user.userId == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ Stream of only this bank's requests
          return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('maintenance_form')
                .where('userId', isEqualTo: user.userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Bank: ${user.bankName ?? 'N/A'}",
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kSecondaryColor)),
                      Text("Branch: ${user.branchName ?? 'N/A'}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black87)),
                      Text("Manager: ${user.managerName ?? 'N/A'}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black54)),
                      const Spacer(),
                      const Center(
                        child: Text("No maintenance requests yet."),
                      ),
                    ],
                  ),
                );
              }

              final requests = snapshot.data!.docs
                  .map((e) => e.data() as Map<String, dynamic>)
                  .toList();

              final pending = requests
                  .where((r) => r['requestStatus'] == 'pending')
                  .toList();
              final inProgress = requests
                  .where((r) => r['requestStatus'] == 'in-progress')
                  .toList();
              final completed = requests
                  .where((r) => r['requestStatus'] == 'completed')
                  .toList();

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    "${user.bankName ?? ''} - ${user.branchName ?? ''}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildSection("Pending", pending, Colors.orangeAccent),
                  _buildSection("In Progress", inProgress, Colors.blueAccent),
                  _buildSection("Completed", completed, Colors.green),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSection(
      String title,
      List<Map<String, dynamic>> items,
      Color color,
      ) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        ...items.map(
              (r) => Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text(r['maintenanceType'] ?? 'No type'),
              subtitle: Text(r['maintenanceDetails'] ?? 'No details'),
              trailing: Text(
                r['requestStatus'] ?? '',
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
