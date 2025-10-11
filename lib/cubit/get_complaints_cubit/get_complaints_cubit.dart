import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/complaints_form_model.dart';
import 'get_complaints_states.dart';

class GetComplaintsCubit extends Cubit<GetComplaintsStates> {
  GetComplaintsCubit() : super(GetComplaintsInitialState());

  static GetComplaintsCubit get(context) => BlocProvider.of(context);

  List<ComplaintsFormModel> complaintsFormModelList = [];

 void getComplaints() {
    emit(GetComplaintsLoadingState());
    List<ComplaintsFormModel> complaintsFormModel=[];
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('complaints_form')
        .get()
        .then((value) {
      value.docs.forEach((element) {
         complaintsFormModel
            .add(ComplaintsFormModel.fromJson(element.data()));
      });
      complaintsFormModel.forEach((element) {
        if(element.complainIsActive==true)
          {
            complaintsFormModelList.add(element);
          }
      });
      emit(GetComplaintsSuccessState());
    }).catchError((error) {
      print('Complaints error $error.toString()');
      emit(GetComplaintsErrorState(error.toString()));
    });
  }
}
