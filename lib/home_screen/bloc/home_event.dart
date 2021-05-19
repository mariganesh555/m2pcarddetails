import 'package:m2pcarddetails/utils/base_equitable.dart';

class HomeEvent extends BaseEquatable {}

class HomeInitialEvent extends HomeEvent {}

class HomeEnterVerificationCodeAlertEvent extends HomeEvent {}

class HomePermanantBlockOtpVerificationEvent extends HomeEvent {}

class HomeTemperaryBlockOtpVerificationEvent extends HomeEvent {}

class HomeCustomDialogEvent extends HomeEvent {}

class HomePermanantBlockCustomDialogEvent extends HomeEvent {}

class HomeTemperaryBlockCustomDialogEvent extends HomeEvent {}

class HomePremanantBlockAlertEvent extends HomeEvent {}

class HomeTemperaryBlockAlertEvent extends HomeEvent {}
