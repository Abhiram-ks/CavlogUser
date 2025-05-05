
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/common/custom_imageshow_widget.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../../core/utils/image/app_images.dart';
import '../../profile_widget/profile_scrollable_section.dart';

SizedBox paymentSectionBarberData(
    {required BuildContext context,
    required String imageURl,
    required String shopName,
    required String shopAddress,
    required double ratings,
    required double screenWidth,
    required double screenHeight}) {
  return SizedBox(
    height: screenHeight * 0.12,
    child: Row(
      children: [
        ConstantWidgets.width20(context),
        Flexible(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: (imageURl.startsWith('http'))
                ? imageshow(
                    imageUrl: imageURl, imageAsset: AppImages.barberEmpty)
                : Image.asset(
                    AppImages.barberEmpty,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
          ),
        ),
        ConstantWidgets.width20(context),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                shopName,
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppPalette.whiteClr),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              profileviewWidget(
                screenWidth,
                context,
                Icons.location_on,
                shopAddress,
                AppPalette.redClr,
                maxline: 2,
                textColor: AppPalette.hintClr,
              ),
              ConstantWidgets.width40(context),
              RatingBarIndicator(
                rating: ratings,
                unratedColor: AppPalette.hintClr,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: AppPalette.buttonClr,
                ),
                itemCount: 5,
                itemSize: 13.0,
                direction: Axis.horizontal,
              ),
            ],
          ),
        ),
        ConstantWidgets.width20(context),
      ],
    ),
  );
}
