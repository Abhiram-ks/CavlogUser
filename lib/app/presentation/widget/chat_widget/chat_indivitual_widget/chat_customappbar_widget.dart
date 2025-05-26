
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_barber_bloc/fetch_barber_id_bloc.dart';
import 'package:user_panel/app/presentation/screens/pages/search/detail_screen/detail_screen.dart';

import '../../../../../core/common/custom_imageshow_widget.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../../core/utils/image/app_images.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String barberId;
  final double screenWidth;

  const ChatAppBar({
    super.key,
    required this.barberId,
    required this.screenWidth,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    context.read<FetchBarberIdBloc>().add(FetchBarberDetailsAction(barberId));

    return BlocBuilder<FetchBarberIdBloc, FetchBarberIdState>(
      builder: (context, state) {
        if (state is FetchBarberDetailsSuccess) {
          final barber = state.barberServices;

          return AppBar(
            backgroundColor: AppPalette.blackClr,
            automaticallyImplyLeading: true,
            elevation: 0,
            titleSpacing: 0,
            iconTheme: const IconThemeData(color: AppPalette.whiteClr),
            title: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailBarberScreen(barberId: barberId))),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: imageshow(
                        imageUrl: barber.image ?? '',
                        imageAsset: AppImages.barberEmpty,
                      ),
                    ),
                  ),
                  ConstantWidgets.width20(context),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barber.ventureName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                            color: AppPalette.whiteClr,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          barber.email,
                          style: TextStyle(
                            color: AppPalette.greenClr,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ConstantWidgets.width40(context),
                ],
              ),
            ),
          );
        }
        return AppBar(
          backgroundColor: AppPalette.blackClr,
          automaticallyImplyLeading: true,
          elevation: 0,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: AppPalette.whiteClr),
          title: Shimmer.fromColors(
            baseColor: Colors.grey[300] ?? AppPalette.greyClr,
            highlightColor: AppPalette.whiteClr,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: imageshow(
                      imageUrl: '',
                      imageAsset: AppImages.barberEmpty,
                    ),
                  ),
                ),
                ConstantWidgets.width20(context),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Venture Name Loading...",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                          color: AppPalette.whiteClr,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'loading...',
                        style: TextStyle(
                          color: AppPalette.greenClr,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
