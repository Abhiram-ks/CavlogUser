
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constant/constant.dart';
import '../../../../core/utils/image/app_images.dart';

Column commentListWidget({
  required BuildContext context,
  required String userName,
  required String comment,
  required String imageUrl,
  required String createdAt,
  required int likesCount,
  required IconData favoriteIcon,
  required Color favoriteColor,
  required VoidCallback likesOnTap,
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
                const SizedBox(height: 4),
                Text(
                  createdAt,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w200, color: AppPalette.greyClr),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: Icon(
                  favoriteIcon,
                  color: favoriteColor,
                ),
                onPressed: likesOnTap,
              ),
              Text(
                likesCount.toString(),
                style: TextStyle(
                  fontSize: 12,
                  color: AppPalette.greyClr,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
