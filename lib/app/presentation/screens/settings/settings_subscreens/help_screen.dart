import 'package:flutter/material.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import '../../../widget/settings_widget/help_widget/help_body_widget.dart' show DashChatWidget;

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _controller = TextEditingController();
  final bool isUser = true;
  final bool isGemini = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenHeight = constraints.maxHeight;
        final double screenWidth = constraints.maxWidth;
        return ColoredBox(
          color: AppPalette.hintClr,
          child: SafeArea(
            child: Scaffold(
                appBar: CustomAppBar(),
                body: DashChatWidget(
                  controller: _controller,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
                ),
          ),
        );
      },
    );
  }
}



