import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:m2pcarddetails/home_screen/bloc/home_event.dart';
import 'package:m2pcarddetails/home_screen/bloc/home_state.dart';
import 'package:m2pcarddetails/utils/encryption_utils.dart';
import 'package:m2pcarddetails/utils/string_resource.dart';
import 'package:m2pcarddetails/utils/validator.dart';

import 'package:cryptography/cryptography.dart';
import 'package:pointycastle/ecc/api.dart';
import 'package:basic_utils/basic_utils.dart';

import 'package:convert/convert.dart';
import 'package:pointycastle/pointycastle.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitialState());

  TextEditingController dobTextController = TextEditingController();
  TextEditingController enterPinTextController = TextEditingController();
  TextEditingController conformPinTextController = TextEditingController();
  TextEditingController securityCodeTextController = TextEditingController();

  TextEditingController atmLimitTextController = TextEditingController();
  TextEditingController posLimitTextController = TextEditingController();
  TextEditingController ecomLimitTextController = TextEditingController();

  bool blockTemporary = false;
  bool blockPermanant = false;

  bool atmTransactions = false;
  bool posTransactions = false;
  bool ecomTransactions = false;
  bool internationalTransactions = false;
  bool contactlessTransactions = false;

  bool atmTransactionsLimit = false;
  bool posTransactionsLimit = false;
  bool ecomTransactionsLimit = false;

  String atmLimit = "";
  String posLimit = "";
  String ecomlimit = "";

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    if (event is HomeInitialEvent) {
      // final algorithmm = Ecdh.p256(length: 32);

      // // Alice chooses her key pair
      // final aliceKeyPair = await algorithm.newKeyPair();

      // // Alice knows Bob's public key
      // final bobKeyPair = await algorithm.newKeyPair();
      // final bobPublicKey = await bobKeyPair.extractPublicKey();

      // // Alice calculates the shared secret.
      // final sharedSecret = await algorithm.sharedSecretKey(
      //   keyPair: aliceKeyPair,
      //   remotePublicKey: bobPublicKey,
      // );
      // final sharedSecretBytes = await aliceKeyPair.extractPublicKey();
      // print('Shared secret: $sharedSecretBytes');

      // EcKeyPair keyPair = await algorithm.newKeyPair();

      // keyPair.extractPublicKey().then((value) {
      //   var secretKey =
      //       algorithm.sharedSecretKey(keyPair: keyPair, remotePublicKey: value);

      //   secretKey.then((value) => print(value.extractBytes()));
      // });

      // var keyPairr = secp256k1KeyPair();

      // PrivateKey privateKey = keyPairr.privateKey;
      // PublicKey publicKey = keyPairr.publicKey;
      // String pemString = CryptoUtils.encodeEcPublicKeyToPem(publicKey);
      // print(pemString);
      // Uint8List biteList = CryptoUtils.getBytesFromPEMString(pemString);
      // String haxString = CryptoUtils.getHash(biteList);
      // print("Hexstring is $haxString");

      // // in hex
      // print(privateKey.d.toRadixString(16));
      // print(publicKey.Q.x.toBigInteger().toRadixString(32));
      // print(publicKey.Q.y.toBigInteger().toRadixString(32));

      final algorithm = Cryptography.instance.x25519();

      // Let's generate two keypairs.
      final keyPair = await algorithm.newKeyPair();
      final remoteKeyPair = await algorithm.newKeyPair();

      final remotePublicKey = await remoteKeyPair.extractPublicKey();

      var result = hex.encode(remotePublicKey.bytes);
      print(result);

      // We can now calculate the shared secret key
      final sharedSecretKey = await algorithm.sharedSecretKey(
        keyPair: keyPair,
        remotePublicKey: remotePublicKey,
      );

      // SimplePublicKey(bytes, type: KeyPairType.p256)

      sharedSecretKey.extract().then((value) {
        print(value);
      });

      print(sharedSecretKey.extractBytes().then((value) async {
        print(value);
        // print(new String.fromCharCodes(value));
      }));
    }

    if (event is HomeEnterVerificationCodeAlertEvent) {
      final dobStatus = Validator.validate(dobTextController.text.trim(),
          rules: ['required']);
      if (!dobStatus.status) {
        yield HomeErrorState(StringResource.dob + dobStatus.error!);
        return;
      }

      final enterPinStatus = Validator.validate(
          enterPinTextController.text.trim(),
          rules: ['required']);
      if (!enterPinStatus.status) {
        yield HomeErrorState(StringResource.pin + enterPinStatus.error!);
        return;
      }

      final conformPinStatus = Validator.validate(
          conformPinTextController.text.trim(),
          rules: ['required']);
      if (!conformPinStatus.status) {
        yield HomeErrorState(
            StringResource.conformPIN + conformPinStatus.error!);
        return;
      }

      if (enterPinTextController.text.trim() !=
          conformPinTextController.text.trim()) {
        yield HomeErrorState("PIN Mismatch");
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

    if (event is HomeTemperaryUnBlockOtpVerificationEvent) {
      yield HomeTemperaryUnBlockOtpVerificationState();
    }

    if (event is HomePermanantUnBlockOtpVerificationEvent) {
      yield HomePeramanantUnBlockOtpVerificationState();
    }

    if (event is HomeTemperaryUnBlockCustomDialogEvent) {
      yield HomeTemperaryUnBlockCustomDialogState();
    }

    if (event is HomePermanantUnBlockCustomDialogEvent) {
      yield HomePermanantUnBlockCustomDialogState();
    }
    if (event is HomeCardUnLockCustomDialogEvent) {
      yield HomeCardUnLockCustomDialogState(event.cardPreference);
    }

    if (event is HomeCardLockCustomDialogEvent) {
      yield HomeCardLockCustomDialogState(event.cardPreference);
    }
  }
}
