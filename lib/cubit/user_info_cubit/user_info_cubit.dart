import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        userInfoModel = UserInfoModel.fromJson(snapshot.data()!);
        emit(UserInfoSuccessState());
      } else {
        emit(UserInfoErrorState("User data not found."));
      }
    } catch (e) {
      emit(UserInfoErrorState(e.toString()));
    }
  }
}
