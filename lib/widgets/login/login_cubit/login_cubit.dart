// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/custom_widgets/snack_bar.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  // login
  userLogin(
      {required String email,
      required String password,
      required BuildContext context}) {
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error) {
      if (error.toString() ==
          '[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.') {
        showSnackBar(
          context: context,
          message: 'You entered wrong password or wrong email',
        );
      } else if (error.toString() ==
          '[firebase_auth/invalid-email] The email address is badly formatted.') {
        showSnackBar(
          context: context,
          message: 'You are using wrong email format',
        );
      }
      else if (error.code == 'wrong-password')
      {
        showSnackBar(
          context: context,
          message: 'Wrong password provided for that user.',
        );
      }

      emit(LoginErrorState(error.toString()));
    });
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
