abstract class GetMaintenanceRequestsStates {}

class GetMaintenanceRequestsInitialState extends GetMaintenanceRequestsStates {}

class GetMaintenanceRequestsLoadingState extends GetMaintenanceRequestsStates {}

class GetMaintenanceRequestsSuccessState extends GetMaintenanceRequestsStates {}

class GetMaintenanceRequestsFailureState extends GetMaintenanceRequestsStates {
  final String error;
  GetMaintenanceRequestsFailureState(this.error);
}
