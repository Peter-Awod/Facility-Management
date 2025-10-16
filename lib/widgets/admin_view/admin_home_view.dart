import 'package:facility_management/shared/custom_widgets/custom_material_button.dart';
import 'package:facility_management/widgets/admin_view/get_maintenance_requests_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_user_view.dart';
import 'cubit/admin_users_cubit.dart';
import '../../shared/constants.dart';
import 'all_users_view.dart'; // ✅ Import the new screen

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final adminCubit = context.read<AdminUsersCubit>();

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: kSecondaryColor,),
        ),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: kSecondaryColor),
            onPressed: () async {
              await adminCubit.logout(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomMaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GetMaintenanceRequestsView(),
                  ),
                );
              },
              buttonName: 'View Requests',
            ),
            const SizedBox(height: 16),
            CustomMaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateUserView()),
                );
              },
              buttonName: 'Create New User',
            ),

            const SizedBox(height: 16),
            CustomMaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AllUsersView()),
                );
              },
              buttonName: 'View All Users',
            ),
          ],
        ),
      ),
    );
  }
}
