import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/get_complaints_cubit/get_complaints_cubit.dart';
import 'cubit/user_info_cubit/user_info_cubit.dart';
import 'firebase_options.dart';
import 'shared/bloc_observer.dart';
import 'widgets/home.dart';
import 'widgets/login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Decide the first screen based on login state
  final startPoint = FirebaseAuth.instance.currentUser != null
      ? const HomeWidget()
      : const LoginScreen();

  runApp(MSquaredHospitalityServices(startPoint: startPoint));
}

class MSquaredHospitalityServices extends StatelessWidget {
  const MSquaredHospitalityServices({super.key, required this.startPoint});

  final Widget startPoint;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 🔹 Initialize UserInfoCubit immediately on app start
        BlocProvider(
          create: (context) => UserInfoCubit()..getUserInfo(),
        ),

        // 🔹 Initialize GetComplaintsCubit once globally
        BlocProvider(
          create: (context) => GetComplaintsCubit()..getComplaints(),
        ),
      ],
      child: MaterialApp(
        title: 'MSquared Hospitality Services',
        debugShowCheckedModeBanner: false,
        home: startPoint,
      ),
    );
  }
}
