import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_user_view.dart';
import 'cubit/admin_users_cubit.dart';
import 'cubit/admin_users_states.dart';
import '../../shared/constants.dart';
import '../../shared/custom_widgets/snack_bar.dart';

class AdminHomeView extends StatelessWidget {
  const AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // make sure cubit exists globally in main.dart MultiBlocProvider
    final adminCubit = context.read<AdminUsersCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => adminCubit.fetchUsers(),
            tooltip: 'Refresh users',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await adminCubit.logout(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kSecondaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CreateUserView()),
                );
              },
              icon: const Icon(Icons.person_add),
              label: const Text("Create New User"),
            ),
          ),
          const SizedBox(height: 16),
          const Expanded(child: _UsersListSection()),
        ],
      ),
    );
  }
}

class _UsersListSection extends StatelessWidget {
  const _UsersListSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminUsersCubit, AdminUsersState>(
      builder: (context, state) {
        if (state is AdminUsersLoadingState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is AdminUsersLoadedState) {
          if (state.users.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final Map<String, dynamic> user = state.users[index];
              final role = (user['role'] ?? '').toString();
              final email = (user['email'] ?? '').toString();
              final display = (user['bankName'] ?? user['name'] ?? '').toString();

              return Card(
                color: kSecondaryColor.withOpacity(0.06),
                child: ListTile(
                  leading: const Icon(Icons.person, color: kSecondaryColor),
                  title: Text(email.isNotEmpty ? email : 'No Email'),
                  subtitle: Text(role.isNotEmpty ? role : 'Unknown Role'),
                  trailing: Text(display, style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
              );
            },
          );
        } else if (state is AdminUsersErrorState) {
          return Center(child: Text('Error: ${state.error}', style: const TextStyle(color: Colors.red)));
        } else {
          // initial or unknown state: trigger fetch once and show loader
          // (this is defensive in case cubit wasn't auto-loaded)
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AdminUsersCubit>().fetchUsers();
          });
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
