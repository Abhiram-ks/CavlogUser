import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/data/datasources/send_comment_remote_datasource.dart';
import 'package:user_panel/app/data/models/post_with_barber_model.dart';
import 'package:user_panel/app/domain/usecases/data_listing_usecase.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_post_with_barber_bloc/fetch_post_with_barber_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/send_comment_bloc/send_comment_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/post_like_cubit/post_like_cubit.dart';
import 'package:user_panel/app/presentation/screens/pages/chat/individual_chat_screen.dart';
import 'package:user_panel/app/presentation/screens/pages/search/detail_screen/detail_screen.dart';
import 'package:user_panel/app/presentation/widget/post_widget/post_card_widget.dart';
import 'package:user_panel/auth/data/datasources/auth_local_datasource.dart'
    show SecureStorageService;
import 'package:user_panel/core/themes/colors.dart';
import 'package:user_panel/core/utils/constant/constant.dart';

import '../../../../auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';
import '../../../../core/common/custom_snackbar_widget.dart';
import '../../../../core/utils/image/app_images.dart';
import '../../provider/cubit/share_post_cubit/share_post_cubit.dart';
import '../chat_widget/chat_indivitual_widget/chat_sendmessage_textfiled.dart';

class PostScreenWidget extends StatefulWidget {
  const PostScreenWidget({
    super.key,
    required this.screenHeight,
    required this.heightFactor,
    required this.screenWidth,
  });

  final double screenHeight;
  final double heightFactor;
  final double screenWidth;

  @override
  State<PostScreenWidget> createState() => _PostScreenWidgetState();
}

class _PostScreenWidgetState extends State<PostScreenWidget> {
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchPostWithBarberBloc>().add(FetchPostWithBarberRequest());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPostWithBarberBloc, FetchPostWithBarberState>(
      builder: (context, state) {
        if (state is FetchPostWithBarberLoaded) {
          final List<PostWithBarberModel> model = state.model;
          return RefreshIndicator(
            color: AppPalette.buttonClr,
            backgroundColor: AppPalette.whiteClr,
            onRefresh: () async {
              context
                  .read<FetchPostWithBarberBloc>()
                  .add(FetchPostWithBarberRequest());
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: model.length,
              itemBuilder: (context, index) {
                final data = model[index];
                final formattedDate = formatDate(data.post.createdAt);
                final formattedStartTime = formatTimeRange(data.post.createdAt);

                return PostScreenMainWidget(
                  screenHeight: widget.screenHeight,
                  heightFactor: widget.heightFactor,
                  screenWidth: widget.screenWidth,
                  shopName: data.barber.ventureName,
                  description: data.post.description,
                  favoriteColor: data.post.likes.contains(state.userId)
                      ? AppPalette.redClr
                      : AppPalette.blackClr,
                  favoriteIcon: data.post.likes.contains(state.userId)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  likes: data.post.likes.length,
                  location: data.barber.address,
                  postUrl: data.post.imageUrl,
                  shopUrl: data.barber.image ?? AppImages.loginImageAbove,
                  chatOnTap: () async {
                    final credentials =
                        await SecureStorageService.getUserCredentials();
                    final String? userId = credentials['userId'];
                    if (userId == null || userId.isEmpty) return;

                    Navigator.push(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualChatScreen(
                          userId: userId,
                          barberId: data.barber.uid,
                        ),
                      ),
                    );
                  },
                  shareOnTap: () {
                    context.read<ShareCubit>().sharePost(
                          text: data.post.description,
                          ventureName: data.barber.ventureName,
                          location: data.barber.address,
                          imageUrl: data.post.imageUrl,
                        );
                  },
                  commentOnTap: () {
                    showCommentSheet(
                      context: context,
                      screenHeight: widget.screenHeight,
                      screenWidth: widget.screenWidth,
                      barberId: data.barber.uid,
                      docId: data.post.postId,
                      commentController: commentController,
                    );
                  },
                  likesOnTap: () {
                    context.read<LikePostCubit>().toggleLike(
                          barberId: data.barber.uid,
                          postId: data.post.postId,
                          userId: state.userId,
                          currentLikes: data.post.likes,
                        );
                  },
                  profilePage: () {
                    if (data.barber.isblok) {
                      CustomeSnackBar.show(
                        context: context,
                        title: 'Account Suspended!',
                        description:
                            'This shop account has been suspended due to unauthorized activity detected.',
                        titleClr: AppPalette.redClr,
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailBarberScreen(barberId: data.barber.uid),
                        ),
                      );
                    }
                  },
                  dateAndTime: '$formattedDate at $formattedStartTime',
                );
              },
              separatorBuilder: (context, index) =>
                  ConstantWidgets.hight10(context),
            ),
          );
        } else if (state is FetchPostWithBarberEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.photo_size_select_actual_outlined,
                    color: AppPalette.hintClr),
                const Text('No Posts Yet!'),
                Text('No posts yet. Fresh styles coming soon!',
                    style: TextStyle(color: AppPalette.greyClr)),
                IconButton(
                  onPressed: () {
                    context
                        .read<FetchPostWithBarberBloc>()
                        .add(FetchPostWithBarberRequest());
                  },
                  icon: Icon(Icons.refresh, color: AppPalette.blueClr),
                )
              ],
            ),
          );
        } else if (state is FetchPostWithBarberFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_not_supported_rounded,
                    color: AppPalette.hintClr),
                const Text('Something went wrong!'),
                Text('Oops! That didn’t work. Please try again',
                    style: TextStyle(color: AppPalette.greyClr)),
                IconButton(
                  onPressed: () {
                    context
                        .read<FetchPostWithBarberBloc>()
                        .add(FetchPostWithBarberRequest());
                  },
                  icon: Icon(Icons.refresh, color: AppPalette.redClr),
                )
              ],
            ),
          );
        }

        // Shimmer loader state
        return Shimmer.fromColors(
          baseColor: Colors.grey[300] ?? AppPalette.greyClr,
          highlightColor: AppPalette.whiteClr,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return PostScreenMainWidget(
                screenHeight: widget.screenHeight,
                heightFactor: widget.heightFactor,
                screenWidth: widget.screenWidth,
                chatOnTap: () {},
                description: 'Loading...',
                favoriteColor: AppPalette.redClr,
                favoriteIcon: Icons.favorite_border,
                likes: 0,
                likesOnTap: () {},
                commentOnTap: () {},
                location: 'Loading...',
                postUrl: '',
                profilePage: () {},
                shareOnTap: () {},
                shopName: 'Loading...',
                shopUrl: '',
                dateAndTime: '',
              );
            },
            separatorBuilder: (context, index) =>
                ConstantWidgets.hight10(context),
          ),
        );
      },
    );
  }
}

