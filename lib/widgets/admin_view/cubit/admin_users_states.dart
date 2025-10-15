abstract class AdminUsersState {}

class AdminUsersInitialState extends AdminUsersState {}

class AdminUsersLoadingState extends AdminUsersState {}

class AdminUsersLoadedState extends AdminUsersState {
  final List<Map<String, dynamic>> users;
  AdminUsersLoadedState(this.users);
}

class AdminUsersErrorState extends AdminUsersState {
  final String error;
  AdminUsersErrorState(this.error);
}
