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

class _CardDetailScreenState extends State<CardDetailScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController cardHolderTextController = TextEditingController();
  TextEditingController cardNumberTextController = TextEditingController();
  TextEditingController expiryTextController = TextEditingController();
  TextEditingController securityCodeTextController = TextEditingController();
  bool isSecurityCodeHidden = true;

  String cardNumber = "6666989045907890";
  String securityCode = "456";

  String cardholderName;

  Image cardBackGroundImage;
  Image cardTypeImage;
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    cardHolderTextController.text = "Udit Saxena";
    cardNumberTextController.text = cardNumber;
    expiryTextController.text = "08/22";
    if (isSecurityCodeHidden) {
      securityCodeTextController.text = "***";
    } else {
      securityCodeTextController.text = securityCode;
    }
    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
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

    var wavesImage =
        new AssetImage('assets/images/Waves.png', package: 'm2pcarddetails');

    cardNumberTextController.text = getCardNumber();

    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 50, right: 20),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: CustomText(
                      "Virtual Card",
                      fontSize: 16,
                      color: ColorResource.color1515151,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 19.5,
                    height: 19.5,
                    child: Image(image: cancelImage, fit: BoxFit.cover),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  CustomText(
                    "Close",
                    fontSize: 13,
                    color: ColorResource.color1515151.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      child: Image(
                        image: cardBgImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Image(
                        image: wavesImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30.0, left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CustomText(
                                widget.tenatname,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              Spacer(),
                              Container(
                                width: 44,
                                height: 28,
                                child: Image(image: tenetBgImage),
                              )
                              // Expanded(
                              //   child: CustomText(
                              //     "Ganesh",
                              //     fontSize: 15,
                              //     color: Colors.white,
                              //     fontWeight: FontWeight.w300,
                              //     textAlign: TextAlign.end,
                              //   ),
                              // )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0),
                            child: CustomText(
                              getCardNumber(isTopPositionCardNumber: true),
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    "Valid Thru ",
                                    color: Colors.white,
                                    fontSize: 9,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: CustomText(
                                      expiryTextController.text,
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 50.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      "CVV",
                                      color: Colors.white,
                                      fontSize: 9,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: CustomText(
                                        securityCodeTextController.text,
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isSecurityCodeHidden =
                                        !isSecurityCodeHidden;
                                    if (isSecurityCodeHidden) {
                                      securityCodeTextController.text = "***";
                                    } else {
                                      securityCodeTextController.text =
                                          securityCode;
                                    }
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.all(10),
                                  child: CustomText(
                                    isSecurityCodeHidden
                                        ? "View CVV"
                                        : "Hide CVV",
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
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
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildTabBar(),
          ))
          // Container(
          //   padding: const EdgeInsets.all(20),
          //   decoration: BoxDecoration(
          //       color: Colors.white, borderRadius: BorderRadius.circular(15)),
          //   margin: const EdgeInsets.symmetric(horizontal: 10),
          //   child: Column(
          //     children: [
          //       CustomTextField(
          //         "Card Holder",
          //         "Card Holder",
          //         cardHolderTextController,
          //         borderColor: Colors.transparent,
          //         titleColor: ColorResource.color1515151.withOpacity(0.4),
          //         isReadOnly: true,
          //         isCopyEnabled: true,
          //         isEnable: false,
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.symmetric(vertical: 10.0),
          //         child: CustomTextField(
          //           "Card Number",
          //           "Card Number",
          //           cardNumberTextController,
          //           borderColor: Colors.transparent,
          //           titleColor: ColorResource.color1515151.withOpacity(0.4),
          //           isReadOnly: true,
          //           isCopyEnabled: true,
          //           isEnable: false,
          //         ),
          //       ),
          //       CustomTextField(
          //         "Expiry MM/YY",
          //         "MM/YY",
          //         expiryTextController,
          //         borderColor: Colors.transparent,
          //         titleColor: ColorResource.color1515151.withOpacity(0.4),
          //         isReadOnly: true,
          //         isEnable: false,
          //       )
          //     ],
          //   ),
          // ),
          // Container(
          //   padding: const EdgeInsets.all(20),
          //   decoration: BoxDecoration(
          //       color: Colors.white, borderRadius: BorderRadius.circular(15)),
          //   margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          //   child: SecurityCodeTextField(
          //       securityCodeTextController, isSecurityCodeHidden, () {
          //     setState(() {
          //       isSecurityCodeHidden = !isSecurityCodeHidden;
          //     });
          //   }),
          // )
        ],
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

  Widget _buildTabBar() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // the tab bar with two items

          TabBar(
            indicatorColor: ColorResource.color4D7DFF,
            indicatorWeight: 3,
            controller: _tabController,
            tabs: [
              Tab(
                child: CustomText(
                  "Manage Card",
                  fontSize: 14,
                  color: _tabController.index == 0
                      ? ColorResource.color4D7DFF
                      : ColorResource.color1515151.withOpacity(0.5),
                ),
                // icon: Icon(Icons.directions_bike),
              ),
              Tab(
                child: CustomText(
                  "Transaction Limit",
                  fontSize: 14,
                  color: _tabController.index == 1
                      ? ColorResource.color4D7DFF
                      : ColorResource.color1515151.withOpacity(0.5),
                ),
                // icon: Icon(Icons.directions_bike),
              ),
            ],
          ),

          // create widgets for each tab bar here
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // first tab bar view widget
                Container(
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      'Bike',
                    ),
                  ),
                ),

                // second tab bar viiew widget
                Container(
                  color: Colors.pink,
                  child: Center(
                    child: Text(
                      'Car',
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
