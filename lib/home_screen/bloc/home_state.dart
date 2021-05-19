import 'package:m2pcarddetails/utils/base_equitable.dart';

class HomeState extends BaseEquatable {}

class HomeInitialState extends HomeState {}

class HomeloadingState extends HomeState {}

class HomeLoadedState extends HomeState {}

class HomeErrorState extends HomeState {
  String error;
  HomeErrorState(this.error);
}

class HomeConformOtpAlertState extends HomeState {}

class HomeCustomDialogState extends HomeState {}
