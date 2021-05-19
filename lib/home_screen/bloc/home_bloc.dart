import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:m2pcarddetails/home_screen/bloc/home_event.dart';
import 'package:m2pcarddetails/home_screen/bloc/home_state.dart';
import 'package:m2pcarddetails/utils/string_resource.dart';
import 'package:m2pcarddetails/utils/validator.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState());

  TextEditingController dobTextController = TextEditingController();
  TextEditingController enterPinTextController = TextEditingController();
  TextEditingController conformPinTextController = TextEditingController();
  TextEditingController securityCodeTextController = TextEditingController();

  bool blockTemporary = false;
  bool blockPermanant = false;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeEnterVerificationCodeAlertEvent) {
      final dobStatus = Validator.validate(dobTextController.text.trim(),
          rules: ['required']);
      if (!dobStatus.status) {
        yield HomeErrorState(StringResource.dob + dobStatus.error);
        return;
      }

      final enterPinStatus = Validator.validate(
          enterPinTextController.text.trim(),
          rules: ['required']);
      if (!enterPinStatus.status) {
        yield HomeErrorState(StringResource.pin + enterPinStatus.error);
        return;
      }

      final conformPinStatus = Validator.validate(
          conformPinTextController.text.trim(),
          rules: ['required']);
      if (!conformPinStatus.status) {
        yield HomeErrorState(
            StringResource.conformPIN + conformPinStatus.error);
        return;
      }

      yield HomeConformOtpAlertState();
    }

    if (event is HomeCustomDialogEvent) {
      yield HomeCustomDialogState();
    }

    if (event is HomePremanantBlockAlertEvent) {
      yield HomePeramanantBlockAlertState();
    }

    if (event is HomeTemperaryBlockAlertEvent) {
      yield HomeTemperaryBlockAlertState();
    }
    if (event is HomePermanantBlockCustomDialogEvent) {
      yield HomePermanantBlockCustomDialogState();
    }

    if (event is HomeTemperaryBlockCustomDialogEvent) {
      yield HomeTemperaryBlockCustomDialogState();
    }

    if (event is HomeTemperaryBlockOtpVerificationEvent) {
      yield HomeTemperaryBlockOtpVerificationState();
    }

    if (event is HomePermanantBlockOtpVerificationEvent) {
      yield HomePeramanantBlockOtpVerificationState();
    }
  }
}
