import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:m2pcarddetails/utils/apputils.dart';
import 'package:m2pcarddetails/utils/color_resource.dart';
import 'package:m2pcarddetails/utils/image_resource.dart';
import 'package:m2pcarddetails/utils/string_resource.dart';
import 'package:m2pcarddetails/widget/primary_button.dart';

import 'custom_text.dart';

class CustomDialog extends StatefulWidget {
  Function onProceedTapped;
  bool isCancelButtonRequired;
  AssetImage image;
  String text;
  String buttonText;

  CustomDialog(this.image, this.text, this.buttonText, this.onProceedTapped,
      {this.isCancelButtonRequired = false});

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
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
                padding: const EdgeInsets.only(top: 36.0),
                child: Center(
                  child: Container(
                      width: 56,
                      height: 56,
                      child: Image(
                          image: widget.image, fit: BoxFit.cover)),
                ),
              ),
              const SizedBox(
                height: 23,
              ),
              Text(
                widget.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorResource.color1c1d22),
              ),
              const SizedBox(
                height: 38,
              ),
              Center(
                child: PrimaryButton(
                  widget.buttonText,
                  color: ColorResource.colorEBF0FF,
                  textColor: ColorResource.color4C7DFF,
                  isMarginRequired: false,
                  onClick: () {
                    widget.onProceedTapped();
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (widget.isCancelButtonRequired)
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
}
