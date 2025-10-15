// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/custom_widgets/snack_bar.dart';
import '../../admin_view/admin_home_view.dart';
import '../../bank_view/bank_home_view.dart';
import '../../technician_view/technician_home_view.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(BuildContext context) => BlocProvider.of(context);

  // login
  Future<void> userLogin({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(LoginLoadingState());

    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = credential.user!.uid;

      // ✅ Get user role from Firestore
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        throw Exception('User data not found');
      }

      final role = userDoc.data()?['role'] ?? '';

      // ✅ Navigate based on role
      Widget destination;
      switch (role) {
        case 'admin':
          destination = const AdminHomeView();
          break;
        case 'bank':
          destination = const BankHomeView();
          break;
        case 'technician':
          destination = const TechnicianHomeView();
          break;
        default:
          showSnackBar(context: context, message: 'Unknown user role.');
          await FirebaseAuth.instance.signOut();
          return;
      }

      emit(LoginSuccessState(uid));

      // ✅ Navigate and clear history
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => destination),
            (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'invalid-credential') {
        showSnackBar(
          context: context,
          message: 'Incorrect email or password.',
        );
      } else if (error.code == 'invalid-email') {
        showSnackBar(
          context: context,
          message: 'Invalid email format.',
        );
      } else {
        showSnackBar(
          context: context,
          message: 'Login failed: ${error.message}',
        );
      }
      emit(LoginErrorState(error.toString()));
    } catch (e) {
      showSnackBar(
        context: context,
        message: 'Error: ${e.toString()}',
      );
      emit(LoginErrorState(e.toString()));
    }
  }

  // change password visibility
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changeIcon() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginChangePassIconState());
  }
}
