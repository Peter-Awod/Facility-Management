abstract class UserInfoStates {}

class UserInfoInitialState extends UserInfoStates {}

// User States
class GetUserLoadingState extends UserInfoStates {}

class GetUserSuccessState extends UserInfoStates {}

class GetUserErrorState extends UserInfoStates {
  final String error;

  GetUserErrorState(this.error);
}

