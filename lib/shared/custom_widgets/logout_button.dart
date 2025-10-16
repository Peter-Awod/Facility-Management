import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


import '../../widgets/login/login.dart';
import 'snack_bar.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    showSnackBar(context: context, message: 'Logged out successfully');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout, color: Colors.white),
      tooltip: 'Logout',
      onPressed: () => _logout(context),
    );
  }
}
