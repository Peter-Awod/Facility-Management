class GetComplaintsStates {}

class GetComplaintsInitialState extends GetComplaintsStates {}

class GetComplaintsLoadingState extends GetComplaintsStates {}

class GetComplaintsSuccessState extends GetComplaintsStates {}

class GetComplaintsErrorState extends GetComplaintsStates {
  final String error;

  GetComplaintsErrorState(this.error);
}