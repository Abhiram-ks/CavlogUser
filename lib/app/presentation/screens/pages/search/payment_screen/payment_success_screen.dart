import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_panel/app/presentation/widget/search_widget/payment_success_widget/payment_success_topsection.dart';
import 'package:user_panel/core/themes/colors.dart';
import 'package:user_panel/core/utils/constant/constant.dart';
import 'package:confetti/confetti.dart';

import '../../../../../../core/routes/routes.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final String totalAmount;
  final String barberUid;
  final bool isWallet;
  final List<Map<String, dynamic>> selectedServices;

  const PaymentSuccessScreen(
      {super.key,
      required this.barberUid,
      required this.selectedServices,
      required this.totalAmount,
      required this.isWallet});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double screenHeight = constraints.maxHeight;
      double screenWidth = constraints.maxWidth;

      // ignore: deprecated_member_use
      return WillPopScope(
        onWillPop: () async {
          Navigator.popUntil(context, (route) => route.settings.name == AppRoutes.booking);
          return false;
        },
        child: ColoredBox(
          color: AppPalette.greenClr,
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppPalette.scafoldClr,
                elevation: 0,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: AppPalette.blackClr),
                  onPressed: () {
                    Navigator.popUntil( context,(route) => route.settings.name == AppRoutes.booking,
                    );
                  },
                ),
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Stack(
                  children: [
                    ColoredBox(
                      color: AppPalette.scafoldClr ?? AppPalette.whiteClr,
                      child: SafeArea(
                        child: Column(
                          children: [
                            ConstantWidgets.hight10(context),
                            PaymentSuccessTopsection(
                              screenHeight: screenHeight,
                              screenWidth: screenWidth,
                              label: widget.totalAmount,
                              isWallet: widget.isWallet,
                              barberUid: widget.barberUid,
                              selectedServices: widget.selectedServices,
                            ),
                            ConstantWidgets.hight30(context),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * .03),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: TextStyle(color: AppPalette.greyClr),
                                    children: [
                                      const TextSpan(
                                          text:'Your payment has been securely processed. For further information, please contact our team at '),
                                      TextSpan(
                                        text: 'cavlogenoia@gmail.com',
                                        style: TextStyle(color: AppPalette.blueClr),
                                        recognizer: TapGestureRecognizer()..onTap = () {
                                            launchUrl(Uri.parse('mailto:cavlogenoia@gmail.com'));
                                          },
                                      ), const TextSpan(
                                        text: '. If you experience any issues, please report them to our support team. You payment will be securely done. for further information connect our team cavlogenoia@gmail.com. You facing any further issue for the side please report on our team',
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: ConfettiWidget(
                        confettiController: _confettiController,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        emissionFrequency: 0.03,
                        maxBlastForce: 20,
                        minBlastForce: 5,
                        numberOfParticles: 80,
                        gravity: 0.5,
                      ),
                    ),
                    ConstantWidgets.hight50(context),
                    ConstantWidgets.hight50(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
