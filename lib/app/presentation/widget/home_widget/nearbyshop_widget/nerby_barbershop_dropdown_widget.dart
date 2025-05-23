

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../provider/cubit/distance_filtering_cubit/distance_filtering_cubit.dart' show DistanceFilterCubit;
import '../../../provider/cubit/distance_filtering_cubit/distance_filtering_enum.dart';

Container nearbyShopDrpdownWIdget(
    BuildContext context, double screenHeight, double screenWidth) {
  return Container(
    height: screenHeight * 0.06,
    width: screenWidth,
    padding: EdgeInsets.symmetric(horizontal: 16),
    alignment: Alignment.center,
    child: Row(
      children: [
        Icon(
          Icons.place,
          color: AppPalette.redClr,
        ),
        const Text('Filter by Distance'),
        ConstantWidgets.width40(context),
        Expanded(
          child: BlocBuilder<DistanceFilterCubit, DistanceFilter>(
            builder: (context, selectedDistance) {
              return DropdownButton<DistanceFilter>(
                value: selectedDistance,
                focusColor: AppPalette.buttonClr,
                isExpanded: true,
                underline: Container(height: 1, color: Colors.grey),
                items: DistanceFilter.values.map((distance) {
                  return DropdownMenuItem<DistanceFilter>(
                    value: distance,
                    child: Text(distance.label),
                  );
                }).toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    context.read<DistanceFilterCubit>().selectDistance(newValue);
                  }
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}

