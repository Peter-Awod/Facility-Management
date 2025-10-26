import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/user_info_cubit/user_info_cubit.dart';
import 'firebase_options.dart';
import 'shared/bloc_observer.dart';
import 'splash_screen.dart';
import 'widgets/admin_view/cubit/admin_users_cubit.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MSquaredHospitalityServices());
}

class MSquaredHospitalityServices extends StatelessWidget {
  const MSquaredHospitalityServices({super.key});



  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserInfoCubit()..getUserInfo()),

        BlocProvider(
          create: (context) => AdminUsersCubit(), // ✅ Added globally
        ),
      ],
      child: MaterialApp(
        title: 'MSquared Hospitality Services',
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
