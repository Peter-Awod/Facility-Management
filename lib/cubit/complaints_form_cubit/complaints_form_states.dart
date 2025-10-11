abstract class ComplaintsFormStates {}

class SubmitFormInitialState extends ComplaintsFormStates {}

class SubmitFormLoadingState extends ComplaintsFormStates {}

class SubmitFormSuccessState extends ComplaintsFormStates {}

class SubmitFormFailureState extends ComplaintsFormStates {
  final String error;

  SubmitFormFailureState({required this.error});
}

class UpdateRequestSuccessState extends ComplaintsFormStates {}

class UpdateRequestFailureState extends ComplaintsFormStates {
  final String error;

  UpdateRequestFailureState({required this.error});
}
