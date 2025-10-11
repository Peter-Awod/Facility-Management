// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';
import '../../../shared/custom_widgets/snack_bar.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  userRegister(
      {required String name,
      required String email,
      required String password,
      required String phone,
      required BuildContext context}) {
    emit(RegisterLoadingState());

    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      UserModel userModel = UserModel(
        name: name,
        phone: phone,
        email: email,
        userId: value.user!.uid,
        isAdmin: false,
        isRequestedService: false,
      );
      createUser(userModel: userModel);
    }).catchError((error) {
      if (error.toString() ==
          '[firebase_auth/weak-password] Password should be at least 6 characters') {
        showSnackBar(
          context: context,
          message: 'The password provided is too weak.',
        );
      } else if (error.toString() ==
          '[firebase_auth/email-already-in-use] The email address is already in use by another account.') {
        showSnackBar(
          context: context,
          message: 'The account already exists for that email.',
        );
      } else {
        showSnackBar(
          context: context,
          message: 'There was an error.',
        );
      }

      emit(RegisterErrorState(error.toString()));
    });
  }

  createUser({required UserModel userModel}) {
    UserModel model = userModel;
    FirebaseFirestore.instance
        .collection('users')
        .doc(model.userId)
        .set(model.toJson())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }

  // change password visibility

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changeIcon() {
    isPassword = !isPassword;

    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(RegisterChangePassIconState());
  }
}
