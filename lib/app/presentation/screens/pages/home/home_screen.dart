import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/data/repositories/barbershop_repo.dart';
import 'package:user_panel/app/data/repositories/fetch_banner_repo.dart';
import 'package:user_panel/core/routes/routes.dart';
import 'package:user_panel/core/utils/constant/constant.dart';
import '../../../../../auth/domain/usecases/get_location_usecase.dart';
import '../../../../../auth/presentation/provider/bloc/location_bloc/location_bloc.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/image/app_images.dart';
import '../../../../domain/repositories/barbershop_services_repo.dart';
import '../../../provider/bloc/fetching_bloc/fetch_banners_bloc/fetch_banners_bloc.dart';
import '../../../provider/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import '../../../provider/cubit/cubit/booking_timeline_cubit.dart';
import '../../../provider/cubit/cubit/booking_timeline_state.dart';
import '../../../widget/home_widget/home_screen_widget/home_screen_nearby.dart';
import '../../../widget/profile_widget/profile_scrollable_section.dart';
import '../../../widget/search_widget/details_screen_widget/details_imagescroll_widget.dart';
import '../../../widget/search_widget/details_screen_widget/details_screen_actionbuttos.dart';
import '../../../widget/search_widget/search_screen_widget/custom_cards_barberlist.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TimelineCubit()),
        BlocProvider(
            create: (context) => FetchBannersBloc(FetchBannerRepositoryImpl())),
        BlocProvider(
            create: (context) => NearbyBarbersBloc(
                GetNearbyBarberShops(BarberShopRepositoryImpl()))),
        BlocProvider(
            create: (context) => LocationBloc(GetLocationUseCase())
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
                ),
                ConstantWidgets.hight30(context),
                Text(
                  'Track Booking Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ConstantWidgets.hight10(context),
                HorizontalIconTimeline(
                  screenWidth: MediaQuery.of(context).size.width,
                  screenHeight: MediaQuery.of(context).size.height,
                  createdAt: DateTime.parse('2025-05-05T15:10:38+05:30'),
                  duration: 90,
                  slotTimes: [
                    DateTime.parse('2025-05-12T08:00:00+05:30'),
                    DateTime.parse('2025-05-12T08:45:00+05:30'),
                  ],
                  onTapMessage: () {
                    print('Message tapped');
                  },
                  onTapCall: () {
                    print('Call tapped');
                  },
                  onTapDirection: () {
                    print('Direction tapped');
                  },
                  onTapCancel: () {
                    print('Cancel tapped');
                  },
                  imageUrl: AppImages.barberEmpty,
                  onTapBarber: () {
                    print('Barber tapped');
                  },
                  shopName: 'Masterpiece - The Classic Cut Barbershop',
                  isBlocked: false,
                  shopAddress:
                      '123 Kingsway Avenue, Downtown District, Springfield, IL 62704',
                ), Divider(),
                HorizontalIconTimeline(
                  screenWidth: MediaQuery.of(context).size.width,
                  screenHeight: MediaQuery.of(context).size.height,
                  createdAt: DateTime.parse('2025-05-05T15:10:38+05:30'),
                  duration: 90,
                  slotTimes: [
                    DateTime.parse('2025-05-12T08:00:00+05:30'),
                    DateTime.parse('2025-05-12T08:45:00+05:30'),
                  ],
                  onTapMessage: () {
                    print('Message tapped');
                  },
                  onTapCall: () {
                    print('Call tapped');
                  },
                  onTapDirection: () {
                    print('Direction tapped');
                  },
                  onTapCancel: () {
                    print('Cancel tapped');
                  },
                  imageUrl: AppImages.barberEmpty,
                  onTapBarber: () {
                    print('Barber tapped');
                  },
                  shopName: 'Masterpiece - The Classic Cut Barbershop',
                  isBlocked: false,
                  shopAddress:
                      '123 Kingsway Avenue, Downtown District, Springfield, IL 62704',
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalIconTimeline extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final VoidCallback onTapMessage;
  final VoidCallback onTapCall;
  final VoidCallback onTapDirection;
  final VoidCallback onTapCancel;
  final String imageUrl;
  final VoidCallback onTapBarber;
  final String shopName;
  final bool isBlocked;
  final String shopAddress;
  final DateTime createdAt;
  final List<DateTime> slotTimes;
  final int duration;

  const HorizontalIconTimeline({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.onTapMessage,
    required this.onTapCall,
    required this.onTapDirection,
    required this.onTapCancel,
    required this.imageUrl,
    required this.onTapBarber,
    required this.shopName,
    required this.isBlocked,
    required this.shopAddress,
    required this.createdAt,
    required this.slotTimes,
    required this.duration,
  });

  @override
  State<HorizontalIconTimeline> createState() => _HorizontalIconTimelineState();
}

class _HorizontalIconTimelineState extends State<HorizontalIconTimeline> {
  final List<IconData> icons = [
    Icons.event,
    Icons.timer_outlined,
    Icons.cut_outlined,
    Icons.verified,
  ];

  final List<String> labels = [
    'Booked',
    'waiting',
    'InProgress',
    'Finished',
  ];

  @override
  void initState() {
    super.initState();
    context.read<TimelineCubit>().updateTimeline(
          createdAt: widget.createdAt,
          slotTimes: widget.slotTimes,
          duration: widget.duration,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppPalette.whiteClr,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocBuilder<TimelineCubit, TimelineState>(
            builder: (context, state) {
              int currentStep = 0;
              switch (state.currentStep) {
                case TimelineStep.created:
                  currentStep = 0;
                  break;
                case TimelineStep.waiting:
                  currentStep = 1;
                  break;
                case TimelineStep.inProgress:
                  currentStep = 2;
                  break;
                case TimelineStep.completed:
                  currentStep = 3;
                  break;
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(icons.length, (index) {
                      final isActive = index <= currentStep;
                      Color iconColor =
                          isActive ? AppPalette.blackClr : AppPalette.greyClr;
                      if (index == 3) iconColor = AppPalette.greenClr;

                      return Expanded(
                        child: Column(
                          children: [
                            Icon(icons[index], color: iconColor),
                            ConstantWidgets.hight10(context),
                            Text(
                              labels[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: iconColor,
                                fontWeight: isActive
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  ConstantWidgets.hight10(context),
                  Row(
                    children: List.generate(icons.length * 2 - 1, (index) {
                      if (index % 2 == 0) {
                        final stepIndex = index ~/ 2;
                        final isActive = stepIndex <= currentStep;
                        final isCurrentStep = stepIndex == currentStep;

                        return Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppPalette.orengeClr
                                : Colors.grey.shade300,
                            shape: BoxShape.circle,
                            border: isCurrentStep
                                ? Border.all(
                                    color: AppPalette.buttonClr, width: 2)
                                : null,
                          ),
                          child: Center(
                              child: isCurrentStep
                                  ? CircularProgressIndicator(
                                      color: AppPalette.orengeClr,
                                    )
                                  : null),
                        );
                      } else {
                        final lineIndex = index ~/ 2;
                        final isActive = lineIndex < currentStep;

                        return Expanded(
                          child: Container(
                            height: 3,
                            color: isActive
                                ? AppPalette.buttonClr
                                : Colors.grey.shade300,
                          ),
                        );
                      }
                    }),
                  ),
                ],
              );
            },
          ),
          ConstantWidgets.hight10(context),
          ListForBarbers(
            ontap: widget.onTapBarber,
            screenHeight: widget.screenHeight,
            screenWidth: widget.screenWidth,
            imageURl: widget.imageUrl,
            rating: 4,
            shopName: widget.shopName,
            shopAddress: widget.shopAddress,
            isBlocked: widget.isBlocked,
          ),
          ConstantWidgets.hight10(context),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              detailsPageActions(
                context: context,
                screenWidth: widget.screenWidth,
                icon: CupertinoIcons.info_circle_fill,
                onTap: widget.onTapMessage,
                text: 'Details',
              ),
              detailsPageActions(
                context: context,
                screenWidth: widget.screenWidth,
                icon: Icons.phone_in_talk_rounded,
                onTap: widget.onTapCall,
                text: 'Call',
              ),
              detailsPageActions(
                context: context,
                screenWidth: widget.screenWidth,
                icon: Icons.location_on_sharp,
                onTap: widget.onTapDirection,
                text: 'Direction',
              ),
              detailsPageActions(
                context: context,
                colors: AppPalette.redClr,
                screenWidth: widget.screenWidth,
                icon: CupertinoIcons.calendar_badge_minus,
                onTap: widget.onTapCancel,
                text: 'Cancel',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
