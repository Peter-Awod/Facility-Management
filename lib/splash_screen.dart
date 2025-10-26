import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facility_management/shared/constants.dart';
import 'package:facility_management/widgets/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'widgets/admin_view/admin_home_view.dart';
import 'widgets/bank_view/bank_home_view.dart';
import 'widgets/technician_view/technician_home_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<Widget> _nextScreen;

  Future<Widget> getStartPoint() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // 🔹 No user logged in → go to login
      return const LoginScreen();
    }

    try {
      // 🔹 Fetch user role from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final role = userDoc.data()?['role'];

      if (role == 'admin') {
        return const AdminHomeView();
      } else if (role == 'bank') {
        return const BankHomeView();
      } else if (role == 'technician') {
        return const TechnicianHomeView();
      } else {
        // 🔹 Unknown role → fallback to login
        await FirebaseAuth.instance.signOut();
        return const LoginScreen();
      }
    } catch (e) {
      // 🔹 Error fetching user → fallback to login
      await FirebaseAuth.instance.signOut();
      return const LoginScreen();
    }
  }

  @override
  void initState() {
    super.initState();
    _nextScreen = _loadWithDelay();
  }

  Future<Widget> _loadWithDelay() async {
    // 🔹 Wait at least 3 seconds before navigating
    final results = await Future.wait([
      getStartPoint(),
      Future.delayed(const Duration(seconds: 3)),
    ]);

    return results[0]; // return the screen after the delay
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _nextScreen,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: kPrimaryColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: kSecondaryColor),
                  SizedBox(height: 20),
                  Text(
                    'Welcome to Facility Management',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kSecondaryColor,
                      fontSize: 20,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Icon(
                      Icons.scatter_plot_outlined,
                      color: kSecondaryColor,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          return snapshot.data!;
        }
      },
    );
  }
}
