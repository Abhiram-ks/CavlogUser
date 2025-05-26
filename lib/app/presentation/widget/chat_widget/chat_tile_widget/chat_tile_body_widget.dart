
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetch_chat_barberlebel_bloc/fetch_chat_barberlebel_bloc.dart';
import 'package:user_panel/app/presentation/widget/chat_widget/chat_tile_widget/chat_tile_blocbuilder_widget.dart';
import 'package:user_panel/core/common/custom_formfield_widget.dart';
import 'package:user_panel/core/utils/constant/constant.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/debouncer/debouncer.dart';
import '../../../../../core/validation/input_validation.dart' show ValidatorHelper;

class ChatScreenBodyWidget extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;

  const ChatScreenBodyWidget(
      {super.key, required this.screenWidth, required this.screenHeight});

  @override
  State<ChatScreenBodyWidget> createState() => _ChatScreenBodyWidgetState();
}

class _ChatScreenBodyWidgetState extends State<ChatScreenBodyWidget>
    with FormFieldMixin {
  late final Debouncer _debouncer;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(milliseconds: 50);
    context.read<FetchChatBarberlebelBloc>().add(FetchChatLebelBarberRequst());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * .04),
        child: Column(
          children: [
            buildTextFormField(
              label: '',
              hintText: 'Search shop...',
              prefixIcon: Icons.search,
              context: context,
              controller: _searchController,
              validate: ValidatorHelper.serching,
              borderClr: AppPalette.whiteClr,
              fillClr: AppPalette.whiteClr,
              suffixIconData: Icons.clear,
              suffixIconColor: AppPalette.greyClr,
              suffixIconAction: () {
                _searchController.clear();
                context.read<FetchChatBarberlebelBloc>().add(FetchChatLebelBarberRequst());
              },
              onChanged: (value) {
                _debouncer.run(() {
                  context.read<FetchChatBarberlebelBloc>().add(
                        FetchChatLebelBarberSearch(value),
                  );
                });
              },
            ),
            ConstantWidgets.hight10(context),
            chatTailBuilderWidget(context,widget.screenWidth, widget.screenHeight),
          ],
        ),
      ),
    );
  }

}
