import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/data/repositories/fetch_barber_repo.dart';
import 'package:user_panel/app/data/repositories/fetch_message_repo.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetch_chat_barberlebel_bloc/fetch_chat_barberlebel_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/buttom_nav_cubit/buttom_nav_cubit.dart'
    show BottomNavItem, ButtomNavCubit;
import 'package:user_panel/app/presentation/screens/pages/chat/individual_chat_screen.dart';
import 'package:user_panel/app/presentation/screens/pages/search/search_screen.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:user_panel/core/common/custom_lottie_widget.dart';
import 'package:user_panel/core/utils/image/app_images.dart';

import '../../../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../../../core/common/custom_formfield_widget.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/validation/input_validation.dart';
import '../../../widget/chat_widget/chat_tile_widget/chat_tile_custom_card_widget.dart';

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
              body: ChatScreenBodyWidget(
                  screenHeight: screenHeight, screenWidth: screenWidth),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  context
                      .read<ButtomNavCubit>()
                      .selectItem(BottomNavItem.search);
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
  @override
  void initState() {
    super.initState();
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
              controller: GlobalSearchController.searchController,
              validate: ValidatorHelper.serching,
              borderClr: AppPalette.whiteClr,
              fillClr: AppPalette.whiteClr,
              suffixIconData: Icons.clear,
              suffixIconColor: AppPalette.greyClr,
              suffixIconAction: () {
                GlobalSearchController.searchController.clear();
              },
            ),
            const SizedBox(height: 16),
            BlocBuilder<FetchChatBarberlebelBloc, FetchChatBarberlebelState>(
              builder: (context, state) {
                if (state is FetchChatBarberlebelLoading) {
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
                } else if (state is FetchChatBarberlebelEmpty ||
                    state is FetchChatBarberlebelFailure) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppPalette.buttonClr
                              .withAlpha((0.3 * 255).round()),
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
                          width: widget.screenWidth * 0.3,
                          height: widget.screenHeight * 0.3),
                    ],
                  );
                } else if (state is FetchChatBarberlebelSuccess) {
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
                            final credentials =
                                await SecureStorageService.getUserCredentials();
                            final String? userId = credentials['userId'];
                            if (userId == null) return;

                            if (!mounted) return;

                            Navigator.push(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) => IndividualChatScreen(
                                  barberId: barber.uid,
                                  userId: userId,
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
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

