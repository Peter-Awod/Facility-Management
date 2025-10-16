import 'package:flutter/material.dart';
import '../../shared/constants.dart';
import '../../shared/custom_widgets/logout_button.dart';

class TechnicianHomeView extends StatelessWidget {
  const TechnicianHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: const Text('Technician Dashboard'),
        actions: const [LogoutButton()],
      ),
      body: const Center(
        child: Text(
          'Welcome, Technician! You can view and update assigned requests here.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
