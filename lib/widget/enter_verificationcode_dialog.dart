import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:m2pcarddetails/utils/apputils.dart';
import 'package:m2pcarddetails/utils/color_resource.dart';
import 'package:m2pcarddetails/utils/font.dart';
import 'package:m2pcarddetails/utils/image_resource.dart';
import 'package:m2pcarddetails/utils/string_resource.dart';
import 'package:m2pcarddetails/widget/custom_text.dart';
import 'package:m2pcarddetails/widget/primary_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ConformPasswordAlertDialog extends StatefulWidget {
  TextEditingController passwordTextController = TextEditingController();
  Function onProceedTapped;

  ConformPasswordAlertDialog(this.onProceedTapped);

  GlobalKey<FormFieldState<String>> searchFormKey =
      GlobalKey<FormFieldState<String>>();

  @override
  _ConformPasswordAlertDialogState createState() =>
      _ConformPasswordAlertDialogState();
}

class _ConformPasswordAlertDialogState
    extends State<ConformPasswordAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(),
    );
  }

  Widget contentBox() {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            // boxShadow: [
            //   const BoxShadow(offset: Offset(0, 10), blurRadius: 10),
            // ]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                "Enter Your Verification Code",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: ColorResource.color1c1d22),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: CustomText(
                                  StringResource.otpSentToRegisteredNumber,
                                  fontSize: 14,
                                  color: Color.fromRGBO(21, 21, 21, 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 69,
                          height: 83,
                          margin: const EdgeInsets.only(left: 30),
                          child: Image(
                              image: ImageResource.otpImage, fit: BoxFit.cover),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Container(
              //   decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(10),
              //       border: Border.all(
              //         color: ColorResource.colorb9b9bf,
              //       )),
              //   child: OTPTextField(
              //     length: 5,
              //     width: MediaQuery.of(context).size.width,
              //     fieldWidth: 80,
              //     style: TextStyle(fontSize: 17),
              //     textFieldAlignment: MainAxisAlignment.spaceAround,
              //     fieldStyle: FieldStyle.underline,
              //     onCompleted: (pin) {
              //       print("Completed: " + pin);
              //     },
              //   ),
              // ),
              const SizedBox(
                height: 22,
              ),
              Center(
                child: PrimaryButton(
                  "Verify",
                  onClick: () {
                    if (widget.passwordTextController.text.isNotEmpty) {
                      widget.onProceedTapped(
                          widget.passwordTextController.text.trim());
                      Navigator.pop(context);
                    } else {
                      AppUtils.showErrorToast("Enter Your OTP");
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Container(
                  width: 60,
                  child: PrimaryButton(
                    "Cancel",
                    onClick: () {
                      Navigator.pop(context);
                    },
                    color: Colors.transparent,
                    isMarginRequired: false,
                    textColor: ColorResource.color616267,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Positioned(
        //   left: 16,
        //   right: 16,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.transparent,
        //     radius: 16,
        //     child: ClipRRect(
        //         borderRadius: BorderRadius.all(Radius.circular(16)),
        //         child: Icon(CupertinoIcons.home)),
        //   ),
        // ),
      ],
    );
  }

  // Widget otpTextField() {
  //   return PinCodeTextField(
  //     appContext: context,
  //     length: 6,
  //     obscureText: false,
  //     animationType: AnimationType.fade,
  //     pinTheme: PinTheme(
  //       shape: PinCodeFieldShape.box,
  //       borderRadius: BorderRadius.circular(5),
  //       fieldHeight: 50,
  //       fieldWidth: 40,
  //       activeFillColor: Colors.white,
  //     ),
  //     animationDuration: Duration(milliseconds: 300),
  //     backgroundColor: Colors.blue.shade50,
  //     enableActiveFill: true,
  //     // errorAnimationController: errorController,
  //     // controller: textEditingController,
  //     onCompleted: (v) {
  //       print("Completed");
  //     },
  //     onChanged: (value) {
  //       print(value);
  //       setState(() {
  //         // currentText = value;
  //       });
  //     },
  //     beforeTextPaste: (text) {
  //       print("Allowing to paste $text");
  //       //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
  //       //but you can show anything you want here, like your pop up saying wrong paste format or etc
  //       return true;
  //     },
  //   );
  // }
}
