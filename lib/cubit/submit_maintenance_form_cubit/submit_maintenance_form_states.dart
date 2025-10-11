abstract class SubmitMaintenanceFormStates {}

class SubmitFormInitialState extends SubmitMaintenanceFormStates {}

class SubmitFormLoadingState extends SubmitMaintenanceFormStates {}

class SubmitFormSuccessState extends SubmitMaintenanceFormStates {}

class SubmitFormFailureState extends SubmitMaintenanceFormStates {
  final String error;

  SubmitFormFailureState({required this.error});
}

class UpdateRequestSuccessState extends SubmitMaintenanceFormStates {}

class UpdateRequestFailureState extends SubmitMaintenanceFormStates {
  final String error;

  UpdateRequestFailureState({required this.error});
}
