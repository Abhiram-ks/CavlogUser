import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../auth/domain/usecases/get_location_usecase.dart';
import '../../../../../../auth/presentation/provider/bloc/location_bloc/location_bloc.dart';
import '../../../../../../auth/presentation/provider/bloc/searchlocation_bloc/serchlocaton_bloc.dart';
import '../../../../../../auth/presentation/widget/location_widget/location_formalt_converter_widget.dart';
import '../../../../../../core/common/custom_formfield_widget.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../../../core/utils/debouncer/debouncer.dart';
import '../../../../../data/repositories/barbershop_repo.dart';
import '../../../../../domain/repositories/barbershop_services_repo.dart';
import '../../../../provider/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import '../../../../provider/cubit/distance_filtering_cubit/distance_filtering_cubit.dart';
import '../../../../provider/cubit/distance_filtering_cubit/distance_filtering_enum.dart';
import '../../../../widget/home_widget/nearbyshop_widget/nearby_shop_details_widget.dart';
import '../../../../widget/home_widget/nearbyshop_widget/nearby_shop_distanceconverter.dart';

class NearbyBarbershopScreen extends StatelessWidget {
  final LatLng currentPosition;

  const NearbyBarbershopScreen({super.key, required this.currentPosition});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => NearbyBarbersBloc(
                GetNearbyBarberShops(BarberShopRepositoryImpl()))),
        BlocProvider(
            create: (context) => LocationBloc(GetLocationUseCase())
              ..add(GetCurrentLocationEvent())),
        BlocProvider(
          create: (context) => DistanceFilterCubit(),
        )
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: NearbyBarberShopScreenWidget(
                screenHeight: screenHeight,
                screenWidth: screenWidth,
                currentPosition: currentPosition),
          );
        },
      ),
    );
  }
}

class NearbyBarberShopScreenWidget extends StatefulWidget {
  const NearbyBarberShopScreenWidget(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.currentPosition});

  final double screenHeight;
  final LatLng currentPosition;
  final double screenWidth;

  @override
  State<NearbyBarberShopScreenWidget> createState() =>
      NearbyBarberShopScreenWidgetState();
}

class NearbyBarberShopScreenWidgetState
    extends State<NearbyBarberShopScreenWidget> with FormFieldMixin {
  final MapController _mapController = MapController();
  final TextEditingController searchController = TextEditingController();
  late Debouncer debouncer = Debouncer(milliseconds: 150);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NearbyBarbersBloc>().add(LoadNearbyBarbers(
          widget.currentPosition.latitude,
          widget.currentPosition.longitude,
          5000));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.screenHeight * 0.74,
          width: widget.screenWidth,
          child: Stack(
            children: [
              BlocBuilder<LocationBloc, LocationState>(
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
                    context.read<LocationBloc>().add(UpdateLocationEvent(point));
                    try {
                      List<Placemark> placemarks = await placemarkFromCoordinates(
                              point.latitude, point.longitude);
                      if (placemarks.isNotEmpty) {
                        final Placemark place = placemarks.first;
                        String formatAddress =AddressFormatter.formatAddress(place);
                        searchController.text = formatAddress;
                      } else {
                        searchController.text ="${point.latitude}, ${point.longitude}";
                      }
                    } catch (e) {
                      searchController.text ="${point.latitude}, ${point.longitude}";
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
                                final selectedDistance = context.read<DistanceFilterCubit>().state;
                                int distanceInMeters =  getDistanceInMeters(selectedDistance);
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
                        return Text(
                          'Loading...',
                          style: TextStyle(color: AppPalette.whiteClr),
                        );
                      } else if (state is LocationLoaded) {
                        return InkWell(
                          onTap: () {
                            final selectedDistance =
                                context.read<DistanceFilterCubit>().state;

                            int distanceInMeters =
                                getDistanceInMeters(selectedDistance);

                            context.read<NearbyBarbersBloc>().add(
                                LoadNearbyBarbers(
                                    widget.currentPosition.latitude,
                                    widget.currentPosition.longitude,
                                    distanceInMeters));
                          },
                          child: const Text(
                            'Apply filter',
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
                            'Retry',
                            style: TextStyle(color: AppPalette.whiteClr),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
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
                top: 50,
                left: 10,
                right: 10,
                child: Column(
                  children: [
                    TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search location...',
                        fillColor: AppPalette.whiteClr,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: AppPalette.hintClr,
                            width: 2.0,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: AppPalette.hintClr,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: AppPalette.hintClr,
                            width: 2.0,
                          ),
                        ),
                        prefixIcon: const Icon(Icons.search),
                        prefixIconColor: AppPalette.blackClr,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            onPressed: () {
                               FocusScope.of(context).unfocus();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPalette.buttonClr, 
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Search',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(minWidth: 90),
                      ),
                        onChanged: (query) {
                  debouncer.run(() {
                    context
                        .read<SerchlocatonBloc>()
                        .add(SearchLocationEvent(query));
                  });
                },
                    ),
                    BlocBuilder<SerchlocatonBloc, SerchlocatonState>(
                      builder: (context, state) {
                        if (state is SearchLocationLoaded &&
                            state.suggestions.isNotEmpty) {
                          return Container(
                            constraints: const BoxConstraints(maxHeight: 200),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.suggestions.length,
                              itemBuilder: (context, index) {
                                final suggestion = state.suggestions[index];
                                return ListTile(
                                  title: Text(suggestion['display_name']),
                                  onTap: () {
                                    double lat =
                                        double.parse(suggestion['lat']);
                                    double lon =
                                        double.parse(suggestion['lon']);
                                    context.read<SerchlocatonBloc>().add(
                                        SelectLocationEvent(lat, lon,
                                            suggestion['display_name']));

                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      _mapController.move(
                                          LatLng(lat, lon), 15.0);
                                    });
                                  },
                                );
                              },
                            ),
                          );
                        } else if (state is SearchLocationError) {
                          return Container(
                            width: double.infinity,
                            height: widget.screenHeight * .06,
                            constraints: const BoxConstraints(maxHeight: 200),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 5)
                              ],
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: AppPalette.hintClr,
                                  ),
                                  ConstantWidgets.width20(context),
                                  Text(
                                    'Search for ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        nearbyShopDrpdownWIdget(
            context, widget.screenHeight, widget.screenWidth),
        nerbyWorkShopDetailsWIdget(
            screenHeight: widget.screenHeight, screenWidth: widget.screenWidth),
      ],
    );
  }
}

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
                    context
                        .read<DistanceFilterCubit>()
                        .selectDistance(newValue);
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

List<LatLng> createGeodesicCircle(LatLng center, int radiusInMeters,
    {int points = 60}) {
  const double earthRadius = 6371000.0; 
  final double lat = center.latitude * (pi / 180.0);
  final double lng = center.longitude * (pi / 180.0);
  final double d = radiusInMeters / earthRadius;

  return List.generate(points, (i) {
    final double bearing = (2 * pi * i) / points;
    final double latRadians =
        asin(sin(lat) * cos(d) + cos(lat) * sin(d) * cos(bearing));
    final double lngRadians = lng +
        atan2(
          sin(bearing) * sin(d) * cos(lat),
          cos(d) - sin(lat) * sin(latRadians),
        );

    return LatLng(latRadians * (180.0 / pi), lngRadians * (180.0 / pi));
  });
}
