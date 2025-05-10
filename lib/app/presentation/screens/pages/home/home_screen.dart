import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/data/repositories/barbershop_repo.dart';
import 'package:user_panel/app/data/repositories/fetch_banner_repo.dart';
import 'package:user_panel/app/presentation/screens/pages/home/nearby_barbershop_screen/nearby_barbershop_screen.dart';
import 'package:user_panel/core/routes/routes.dart';
import 'package:user_panel/core/utils/constant/constant.dart';
import '../../../../../auth/domain/usecases/get_location_usecase.dart';
import '../../../../../auth/presentation/provider/bloc/location_bloc/location_bloc.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/image/app_images.dart';
import '../../../../domain/repositories/barbershop_services_repo.dart';
import '../../../provider/bloc/fetching_bloc/fetch_banners_bloc/fetch_banners_bloc.dart';
import '../../../provider/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import '../../../widget/profile_widget/profile_scrollable_section.dart';
import '../../../widget/search_widget/details_screen_widget/details_imagescroll_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => FetchBannersBloc(FetchBannerRepositoryImpl())),
        BlocProvider(create: (context) => NearbyBarbersBloc(
                GetNearbyBarberShops(BarberShopRepositoryImpl()))),
        BlocProvider( create: (context) => LocationBloc(GetLocationUseCase())
              ..add(GetCurrentLocationEvent()))
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.blackClr,
            child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                body: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      backgroundColor: AppPalette.blackClr,
                      expandedHeight: screenHeight * 0.13,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        collapseMode: CollapseMode.parallax,
                        background: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    profileviewWidget(
                                      screenWidth,
                                      context,
                                      Icons.location_on,
                                      'Wayanad, sulthan bathery',
                                      AppPalette.redClr,
                                    ),
                                    ConstantWidgets.hight10(context),
                                    Text(
                                      'Hello, Abhiramks',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton.filled(
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppPalette.whiteClr,
                                      ),
                                      icon: Icon(
                                        Icons.account_balance_wallet_outlined,
                                        color: AppPalette.blackClr,
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.wallet);
                                      },
                                    ),
                                    IconButton.filled(
                                      style: IconButton.styleFrom(
                                        backgroundColor: AppPalette.whiteClr,
                                      ),
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: AppPalette.blackClr,
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.wishList);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    /// Body Content
                    SliverToBoxAdapter(
                      child: HomeScreenBodyWIdget(
                          screenHeight: screenHeight, screenWidth: screenWidth),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class HomeScreenBodyWIdget extends StatefulWidget {
  const HomeScreenBodyWIdget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;
  final double screenWidth;

  @override
  State<HomeScreenBodyWIdget> createState() => _HomeScreenBodyWIdgetState();
}

class _HomeScreenBodyWIdgetState extends State<HomeScreenBodyWIdget> {
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBannersBloc>().add(FetchBannersRequest());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<FetchBannersBloc, FetchBannersState>(
            builder: (context, state) {
              if (state is FetchBannersLoaded) {
                return ImageScolingWidget(
                    show: false,
                    imageList: state.banners.imageUrls,
                    screenHeight: widget.screenHeight,
                    screenWidth: widget.screenWidth);
              } else if (state is FetchBannersLoading) {
                Shimmer.fromColors(
                  baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                  highlightColor: AppPalette.whiteClr,
                  child: ImageScolingWidget(
                      imageList: [AppImages.barberEmpty, AppImages.barberEmpty],
                      show: true,
                      screenHeight: widget.screenHeight,
                      screenWidth: widget.screenWidth),
                );
              }
              return ConstantWidgets.hight10(context);
            },
          ),
          ConstantWidgets.hight10(context),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widget.screenWidth * .04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find the Best Barbers Near You!',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                NearbyShowMapWidget(
                  mapController: _mapController,
                  screenHeight: widget.screenHeight,
                  screenWidth: widget.screenWidth,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
        child: Stack(
          children: [
            BlocBuilder<LocationBloc, LocationState>(
              builder: (context, locationState) {
                if (locationState is LocationLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppPalette.buttonClr),
                  );
                } else if (locationState is LocationLoaded) {
                  final LatLng currentPosition = locationState.position;

                  context.read<NearbyBarbersBloc>().add(
                        LoadNearbyBarbers(currentPosition.latitude,
                            currentPosition.longitude, 5000),
                      );

                  return BlocBuilder<NearbyBarbersBloc, NearbyBarbersState>(
                    builder: (context, barberState) {
                      log('state of the barbers is $barberState');
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
                            child: Icon(Icons.content_cut, color: AppPalette.blackClr, size: 10),
                          );
                        }));
                      }

                      return FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: currentPosition,
                          initialZoom: 14.5,
                        interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
                          // interactionOptions: const InteractionOptions(
                          //   flags: InteractiveFlag.all &
                          //       ~InteractiveFlag.pinchZoom &
                          //       ~InteractiveFlag.doubleTapZoom &
                          //       ~InteractiveFlag.scrollWheelZoom,
                          // ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                            userAgentPackageName: 'com.yourcompany.yourapp',
                          ),
                          PolygonLayer(
                                  polygons: [
                                    Polygon(
                                      points: createGeodesicCircle( currentPosition, 5000),
                                      color: AppPalette.blueClr
                                          .withAlpha((0.2 * 255).toInt()),
                                      borderColor: AppPalette.blueClr,
                                      borderStrokeWidth: 1,
                                    ),
                                  ],
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
        ),
      ),
    );
  }
}
