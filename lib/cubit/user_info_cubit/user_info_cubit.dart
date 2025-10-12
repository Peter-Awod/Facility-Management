// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user_model.dart';
import 'user_info_states.dart';

class UserInfoCubit extends Cubit<UserInfoStates> {
  UserInfoCubit() : super(UserInfoInitialState());

  static UserInfoCubit get(context) => BlocProvider.of(context);

  // Getting current user information
  UserModel? userModel;


  Future<void> getUserInfo() async{
    emit(GetUserLoadingState());

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        emit(GetUserErrorState('No authenticated user found'));
        return;
      }

      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (snapshot.exists && snapshot.data() != null) {
        userModel = UserModel.fromJson(snapshot.data()!);
        emit(GetUserSuccessState());
      } else {
        emit(GetUserErrorState('User data not found'));
      }
    } catch (error) {
      emit(GetUserErrorState(error.toString()));
    }
  }

  Future<void> refreshUser() async {
    await getUserInfo();
  }
}
