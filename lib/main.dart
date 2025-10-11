import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/get_complaints_cubit/get_complaints_cubit.dart';
import 'cubit/get_complaints_cubit/get_complaints_states.dart';
import 'cubit/user_info_cubit/user_info_cubit.dart';
import 'firebase_options.dart';
import 'shared/bloc_observer.dart';
import 'widgets/home.dart';
import 'widgets/login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Widget startPoint;
  if (FirebaseAuth.instance.currentUser != null) {
    startPoint = const HomeWidget();
  } else {
    startPoint = const LoginScreen();
  }
  runApp(MSquaredHospitalityServices(
    startPoint: startPoint,
  ));
}

class MSquaredHospitalityServices extends StatelessWidget {
  const MSquaredHospitalityServices({super.key, required this.startPoint});

  final Widget startPoint;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UserInfoCubit()..getUserInfo(),
        ),
        BlocProvider(
          create: (context) => GetComplaintsCubit()..getComplaints(),
          child: BlocListener<GetComplaintsCubit,GetComplaintsStates>(
            listener: (context, state) {

            },
          ),
        )
      ],
      child: MaterialApp(
        title: 'MSquared Hospitality Services',
        debugShowCheckedModeBanner: false,
        home: startPoint,
      ),
    );
  }
}

