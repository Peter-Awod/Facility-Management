// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../models/user_model.dart';
// import 'user_info_states.dart';
//
// class UserInfoCubit extends Cubit<UserInfoStates> {
//   UserInfoCubit() : super(UserInfoInitialState());
//
//   static UserInfoCubit get(BuildContext context) => BlocProvider.of(context);
//
//   UserInfoModel? userInfoModel;
//
//   Future<void> getUserInfo() async {
//     emit(UserInfoLoadingState());
//     try {
//       final uid = FirebaseAuth.instance.currentUser!.uid;
//       final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
//
//       if (snapshot.exists) {
//         userInfoModel = UserInfoModel.fromJson(snapshot.data()!);
//         emit(UserInfoSuccessState());
//       } else {
//         emit(UserInfoErrorState("User data not found."));
//       }
//     } catch (e) {
//       print(e.toString());
//       emit(UserInfoErrorState(e.toString()));
//     }
//   }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import 'user_info_states.dart';

class UserInfoCubit extends Cubit<UserInfoStates> {
  UserInfoCubit() : super(UserInfoInitialState());

  static UserInfoCubit get(BuildContext context) => BlocProvider.of(context);

  UserInfoModel? userInfoModel;

  Future<void> getUserInfo() async {
    emit(UserInfoLoadingState());
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        emit(UserInfoErrorState("No logged-in user found."));
        return;
      }

      final uid = currentUser.uid;
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!doc.exists) {
        emit(UserInfoErrorState("User document not found in Firestore."));
        return;
      }

      final data = doc.data() ?? {};
      userInfoModel = UserInfoModel.fromJson(data);
      emit(UserInfoLoadedState());
    } catch (e) {
      emit(UserInfoErrorState("Error fetching user info: ${e.toString()}"));
    }
  }

  void clearUserInfo() {
    userInfoModel = null;
    emit(UserInfoInitialState());
  }
}
