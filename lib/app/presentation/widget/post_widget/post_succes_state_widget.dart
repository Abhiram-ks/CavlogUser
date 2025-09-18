import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/data/models/post_with_barber_model.dart';
import 'package:user_panel/app/domain/usecases/data_listing_usecase.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_post_with_barber_bloc/fetch_post_with_barber_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/post_like_cubit/post_like_cubit.dart';
import 'package:user_panel/app/presentation/provider/cubit/share_post_cubit/share_post_cubit.dart';
import 'package:user_panel/app/presentation/screens/pages/chat/chat_window_screen.dart';
import 'package:user_panel/app/presentation/screens/pages/search/detail_screen/detail_screen.dart';
import 'package:user_panel/app/presentation/widget/post_widget/post_card_widget.dart';
import 'package:user_panel/app/presentation/widget/post_widget/post_comment_bottomsheet.dart';
import 'package:user_panel/core/common/custom_snackbar_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import 'package:user_panel/core/utils/constant/constant.dart';
import 'package:user_panel/core/utils/image/app_images.dart';

RefreshIndicator postBlocSuccessStateBuilder(
    {required BuildContext context,
    required List<PostWithBarberModel> model,
    required FetchPostWithBarberLoaded state,
    required double screenHeight,
    required double screenWidth,
    required double heightFactor,
    required TextEditingController commentController}) {
  return RefreshIndicator(
    color: AppPalette.buttonClr,
    backgroundColor: AppPalette.whiteClr,
    onRefresh: () async {
      context.read<FetchPostWithBarberBloc>().add(FetchPostWithBarberRequest());
    },
    child: ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: model.length,
      itemBuilder: (context, index) {
        final data = model[index];
        final formattedDate = formatDate(data.post.createdAt);
        final formattedStartTime = formatTimeRange(data.post.createdAt);

        return PostScreenMainWidget(
          screenHeight: screenHeight,
          heightFactor: heightFactor,
          screenWidth: screenWidth,
          shopName: data.barber.ventureName,
          description: data.post.description,
          isLiked: data.post.likes.contains(state.userId),
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
          chatOnTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IndividualChatScreen(
                  userId: state.userId,
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
              screenHeight: screenHeight,
              screenWidth: screenWidth,
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
      separatorBuilder: (context, index) => ConstantWidgets.hight10(context),
    ),
  );
}
