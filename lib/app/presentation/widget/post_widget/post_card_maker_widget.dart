
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

import '../../../../core/common/custom_imageshow_widget.dart';
import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constant/constant.dart';
import '../../../../core/utils/image/app_images.dart';
import '../../provider/cubit/like_animation_cubit/like_animation_cubit.dart';

class PostgScreenGenerateWIdget extends StatelessWidget {
  const PostgScreenGenerateWIdget({
    super.key,
    required this.profilePage,
    required this.shopUrl,
    required this.shopName,
    required this.location,
    required this.isLiked,
    required this.likesOnTap,
    required this.screenHeight,
    required this.heightFactor,
    required this.postUrl,
    required this.favoriteIcon,
    required this.favoriteColor,
    required this.shareOnTap,
    required this.commentOnTap,
    required this.chatOnTap,
    required this.screenWidth,
    required this.likes,
    required this.description,
    required this.dateAndTime,
  });

  final VoidCallback profilePage;
  final String shopUrl;
  final String shopName;
  final String location;
  final VoidCallback likesOnTap;
  final double screenHeight;
  final double heightFactor;
  final String postUrl;
  final IconData favoriteIcon;
  final Color favoriteColor;
  final VoidCallback shareOnTap;
  final VoidCallback commentOnTap;
  final VoidCallback chatOnTap;
  final double screenWidth;
  final int likes;
  final String description;
  final String dateAndTime;
  final bool isLiked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstantWidgets.hight10(context),
        SizedBox(
          width: double.infinity,
          child: InkWell(
            onTap: profilePage,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SizedBox(
                      height: 48,
                      width: 48,
                      child: ClipOval(
                        child: Container(
                            color: Colors.grey.shade800,
                            child: (shopUrl.startsWith('http'))
                                ? imageshow(
                                    imageUrl: shopUrl,
                                    imageAsset: AppImages.loginImageAbove)
                                : Image.asset(
                                    AppImages.loginImageAbove,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                    ),
                  ),
                ),
                ConstantWidgets.width20(context),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_history_rounded,
                            color: Colors.black,
                            size: 16,
                          ),
                          ConstantWidgets.width20(context),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ConstantWidgets.hight10(context),
        InkWell(
          onDoubleTap: () {
            context.read<PostLikeAnimationCubit>().showHeart();
            likesOnTap();
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: screenHeight * heightFactor,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: (postUrl.startsWith('http'))
                      ? imageshow(
                          imageUrl: postUrl,
                          imageAsset: AppImages.barberEmpty,
                        )
                      : Image.asset(
                          AppImages.barberEmpty,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              BlocBuilder<PostLikeAnimationCubit, bool>(
                builder: (context, isVisible) {
                  return AnimatedOpacity(
                    opacity: isVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 120),
                    child: AnimatedScale(
                      scale: isVisible ? 1.5 : 0.0,
                      duration: const Duration(milliseconds: 120),
                      child:  Icon(
                        isLiked ? favoriteIcon :Icons.heart_broken,
                        color: AppPalette.redClr,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                favoriteIcon,
                color: favoriteColor,
              ),
              onPressed: likesOnTap,
            ),
            IconButton(
              icon: Icon(
                Icons.send_and_archive_rounded,
              ),
              onPressed: shareOnTap,
            ),
            IconButton(
              icon: Icon(
                Icons.insert_comment_rounded,
              ),
              onPressed: commentOnTap,
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.chat_bubble_fill,
                color: Colors.blueGrey,
              ),
              onPressed: chatOnTap,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * .04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$likes Appreciations',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              ReadMoreText(
                description,
                trimMode: TrimMode.Line,
                trimLines: 2,
                colorClickableText: AppPalette.blueClr,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: TextStyle(color: AppPalette.blueClr),
              ),
              Text(
                dateAndTime,
                style: TextStyle(color: AppPalette.greyClr),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}