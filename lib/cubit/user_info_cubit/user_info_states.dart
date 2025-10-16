abstract class UserInfoStates {}

class UserInfoInitialState extends UserInfoStates {}

// User States
class UserInfoLoadingState extends UserInfoStates {}

class UserInfoSuccessState extends UserInfoStates {}
class UserInfoLoadedState extends UserInfoStates {}

class UserInfoErrorState extends UserInfoStates {
  final String error;

  UserInfoErrorState(this.error);
}

