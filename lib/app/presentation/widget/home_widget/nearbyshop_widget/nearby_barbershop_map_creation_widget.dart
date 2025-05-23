
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:user_panel/app/presentation/widget/home_widget/nearbyshop_widget/nearby_shop_distanceconverter.dart' show getDistanceInMeters;
import '../../../../../auth/presentation/provider/bloc/location_bloc/location_bloc.dart';
import '../../../../../auth/presentation/widget/location_widget/location_formalt_converter_widget.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../domain/usecases/geodesic_circle_usecase.dart';
import '../../../provider/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import '../../../provider/cubit/distance_filtering_cubit/distance_filtering_cubit.dart';
import '../../../provider/cubit/distance_filtering_cubit/distance_filtering_enum.dart';

class NearbyBarberShopCreateMapWidget extends StatelessWidget {
  const NearbyBarberShopCreateMapWidget({
    super.key,
    required MapController mapController,
    required this.searchController,
  }) : _mapController = mapController;

  final MapController _mapController;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, locationState) {
        if (locationState is LocationLoading) {
          return const Center(
            child: CircularProgressIndicator(
                color: AppPalette.buttonClr),
          );
        } else if (locationState is LocationLoaded) {
          final LatLng currentPosition = locationState.position;
        
          context.read<NearbyBarbersBloc>().add(LoadNearbyBarbers(
              currentPosition.latitude,
              currentPosition.longitude,
              5000));
        
          return BlocBuilder<NearbyBarbersBloc, NearbyBarbersState>(
            builder: (context, barberState) {
              List<Marker> markers = [
                Marker(
                  point: currentPosition,
                  width: 40,
                  height: 40,
                  child: const Icon(Icons.my_location,
                      color: AppPalette.redClr, size: 20),
                ),
              ];
        
              if (barberState is NearbyBarbersLoaded) {
                markers.addAll(barberState.barbers.map((barber) {
                  return Marker(
                    point: LatLng(barber.lat, barber.lng),
                    width: 40,
                    height: 40,
                    child: Icon(Icons.content_cut,
                        color: AppPalette.blackClr, size: 10),
                  );
                }));
              }
        
              return FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: currentPosition,
                  initialZoom: 14.5,
                  interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all),
                  onTap: (tapPosition, point) async {
                    context
                        .read<LocationBloc>()
                        .add(UpdateLocationEvent(point));
                    try {
                      List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              point.latitude, point.longitude);
                      if (placemarks.isNotEmpty) {
                        final Placemark place = placemarks.first;
                        String formatAddress =  AddressFormatter.formatAddress(place);
                        searchController.text = formatAddress;
                      } else {
                        searchController.text =
                            "${point.latitude}, ${point.longitude}";
                      }
                    } catch (e) {
                      searchController.text =
                          "${point.latitude}, ${point.longitude}";
                    }
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    userAgentPackageName: 'com.yourcompany.yourapp',
                    tileProvider: NetworkTileProvider(),
                    fallbackUrl: null,
                  ),
                  BlocBuilder<DistanceFilterCubit, DistanceFilter>(
                    builder: (context, state) {
                      final selectedDistance =  context.read<DistanceFilterCubit>().state;
                      int distanceInMeters = getDistanceInMeters(selectedDistance);
                      return PolygonLayer(
                        polygons: [
                          Polygon(
                            points: createGeodesicCircle(
                                currentPosition, distanceInMeters),
                            color: AppPalette.blueClr
                                .withAlpha((0.2 * 255).toInt()),
                            borderColor: AppPalette.blueClr,
                            borderStrokeWidth: 1,
                          ),
                        ],
                      );
                    },
                  ),
                  MarkerLayer(markers: markers),
                ],
              );
            },
          );
        }
        
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off),
              Text('Failed to load map!',
                  style: TextStyle(color: AppPalette.redClr)),
              const Text('Unexpected error! Please try again.'),
            ],
          ),
        );
      },
    );
  }
}
