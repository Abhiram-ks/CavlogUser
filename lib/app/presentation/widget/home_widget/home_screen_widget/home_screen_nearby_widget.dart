
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:user_panel/app/presentation/widget/home_widget/home_screen_widget/home_screen_map_widget.dart';

import '../../../../../auth/presentation/provider/bloc/location_bloc/location_bloc.dart';
import '../../../../../core/themes/colors.dart';
import '../../../provider/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import '../../../screens/pages/home/nearby_barbershop_screen/nearby_barbershop_screen.dart';

class HomeScreenNearbyWIdget extends StatelessWidget {
  const HomeScreenNearbyWIdget({
    super.key,
    required this.mapController,
  });

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HomeScreenMapWidget(mapController: mapController),
        Positioned(
            bottom: 10,
            left: 10,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppPalette.blueClr,
                borderRadius: BorderRadius.circular(8),
              ),
              child: BlocBuilder<NearbyBarbersBloc, NearbyBarbersState>(
                builder: (context, state) {
                  if (state is NearbyBarbersLoading) {
                    return Text(
                      'Nearby Shops: Loading...',
                      style: TextStyle(color: AppPalette.whiteClr),
                    );
                  } else if (state is NearbyBarbersLoaded) {
                    return InkWell(
                      onTap: () {},
                      child: Text(
                        'Nearby Shops: ${state.barbers.length} result(s)',
                        style: TextStyle(color: AppPalette.whiteClr),
                      ),
                    );
                  } else {
                    return InkWell(
                      onTap: () {
                        context
                            .read<LocationBloc>()
                            .add(GetCurrentLocationEvent());
                      },
                      child: const Text(
                        'Search... failed',
                        style: TextStyle(color: AppPalette.whiteClr),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: AppPalette.whiteClr,
                borderRadius: BorderRadius.circular(8),
              ),
              child: BlocBuilder<NearbyBarbersBloc, NearbyBarbersState>(
                builder: (context, state) {
                  if (state is NearbyBarbersLoading) {
                    return CircularProgressIndicator(color: AppPalette.orengeClr,);
                  } else if (state is NearbyBarbersLoaded){
                       return InkWell(
                      onTap: () {},
                      child: Text(
                        'Nearby barber shops (5 km search area)',
                        style: TextStyle(color: AppPalette.blackClr),
                      ),
                    );
                  }
                    return InkWell(
                      onTap: () {},
                      child: Text(
                        'connection failed. Please try again.',
                        style: TextStyle(color: AppPalette.blackClr),
                      ),
                    );
                  
                },
              ),
            ),
          ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppPalette.orengeClr,
              borderRadius: BorderRadius.circular(8),
            ),
            child: BlocBuilder<LocationBloc, LocationState>(
              builder: (context, state) {
                if (state is LocationLoading) {
                  return  Text(
                    'Loading...',
                    style: TextStyle(color: AppPalette.whiteClr),
                  );
                }else if (state is LocationLoaded){
                  final LatLng currentPosition = state.position;
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NearbyBarbershopScreen(currentPosition: currentPosition)));
                  },
                  child: const Text(
                    'Find now',
                    style: TextStyle(color: AppPalette.whiteClr),
                  ),
                );
                }else{
                return InkWell(
                  onTap: () {
                    context.read<LocationBloc>().add(GetCurrentLocationEvent());
                  },
                  child: const Text('Retry',
                    style: TextStyle(color: AppPalette.whiteClr),
                  ),
                );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
