import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetch_chat_barberlebel_bloc/fetch_chat_barberlebel_bloc.dart';
import 'package:user_panel/app/presentation/screens/pages/chat/chat_window_screen.dart';
import 'package:user_panel/app/presentation/widget/chat_widget/chat_tile_widget/chat_tile_custom_card_widget.dart';
import 'package:user_panel/core/common/custom_lottie_widget.dart';
import 'package:user_panel/core/utils/constant/constant.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/image/app_images.dart';

BlocBuilder<FetchChatBarberlebelBloc, FetchChatBarberlebelState>
    chatTailBuilderWidget(
        BuildContext context, double screenWidth, double screenHeight) {
  return BlocBuilder<FetchChatBarberlebelBloc, FetchChatBarberlebelState>(
    builder: (context, state) {
     if (state is FetchChatBarberlebelEmpty) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
                child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppPalette.buttonClr.withAlpha((0.3 * 255).round()),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '⚿ Looks like your chatBox is empty! Start a conversation with a barber — your chats will show up here.All chats are private and secure.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppPalette.blackClr),
              ),
            )),
            LottieFilesCommon.load(
                assetPath: LottieImages.emptyData,
                width: screenWidth * 0.3,
                height: screenHeight * 0.3),
           Text("Oops! There's nothing here yet."),
            Text('No conversation added yet — time to take action!'),
          ],
        );
      }
      else if (state is FetchChatBarberlebelSuccess) {
        final chatList = state.barbers;

        return RefreshIndicator(
          color: AppPalette.buttonClr,
          backgroundColor: AppPalette.whiteClr,
          onRefresh: () async {
            context
                .read<FetchChatBarberlebelBloc>()
                .add(FetchChatLebelBarberRequst());
          },
          child: ListView.builder(
            itemCount: chatList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final barber = chatList[index];
              return InkWell(
                onTap: () async {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndividualChatScreen(
                        barberId: barber.uid,
                        userId: state.userId,
                      ),
                    ),
                  );
                },
                child: ChatTile(
                  imageUrl: barber.image ?? '',
                  shopName: barber.ventureName,
                  barberId: barber.uid,
                ),
              );
            },
          ),
        );
      }
      else if (state is FetchChatBarberlebelFailure){

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstantWidgets.hight50(context),
            Icon(
              Icons.cloud_off_outlined,
              color: AppPalette.blackClr,
              size: 50,
            ),
            Text("Oop's Unable to complete the request."),
            Text('Please try again later.'),
            IconButton(onPressed: () {
               context.read<FetchChatBarberlebelBloc>().add(FetchChatLebelBarberRequst());
            }, icon: Icon(Icons.refresh_rounded))
          ],
        ),
      );
      }
      return Shimmer.fromColors(
          baseColor: Colors.grey[300] ?? AppPalette.greyClr,
          highlightColor: AppPalette.whiteClr,
          child: ListView.builder(
            itemCount: 15,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return ChatTile(
                imageUrl: '',
                shopName: 'Venture Name Loading...',
                barberId: '',
              );
            },
          ),
        );
    },
  );
}
