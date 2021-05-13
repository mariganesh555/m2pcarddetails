library m2pcarddetails;

import 'package:flutter/material.dart';
import 'package:m2pcarddetails/utils/color_resource.dart';
import 'package:m2pcarddetails/widget/Custom_textfield.dart';
import 'package:m2pcarddetails/widget/Security_code_textfield.dart';
import 'package:m2pcarddetails/widget/custom_text.dart';

class CardDetailScreen extends StatefulWidget {
  String tenatname;
  String accessToken;
  String kitNumber;
  String entityId;
  String dob;

  CardDetailScreen(this.tenatname, this.accessToken, this.kitNumber,
      this.entityId, this.dob);

  @override
  _CardDetailScreenState createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  TextEditingController cardHolderTextController = TextEditingController();
  TextEditingController cardNumberTextController = TextEditingController();
  TextEditingController expiryTextController = TextEditingController();
  TextEditingController securityCodeTextController = TextEditingController();
  bool isSecurityCodeHidden = true;

  String cardNumber = "6666989045907890";

  String cardholderName;

  Image cardBackGroundImage;
  Image cardTypeImage;

  @override
  void initState() {
    // TODO: implement initState
    cardHolderTextController.text = "Udit Saxena";
    cardNumberTextController.text = cardNumber;
    expiryTextController.text = "08/22";
    securityCodeTextController.text = "456";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cancelImage =
        new AssetImage('assets/images/cancel.png', package: 'm2pcarddetails');

    var cardBgImage =
        new AssetImage('assets/images/cardBg.png', package: 'm2pcarddetails');

    var tenetBgImage =
        new AssetImage('assets/images/tenetBg.png', package: 'm2pcarddetails');

    cardNumberTextController.text = getCardNumber();

    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 50, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 19.5,
                      height: 19.5,
                      child: Image(image: cancelImage, fit: BoxFit.cover),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    CustomText(
                      "Cancel",
                      fontSize: 13,
                      color: ColorResource.color1515151.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Image(image: cardBgImage, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  widget.tenatname,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                                Spacer(),
                                Expanded(
                                  child: CustomText(
                                    "Ganesh",
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    textAlign: TextAlign.end,
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 30.0),
                              child: CustomText(
                                getCardNumber(isTopPositionCardNumber: true),
                                fontSize: 15,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            ),
                            Row(
                              children: [
                                Spacer(),
                                Container(
                                  width: 44,
                                  height: 28,
                                  child: Image(image: tenetBgImage),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  CustomTextField(
                    "Card Holder",
                    "Card Holder",
                    cardHolderTextController,
                    borderColor: Colors.transparent,
                    titleColor: ColorResource.color1515151.withOpacity(0.4),
                    isReadOnly: true,
                    isCopyEnabled: true,
                    isEnable: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: CustomTextField(
                      "Card Number",
                      "Card Number",
                      cardNumberTextController,
                      borderColor: Colors.transparent,
                      titleColor: ColorResource.color1515151.withOpacity(0.4),
                      isReadOnly: true,
                      isCopyEnabled: true,
                      isEnable: false,
                    ),
                  ),
                  CustomTextField(
                    "Expiry MM/YY",
                    "MM/YY",
                    expiryTextController,
                    borderColor: Colors.transparent,
                    titleColor: ColorResource.color1515151.withOpacity(0.4),
                    isReadOnly: true,
                    isEnable: false,
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: SecurityCodeTextField(
                  securityCodeTextController, isSecurityCodeHidden, () {
                setState(() {
                  isSecurityCodeHidden = !isSecurityCodeHidden;
                });
              }),
            )
          ],
        ),
      ),
    );
  }

  String getCardNumber({bool isTopPositionCardNumber = false}) {
    var buffer = new StringBuffer();
    for (int i = 0; i < cardNumber.length; i++) {
      if (isSecurityCodeHidden && !isTopPositionCardNumber) {
        buffer.write(cardNumber[i]);
      } else {
        if (i == cardNumber.length - 1 ||
            i == cardNumber.length - 2 ||
            i == cardNumber.length - 3 ||
            i == cardNumber.length - 4) {
          buffer.write(cardNumber[i]);
        } else {
          buffer.write("X");
        }
      }

      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != cardNumber.length) {
        buffer.write('  '); // Add double spaces.
      }
    }
    return buffer.toString();
  }
}
