// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/maintenance_form_model.dart';
import 'submit_maintenance_form_states.dart';

class SubmitMaintenanceFormCubit extends Cubit<SubmitMaintenanceFormStates> {
  SubmitMaintenanceFormCubit() : super(SubmitFormInitialState());

  static SubmitMaintenanceFormCubit get(BuildContext context) => BlocProvider.of(context);


  void submitForm(MaintenanceFormModel formModel) {
    emit(SubmitFormLoadingState());
    final userId = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance
        .collection('maintenance_form')
        .add(formModel.toJson())
        .then((value) async {
      String formId = value.id;
      await value.update({'formId': formId});

      try {
        // ✅ Get current user document
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        final currentIsRequestedService = userDoc.data()?['isRequestedService'];

        // ✅ Only update if it's false or not set
        if (currentIsRequestedService == false || currentIsRequestedService == null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .update({'isRequestedService': true});

          emit(UpdateRequestSuccessState());
        }
      } catch (error) {
        emit(UpdateRequestFailureState(error: error.toString()));
      }

      emit(SubmitFormSuccessState());
    }).catchError((error) {
      emit(SubmitFormFailureState(error: error.toString()));
    });
  }



}
//   void submitForm(MaintenanceFormModel formModel) {
//     emit(SubmitFormLoadingState());
//     FirebaseFirestore.instance
//         .collection('maintenance_form')
//         .add(formModel.toJson())
//         .then((value) {
//       String formId = value.id;
//       value.update({'formId': formId});
//
//       // update user request state
//       FirebaseFirestore.instance
//           .collection('users')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .update({'isRequestedService': true}).then((value) {
//         emit(UpdateRequestSuccessState());
//       }).catchError((error) {
//         emit(UpdateRequestFailureState(error: error.toString()));
//       });
//       emit(SubmitFormSuccessState());
//     }).catchError((error) {
//       emit(SubmitFormFailureState(error: error.toString()));
//     });
//   }
