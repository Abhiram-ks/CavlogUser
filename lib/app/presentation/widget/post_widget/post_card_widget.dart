
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:user_panel/core/common/custom_imageshow_widget.dart';
import 'package:user_panel/core/utils/constant/constant.dart';
import 'package:user_panel/core/utils/image/app_images.dart';

import '../../../../core/themes/colors.dart';

class PostScreenMainWidget extends StatelessWidget {
  final double screenHeight;
  final double heightFactor;
  final double screenWidth;
  final String postUrl;
  final String shopUrl;
  final String shopName;
  final String location;
  final int likes;
  final String description;
  final VoidCallback profilePage;
  final VoidCallback likesOnTap;
  final VoidCallback shareOnTap;
  final VoidCallback chatOnTap;
  final VoidCallback commentOnTap;
  final Color favoriteColor;
  final IconData favoriteIcon;
  final String dateAndTime;

  const PostScreenMainWidget({
    super.key,
    required this.screenHeight,
    required this.heightFactor,
    required this.screenWidth,
    required this.postUrl,
    required this.shopUrl,
    required this.shopName,
    required this.location,
    required this.likes,
    required this.description,
    required this.profilePage,
    required this.likesOnTap,
    required this.shareOnTap,
    required this.chatOnTap,
    required this.favoriteColor,
    required this.favoriteIcon,
    required this.dateAndTime,
    required this.commentOnTap,
  });

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
        SizedBox(
          height: screenHeight * heightFactor,
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: (postUrl.startsWith('http'))
                  ? imageshow(
                      imageUrl: postUrl, imageAsset: AppImages.barberEmpty)
                  : Image.asset(
                      AppImages.barberEmpty,
                      fit: BoxFit.cover,
                    )),
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
