import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/data/repositories/fetch_barber_repo.dart';
import 'package:user_panel/app/data/repositories/fetch_message_repo.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetch_chat_barberlebel_bloc/fetch_chat_barberlebel_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/buttom_nav_cubit/buttom_nav_cubit.dart'
    show BottomNavItem, ButtomNavCubit;
import 'package:user_panel/app/presentation/widget/chat_widget/chat_tile_widget/chat_tile_body_widget.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import '../../../../../core/themes/colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchChatBarberlebelBloc(
          MessageRepositoryImpl(FetchBarberRepositoryImpl())),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.blackClr,
            child: Scaffold(
              appBar: CustomAppBar(
                isTitle: true,
                backgroundColor: AppPalette.blackClr,
                title: 'Chat ',
                titleColor: AppPalette.whiteClr,
              ),
              body: ChatScreenBodyWidget(screenHeight: screenHeight, screenWidth: screenWidth),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  context.read<ButtomNavCubit>().selectItem(BottomNavItem.search);
                },
                backgroundColor: AppPalette.orengeClr,
                child: const Icon(
                  CupertinoIcons.chat_bubble,
                  color: AppPalette.whiteClr,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

