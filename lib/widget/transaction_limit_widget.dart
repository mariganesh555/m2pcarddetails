import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m2pcarddetails/utils/apputils.dart';
import 'package:m2pcarddetails/utils/color_resource.dart';
import 'package:m2pcarddetails/utils/image_resource.dart';
import 'package:m2pcarddetails/utils/validator.dart';
import 'package:m2pcarddetails/widget/plain_textfield.dart';
import 'package:m2pcarddetails/widget/primary_button.dart';

import 'custom_text.dart';

class TransactionLimitWidget extends StatefulWidget {
  String title;
  bool switchValue;
  Function onValueChange;
  Function onSaveTapped;
  Widget image;
  TextEditingController controller;

  TransactionLimitWidget(
    this.title,
    this.switchValue,
    this.onValueChange,
    this.image,
    this.controller,
    this.onSaveTapped,
  );
  @override
  _TransactionLimitWidgetState createState() => _TransactionLimitWidgetState();
}

class _TransactionLimitWidgetState extends State<TransactionLimitWidget>
    with TickerProviderStateMixin {
  bool showTextField = true;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              widget.image,
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: CustomText(
                  widget.title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ColorResource.color1515151.withOpacity(0.8),
                ),
              ),
              Spacer(),
              CupertinoSwitch(
                  value: widget.switchValue,
                  onChanged: (value) {
                    widget.onValueChange(value);
                  })
            ],
          ),
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
            child: Visibility(
              visible: widget.switchValue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: CustomText(
                      "*Max.Per day Limit  ",
                      fontSize: 10,
                      color: ColorResource.color1515151.withOpacity(0.5),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: showTextField
                              ? PlainTextField(
                                  "Set New Limit",
                                  widget.controller,
                                  keyBoardType: TextInputType.numberWithOptions(
                                      decimal: true, signed: true),
                                )
                              : CustomText("₹" + widget.controller.text)),
                      if (showTextField)
                        Container(
                          width: 92,
                          height: 40,
                          margin: const EdgeInsets.only(left: 12),
                          child: PrimaryButton(
                            "Save",
                            color: ColorResource.colorEBF0FF,
                            textColor: ColorResource.color4C7DFF,
                            isMarginRequired: false,
                            onClick: () {
                              final limitStatus = Validator.validate(
                                  widget.controller.text.trim(),
                                  rules: ['required']);
                              if (!limitStatus.status) {
                                AppUtils.showErrorToast("Limit can't be empty");
                              } else {
                                setState(() {
                                  showTextField = false;
                                });
                              }
                            },
                          ),
                        ),
                      if (!showTextField)
                        Container(
                          width: 92,
                          height: 40,
                          margin: const EdgeInsets.only(left: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                child: Image(
                                  image: ImageResource.edit,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Expanded(
                                child: PrimaryButton(
                                  "Edit Limit",
                                  color: Colors.white,
                                  textColor: ColorResource.color4C7DFF,
                                  isMarginRequired: false,
                                  onClick: () {
                                    final limitStatus = Validator.validate(
                                        widget.controller.text.trim(),
                                        rules: ['required']);
                                    if (!limitStatus.status) {
                                      AppUtils.showErrorToast(
                                          "Limit can't be empty");
                                    } else {
                                      setState(() {
                                        showTextField = true;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