void showCommentSheet({
  required BuildContext context,
  required double screenHeight,
  required double screenWidth,
  required String barberId,
  required String docId,
  required TextEditingController commentController,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppPalette.scafoldClr,
    enableDrag: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      // This is needed to adjust for keyboard height when it appears
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;

      return Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SizedBox(
          height: screenHeight,
          child: Column(
            children: [
              ConstantWidgets.hight10(context),
              const Text(
                'Comments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ConstantWidgets.hight10(context),
              Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    return commentListWidget(
                        context: context,
                        userName: 'Abhiram ks',
                        comment:
                            'what a exelent job bro keep it up kdjlkdjflkjadfsljafdsolkjdfskl;ajfdlkjefkk;dflsajlk;fdkldfsajldfksjfdkl;jdfkfdajdfaslkjkjeoierioueroijklcaklfdjkldfjlkfdsjlkdfjklfdsjlkdfjlkdfjl;dfsj;i;lfdlkdfsjldfjlkdfjdfklsdflkjsdfljsdflkjsdfjdfslkjdfsljdfskl;jsdfaljdflkjdsflkdfsjlk;dfjsljdfslkjdfsakljdaflkdfj',
                        imageUrl: '');
                  },
                ),
              ),
              BlocListener<SendCommentBloc, SendCommentState>(
                listener: (context, state) {
                  handleSendComments(context, state, commentController);
                },
                child: ChatWindowTextFiled(
                  controller: commentController,
                  isICon: false,
                  sendButton: () {
                    final text = commentController.text.trim();
                    if (text.isNotEmpty) {
                      context.read<SendCommentBloc>().add(
                          SendCommentButtonPressed(
                              comment: text, barberId: barberId, docId: docId));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}



void handleSendComments(BuildContext context, SendCommentState state,TextEditingController controller) {
   final buttonCubit = context.read<ButtonProgressCubit>();
   if (state is SendCommentLoading) {
     buttonCubit.sendButtonStart();
   }
  else if(state is SendCommentSuccess) {
     controller.clear();
     buttonCubit.stopLoading();
  } else if (state is SendCommentFailure) {
    buttonCubit.stopLoading();

    CustomeSnackBar.show(
      context: context,
      title: 'Comment Not Delivered!  ',
      description: 'We hit a bump while sending your Comment. Let’s try again. Error: ${state.error}',
      titleClr: AppPalette.redClr,
    );
  }
}

















Column commentListWidget({
  required BuildContext context,
  required String userName,
  required String comment,
  required String imageUrl,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: imageUrl.startsWith('http')
                ? NetworkImage(imageUrl)
                : AssetImage(AppImages.barberEmpty) as ImageProvider,
          ),
          ConstantWidgets.width20(context),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ReadMoreText(
                  comment,
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  colorClickableText: AppPalette.blueClr,
                  style: const TextStyle(fontSize: 14),
                  moreStyle: TextStyle(
                    color: AppPalette.blueClr,
                    fontWeight: FontWeight.w500,
                  ),
                  lessStyle: TextStyle(
                    color: AppPalette.blueClr,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}
