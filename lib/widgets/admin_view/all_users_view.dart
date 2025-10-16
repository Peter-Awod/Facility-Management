import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/admin_users_cubit.dart';
import 'cubit/admin_users_states.dart';
import '../../shared/constants.dart';

class AllUsersView extends StatelessWidget {
  const AllUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final adminCubit = context.read<AdminUsersCubit>();
    adminCubit.fetchUsers();

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
        title: const Text("All Created Users",style: TextStyle(color: kSecondaryColor),),
        backgroundColor: kPrimaryColor,
      ),
      body: BlocBuilder<AdminUsersCubit, AdminUsersState>(
        builder: (context, state) {
          if (state is AdminUsersLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminUsersLoadedState) {
            if (state.users.isEmpty) {
              return const Center(child: Text("No users found."));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                final role = (user['role'] ?? '').toString();
                final email = (user['email'] ?? '').toString();
                final name = (user['bankName'] ?? user['name'] ?? '').toString();

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.person, color: kSecondaryColor),
                    title: Text(name.isNotEmpty ? name : 'Unnamed User'),
                    subtitle: Text(
                      "Email: $email\nRole: $role",
                      style: const TextStyle(fontSize: 13),
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            );
          } else if (state is AdminUsersErrorState) {
            return Center(
              child: Text(
                "Error: ${state.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
