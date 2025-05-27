import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_panel/app/data/repositories/image_picker_repo.dart';
import 'package:user_panel/app/domain/usecases/image_picker_usecase.dart';
import 'package:user_panel/app/presentation/provider/bloc/image_picker/imge_picker_bloc.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ImagePickerBloc(PickImageUseCase(ImagePickerRepositoryImpl(ImagePicker())))),
      ],
      child: LayoutBuilder(
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
      ),
    );
  }
}



