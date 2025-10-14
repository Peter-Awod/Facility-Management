import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/maintenance_form_model.dart';
import 'get_maintenance_requests_states.dart';

class GetMaintenanceRequestsCubit extends Cubit<GetMaintenanceRequestsStates> {
  GetMaintenanceRequestsCubit() : super(GetMaintenanceRequestsInitialState());

  static GetMaintenanceRequestsCubit get(BuildContext context) => BlocProvider.of(context);

  List<MaintenanceFormModel> allRequests = [];
  List<MaintenanceFormModel> pendingRequests = [];
  List<MaintenanceFormModel> inProgressRequests = [];
  List<MaintenanceFormModel> completedRequests = [];

  void getRequests() {
    emit(GetMaintenanceRequestsLoadingState());
    FirebaseFirestore.instance
        .collection('maintenance_form')
        .snapshots()
        .listen((event) {
      allRequests = event.docs
          .map((doc) => MaintenanceFormModel.fromJson(doc.data()))
          .toList();

      pendingRequests =
          allRequests.where((r) => r.requestStatus == 'pending').toList();
      inProgressRequests =
          allRequests.where((r) => r.requestStatus == 'in-progress').toList();
      completedRequests =
          allRequests.where((r) => r.requestStatus == 'completed').toList();

      emit(GetMaintenanceRequestsSuccessState());
    }, onError: (error) {
      emit(GetMaintenanceRequestsFailureState(error.toString()));
    });
  }
}
