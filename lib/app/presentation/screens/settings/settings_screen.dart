import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_panel/app/presentation/provider/bloc/logout_bloc/logout_bloc.dart';
import 'package:user_panel/app/presentation/screens/settings/settings_subscreens/help_screen.dart';
import 'package:user_panel/app/presentation/widget/settings_widget/delete_account/delete_account_screen.dart';
import 'package:user_panel/app/presentation/widget/settings_widget/logout_widget/logout_statehandle_widget.dart';
import 'package:user_panel/core/routes/routes.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constant/constant.dart';
import '../../../domain/usecases/fedback_usecase.dart';
import '../../widget/profile_widget/profile_settings_widget.dart';

class SettingsScreen extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  const SettingsScreen({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
      child: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstantWidgets.hight20(context),
            Text('Settings & privacy',
                style: TextStyle(
                  color: AppPalette.blackClr,
                )),
            Text('Your account',
                style: TextStyle(
                  color: AppPalette.greyClr,
                )),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.profile_circled,
                title: 'Profile details',
                onTap: () => Navigator.pushNamed(context, AppRoutes.account,
                    arguments: false)),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.square_pencil,
                title: 'Edit Profile',
                onTap: () => Navigator.pushNamed(context, AppRoutes.account,
                    arguments: true)),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.lock,
                title: 'Change Password',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.resetPassword,
                      arguments: false);
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: Icons.book_online,
                title: 'My Booking',
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.myBooking);
                }),
            Divider(
              color: AppPalette.hintClr,
            ),
            ConstantWidgets.hight10(context),
            Text('Community support',
                style: TextStyle(
                  color: AppPalette.greyClr,
                )),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.question_circle,
                title: 'Help',
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (_) =>  HelpScreen(),
                      
                    ),
                  );
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.bubble_left,
                title: 'Feedback',
                onTap: () {
                 sendFeedback();
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.star,
                title: 'Rate app',
                onTap: () {}),
            Divider(
              color: AppPalette.hintClr,
            ),
            ConstantWidgets.hight10(context),
            Text('Legal policies',
                style: TextStyle(
                  color: AppPalette.greyClr,
                )),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.doc,
                title: 'Terms & Conditions',
                onTap: () {
                termsAndConditionsUrl();
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: CupertinoIcons.shield,
                title: 'Privacy Policy',
                onTap: () {
                   privacyPolicyUrl();
                }),
            settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: Icons.compare_arrows,
                title: 'Cookies Policy',
                onTap: () {
                  cookiesPolicyUrl();
                }),
                settingsWidget(
                context: context,
                screenHeight: screenHeight,
                icon: Icons.rotate_left_rounded,
                title: 'Service & Refund Policy',
                onTap: () {
                  refundPolicy();
                }),
            Divider(
              color: AppPalette.hintClr,
            ),
            ConstantWidgets.hight10(context),
            Text('Login',
                style: TextStyle(
                  color: AppPalette.greyClr,
                )),
            ConstantWidgets.hight20(context),
            BlocListener<LogoutBloc, LogoutState>(
              listener: (context, state) {
                handleLogOutState(context, state);
              },
              child: InkWell(
                onTap: () {
                  context.read<LogoutBloc>().add(LogoutRequestEvent());
                },
                splashColor: AppPalette.trasprentClr,
                child: Text(
                  'Log out',
                  style: TextStyle(color: AppPalette.logoutClr, fontSize: 17),
                ),
              ),
            ),
              ConstantWidgets.hight10(context),
            InkWell(
              onTap: () {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: Text('Delete Account?'),
                    content: Text(
                      'Are you sure you want to delete your account? This action is permanent and requires verification before proceeding to the next step.',
                    ),
                    actions: [
                      CupertinoDialogAction(
                        child: Text('Proceed ',
                            style: TextStyle(color: AppPalette.redClr)),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DeleteAccountScreen(),));
                        },
                      ),
                      CupertinoDialogAction(
                        isDestructiveAction: true,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: AppPalette.blackClr),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Text("Delete Account?",
                  style: TextStyle(
                    color: AppPalette.redClr,
                  )),
            ),
            ConstantWidgets.hight50(context)
          ],
        ),
      ),
    );
  }
}


Future<void> privacyPolicyUrl() async {
  final Uri termsUrl = Uri.parse('https://www.freeprivacypolicy.com/live/c8b15acc-bf43-4cd7-99e1-ab61baf302b6');
  if (await canLaunchUrl(termsUrl)) {
    await launchUrl(termsUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $termsUrl';
  }
}

Future<void> termsAndConditionsUrl() async {
  final Uri termsUrl = Uri.parse('https://www.freeprivacypolicy.com/live/72716f57-9a59-4148-988f-1f3028688650');
  if (await canLaunchUrl(termsUrl)) {
    await launchUrl(termsUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $termsUrl';
  }
}

Future<void> refundPolicy() async {
  final Uri termsUrl = Uri.parse('https://www.freeprivacypolicy.com/live/04cb3257-774f-4004-8946-0ed8ba6266f9');
  if (await canLaunchUrl(termsUrl)) {
    await launchUrl(termsUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $termsUrl';
  }
}



Future<void> cookiesPolicyUrl() async {
  final Uri termsUrl = Uri.parse('https://www.freeprivacypolicy.com/live/fb8cd1d2-f768-403e-905a-78ca19ef00bd');
  if (await canLaunchUrl(termsUrl)) {
    await launchUrl(termsUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $termsUrl';
  }
}

