import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:user_panel/app/presentation/widget/home_widget/home_screen_widget/home_screen_nearby_widget.dart';

import '../../../../../core/themes/colors.dart';

class NearbyShowMapWidget extends StatelessWidget {
  const NearbyShowMapWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.mapController,
  });

  final double screenHeight;
  final double screenWidth;
  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * .3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: AppPalette.hintClr,
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: HomeScreenNearbyWIdget(mapController: mapController),
      ),
    );
  }
}
