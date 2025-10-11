// ignore_for_file: avoid_print


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/complaints_form_model.dart';
import 'complaints_form_states.dart';

class SubmitComplaintFormCubit extends Cubit<ComplaintsFormStates> {
  SubmitComplaintFormCubit() : super(SubmitFormInitialState());

  static SubmitComplaintFormCubit get(BuildContext context) => BlocProvider.of(context);

  void submitForm(ComplaintsFormModel complaintsFormModel) {
    emit(SubmitFormLoadingState());
    final userId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('complaints_form')
        .add(complaintsFormModel.toJson())
        .then((value) async {
      String formId = value.id;
      await value.update({'formId': formId});

      // ✅ Check current user document before updating
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

      final currentIsComplainActive = userDoc.data()?['isComplainActive'];

      if (currentIsComplainActive == false || currentIsComplainActive == null) {
        // Update only if it was false or doesn't exist
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'isComplainActive': true});

        emit(UpdateRequestSuccessState());
      }

      emit(SubmitFormSuccessState());
    }).catchError((error) {
      print('SubmitFormFailureState ${error.toString()}');
      emit(SubmitFormFailureState(error: error.toString()));
    });
  }



//
// void  submitForm(ComplaintsFormModel complaintsFormModel) {
//     emit(SubmitFormLoadingState());
//     FirebaseFirestore.instance.collection('users').doc(
//         FirebaseAuth.instance.currentUser!.uid
//     )
//         .collection('complaints_form')
//         .add(complaintsFormModel.toJson())
//         .then((value) {
//       String formId = value.id;
//       value.update({'formId': formId});
//
//       // update user request state
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .update({'isComplainActive': true}).then((value) {
//         emit(UpdateRequestSuccessState());
//       }).catchError((error) {
//         emit(UpdateRequestFailureState(error: error.toString()));
//       });
//       emit(SubmitFormSuccessState());
//     }).catchError((error) {
//       print('SubmitFormFailureState ${error.toString()}');
//       emit(SubmitFormFailureState(error: error.toString()));
//     });
//   }
}
