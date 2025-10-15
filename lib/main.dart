import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'cubit/get_complaints_cubit/get_complaints_cubit.dart';
import 'cubit/user_info_cubit/user_info_cubit.dart';
import 'firebase_options.dart';
import 'shared/bloc_observer.dart';
import 'widgets/login/login.dart';
import 'widgets/admin_view/admin_home_view.dart';
import 'widgets/bank_view/bank_home_view.dart';
import 'widgets/technician_view/technician_home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MSquaredHospitalityServices());
}

class MSquaredHospitalityServices extends StatelessWidget {
  const MSquaredHospitalityServices({super.key});

  Future<Widget> _getStartPoint() async {
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
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserInfoCubit()..getUserInfo()),
        BlocProvider(create: (context) => GetComplaintsCubit()..getComplaints()),
      ],
      child: MaterialApp(
        title: 'MSquared Hospitality Services',
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<Widget>(
          future: _getStartPoint(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              );
            } else {
              return snapshot.data!;
            }
          },
        ),
      ),
    );
  }
}
