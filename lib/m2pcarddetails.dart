library m2pcarddetails;

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2pcarddetails/home_screen/bloc/home_bloc.dart';
import 'package:m2pcarddetails/home_screen/bloc/home_event.dart';
import 'package:m2pcarddetails/utils/apputils.dart';
import 'package:m2pcarddetails/utils/color_resource.dart';
import 'package:m2pcarddetails/utils/image_resource.dart';
import 'package:m2pcarddetails/widget/custom_dialog.dart';
import 'package:m2pcarddetails/widget/custom_switch.dart';
import 'package:m2pcarddetails/widget/custom_text.dart';
import 'package:m2pcarddetails/widget/enter_verificationcode_dialog.dart';
import 'package:m2pcarddetails/widget/plain_textfield.dart';
import 'package:m2pcarddetails/widget/primary_button.dart';

import 'home_screen/bloc/home_state.dart';

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
  bool isSecurityCodeHidden = true;

  String cardNumber = "6666989045907890";
  String expiryDate = "08/22";
  String securityCode = "456";

  String cardholderName;

  Image cardBackGroundImage;
  Image cardTypeImage;
  TabController _tabController;

  Timer _timer;
  int pendingSeconds = 180;

  bool setpinVisibility = false;
  bool blockCardVisibility = false;

  HomeBloc bloc;

  @override
  void initState() {
    bloc = HomeBloc()..add(HomeInitialEvent());
    if (isSecurityCodeHidden) {
      bloc.securityCodeTextController.text = "***";
    } else {
      bloc.securityCodeTextController.text = securityCode;
    }

    _tabController = new TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    startTimer();

    super.initState();
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (pendingSeconds == 0) {
          setState(() {
            timer.cancel();
          });
          Navigator.pop(context);
        } else {
          setState(() {
            pendingSeconds--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: bloc,
      listener: (BuildContext context, HomeState state) {
        if (state is HomeConformOtpAlertState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return EnterVerificationCodeDialogBox((text) {
                  bloc.add(HomeCustomDialogEvent());
                });
              });
        }

        if (state is HomeTemperaryBlockOtpVerificationState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return EnterVerificationCodeDialogBox((text) {
                  bloc.add(HomeTemperaryBlockCustomDialogEvent());
                });
              });
        }

        if (state is HomePeramanantBlockOtpVerificationState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return EnterVerificationCodeDialogBox((text) {
                  bloc.add(HomePermanantBlockCustomDialogEvent());
                });
              });
        }

        if (state is HomeCustomDialogState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    Container(
                      width: 56,
                      height: 56,
                      child: Image(
                        image: ImageResource.tickImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    "Your PIN has been updated Successfully",
                    "Continue", () {
                  Navigator.pop(context);
                });
              });
        }

        if (state is HomeTemperaryBlockCustomDialogState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    Container(
                      width: 56,
                      height: 56,
                      child: Image(
                        image: ImageResource.tickImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    "Your card has been Blocked Temporarily ",
                    "Continue", () {
                  setState(() {
                    bloc.blockTemporary = true;
                  });

                  Navigator.pop(context);
                });
              });
        }

        if (state is HomePermanantBlockCustomDialogState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                    Container(
                      width: 56,
                      height: 56,
                      child: Image(
                        image: ImageResource.tickImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                    "Your card has been Permanently Blocked ",
                    "Continue", () {
                  setState(() {
                    bloc.blockPermanant = true;
                  });
                  Navigator.pop(context);
                });
              });
        }

        if (state is HomePeramanantBlockAlertState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                  Container(
                    width: 75,
                    height: 75,
                    child: Image(
                      image: ImageResource.blockCardConformation,
                      fit: BoxFit.cover,
                    ),
                  ),
                  "Do you want to continue?",
                  "Yes, Block Card",
                  () {
                    Navigator.pop(context);
                    bloc.add(HomePermanantBlockOtpVerificationEvent());
                  },
                  isCancelButtonRequired: true,
                );
              });
        }

        if (state is HomeTemperaryBlockAlertState) {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return CustomDialog(
                  Container(
                    width: 75,
                    height: 75,
                    child: Image(
                      image: ImageResource.blockCardConformation,
                      fit: BoxFit.cover,
                    ),
                  ),
                  "Do you want to continue?",
                  "Block Temporarily",
                  () {
                    Navigator.pop(context);
                    bloc.add(HomeTemperaryBlockOtpVerificationEvent());
                  },
                  isCancelButtonRequired: true,
                );
              });
        }

        if (state is HomeErrorState) {
          AppUtils.showErrorToast(state.error);
        }
      },
      child: BlocBuilder(
          cubit: bloc,
          builder: (BuildContext context, HomeState state) {
            return Scaffold(
              backgroundColor: Color.fromRGBO(250, 250, 250, 1),
              body: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 22.0,
                          ),
                          child: CustomText(
                            "Virtual Card",
                            fontSize: 16,
                            color: ColorResource.color1515151,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 19.5,
                                  height: 19.5,
                                  child: Image(
                                      image: ImageResource.cancelImage,
                                      fit: BoxFit.cover),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  "Close",
                                  fontSize: 13,
                                  color: ColorResource.color1515151
                                      .withOpacity(0.5),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                                height: 200,
                                child: Image(
                                  image: ImageResource.cardBgImage,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                height: 200,
                                child: Image(
                                  image: ImageResource.wavesImage,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, left: 16, right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                          child: Image(
                                              image:
                                                  ImageResource.tenetBgImage),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 32,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 30.0),
                                      child: Row(
                                        children: [
                                          CustomText(
                                            getCardNumber(isSecurityCodeHidden),
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                          ),
                                          Spacer(),
                                          if (isSecurityCodeHidden)
                                            GestureDetector(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: cardNumber));
                                                AppUtils.hideKeyBoard(context);
                                                AppUtils.showToast(
                                                    "Cardnumber copied");
                                              },
                                              child: Container(
                                                width: 32,
                                                height: 32,
                                                child: Image(
                                                  image: ImageResource.copy,
                                                  color: Colors.white,
                                                  // fit: BoxFit.contain,
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              "Valid Thru ",
                                              color: Colors.white,
                                              fontSize: 9,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 6.0),
                                              child: CustomText(
                                                expiryDate,
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 50.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                "CVV",
                                                color: Colors.white,
                                                fontSize: 9,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6.0),
                                                child: CustomText(
                                                  bloc.securityCodeTextController
                                                      .text,
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
                                                bloc.securityCodeTextController
                                                    .text = "***";
                                              } else {
                                                bloc.securityCodeTextController
                                                    .text = securityCode;
                                              }
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                color: Colors.transparent,
                                                borderRadius:
                                                    BorderRadius.circular(20)),
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
                                    ),
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
                    )),
                    Container(
                      width: double.infinity,
                      height: 28,
                      color: Colors.white,
                      child: Center(
                        child: CustomText(
                          "The Screen will automatically close in $pendingSeconds sec",
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                          color: ColorResource.colorEB001C,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  String getCardNumber(bool isSecurityCodeHidden) {
    var buffer = new StringBuffer();
    for (int i = 0; i < cardNumber.length; i++) {
      if (isSecurityCodeHidden) {
        buffer.write(cardNumber[i]);
      } else {
        if (i == 0 ||
            i == 1 ||
            i == 2 ||
            i == 3 ||
            i == cardNumber.length - 1 ||
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
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 9.0, vertical: 18),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    child: Image(
                                        image: ImageResource.setpinImage,
                                        fit: BoxFit.cover),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: CustomText(
                                      "Set PIN",
                                      fontSize: 14,
                                      color: ColorResource.color1515151
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        setpinVisibility = !setpinVisibility;
                                      });
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      child: Image(
                                          image: setpinVisibility
                                              ? ImageResource.upArrowImage
                                              : ImageResource.downArrowImage,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: setpinVisibility,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: [
                                      PlainTextField(
                                          "DOB", bloc.dobTextController),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0),
                                        child: PlainTextField(
                                          "Enter PIN",
                                          bloc.enterPinTextController,
                                          keyBoardType:
                                              TextInputType.numberWithOptions(
                                                  signed: true),
                                        ),
                                      ),
                                      PlainTextField(
                                        "Confirm PIN",
                                        bloc.conformPinTextController,
                                        keyBoardType:
                                            TextInputType.numberWithOptions(
                                                signed: true),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 16.0),
                                        child: PrimaryButton(
                                          "Set",
                                          isShadowrequired: false,
                                          onClick: () {
                                            bloc.add(
                                                HomeEnterVerificationCodeAlertEvent());
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    child: Image(
                                        image: ImageResource.blockCardImage,
                                        fit: BoxFit.cover),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 12.0),
                                    child: CustomText(
                                      "Block your Card",
                                      fontSize: 14,
                                      color: ColorResource.color1515151
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        blockCardVisibility =
                                            !blockCardVisibility;
                                      });
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      child: Image(
                                          image: blockCardVisibility
                                              ? ImageResource.upArrowImage
                                              : ImageResource.downArrowImage,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              ),
                              Visibility(
                                visible: blockCardVisibility,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 12,
                                      ),
                                      CustomSwitch(
                                          "Block Temporarily",
                                          "Prevents transaction on this Card",
                                          bloc.blockTemporary, (value) {
                                        if (value) {
                                          bloc.add(
                                              HomeTemperaryBlockAlertEvent());
                                        } else {
                                          setState(() {
                                            bloc.blockTemporary = false;
                                          });
                                        }
                                      }),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      CustomSwitch(
                                          "Block Permanent",
                                          "Once blocked, card can’t be used again",
                                          bloc.blockPermanant, (value) {
                                        if (value) {
                                          bloc.add(
                                              HomePremanantBlockAlertEvent());
                                        } else {
                                          setState(() {
                                            bloc.blockPermanant = false;
                                          });
                                        }
                                      })
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                child: Image(
                                    image: ImageResource.cardPreferenceImage,
                                    fit: BoxFit.cover),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: CustomText(
                                  "Card Preference",
                                  fontSize: 14,
                                  color: ColorResource.color1515151
                                      .withOpacity(0.8),
                                ),
                              ),
                              Spacer(),
                              Container(
                                width: 24,
                                height: 24,
                                child: Image(
                                    image: ImageResource.downArrowImage,
                                    fit: BoxFit.cover),
                              ),
                            ],
                          ),
                        )
                      ],
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

  @override
  Future<void> dispose() {
    _timer.cancel();
    super.dispose();
  }
}
