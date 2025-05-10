
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../auth/presentation/widget/location_widget/location_formalt_converter_widget.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../../core/utils/image/app_images.dart';
import '../../../provider/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import '../../search_widget/payment_screen_widgets/payment_top_portion_detail_widget.dart';

Expanded nerbyWorkShopDetailsWIdget( {required double screenHeight, required double screenWidth}) {
  return Expanded(
    child: SizedBox(
      width: screenWidth,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          Center(
            child: SizedBox(
              height: screenHeight * 0.13,
              child: BlocBuilder<NearbyBarbersBloc, NearbyBarbersState>(
                builder: (context, state) {
                  if (state is NearbyBarbersLoaded) {
                    final barbers = state.barbers;
                    if (barbers.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_outlined,
                              color: AppPalette.orengeClr,
                            ),
                            Text('Empty search...'),
                            Text('Request failed. No shops found nearby.'),
                          ],
                        ),
                      );
                    }
                    return ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
                        itemCount: barbers.length,
                        separatorBuilder: (_, __) =>
                            ConstantWidgets.width20(context),
                        itemBuilder: (context, index) {
                          final barber = barbers[index];

                          return FutureBuilder<String>(
                            future: getFormattedAddress(barber.lat, barber.lng),
                            builder: (context, snapshot) {
                              final address = snapshot.data ?? barber.address;

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(13),
                                child: BackdropFilter(
                                  filter:ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: Container(
                                    width: screenWidth * 0.77,
                                    color: AppPalette.blackClr
                                        .withAlpha((0.7 * 255).toInt()),
                                    alignment: Alignment.center,
                                    child: paymentSectionBarberData(
                                      context: context,
                                      imageURl: AppImages.barberEmpty,
                                      shopName:
                                          '${barber.name} • ${barber.distance} km',
                                      shopAddress: address,
                                      ratings: barber.distance,
                                      screenHeight: screenHeight,
                                      screenWidth: screenWidth,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        });
                  }
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    itemCount: 2,
                    separatorBuilder: (_, __) =>
                        ConstantWidgets.width20(context),
                    itemBuilder: (context, index) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                        highlightColor: AppPalette.whiteClr,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              width: screenWidth * 0.77,
                              color: AppPalette.hintClr
                                  .withAlpha((0.5 * 255).toInt()),
                              alignment: Alignment.center,
                              child: paymentSectionBarberData(
                                context: context,
                                imageURl: AppImages.barberEmpty,
                                shopName: 'Automatic trading mechanics',
                                shopAddress:
                                    'Ambalawayal sulthan bathery eranakulam',
                                ratings: 3,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    ),
  );
}
