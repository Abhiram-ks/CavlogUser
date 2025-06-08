
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/domain/usecases/direction_navigation.dart';
import 'package:user_panel/app/domain/usecases/geo_coding_helper_usecase.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_banners_bloc/fetch_banners_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_booking_with_barber_bloc/fetch_booking_with_barber_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/take_review_bloc/take_review_bloc.dart';
import 'package:user_panel/app/presentation/screens/pages/home/cancel_booking_screen/cancel_booking_screen.dart';
import 'package:user_panel/app/presentation/screens/settings/settings_subscreens/my_booking_detail_screen.dart';
import 'package:user_panel/app/presentation/widget/home_widget/home_screen_widget/home_screen_nearby.dart';
import 'package:user_panel/app/presentation/widget/home_widget/home_screen_widget/home_timeline_customwidget.dart';
import 'package:user_panel/app/presentation/widget/search_widget/details_screen_widget/details_imagescroll_widget.dart';
import 'package:user_panel/app/presentation/widget/search_widget/rating_review_widget/reviews_upload_bottomsheet.dart';
import 'package:user_panel/auth/presentation/provider/bloc/location_bloc/location_bloc.dart';
import 'package:user_panel/core/themes/colors.dart';

import '../../../../../core/common/custom_snackbar_widget.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../../core/utils/image/app_images.dart';
import '../../../screens/pages/search/detail_screen/detail_screen.dart';
import '../../search_widget/details_screen_widget/details_call_helper_function.dart';

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
      context.read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberFileterRequest(filtering: 'Pending'));
      context.read<TakeReviewBloc>().add(TakeReviewFunction());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TakeReviewBloc, TakeReviewState>(
      listener: (context, state) {
        if (state is TakeReviewSuccess) {
          final barberId = state.barberId;
          showReviewBottomSheet(context, barberId,widget.screenHeight, widget.screenWidth);
        }
      },
      child: SingleChildScrollView(
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
                        imageList: [
                          AppImages.barberEmpty,
                          AppImages.barberEmpty
                        ],
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
              padding:EdgeInsets.symmetric(horizontal: widget.screenWidth * .04),
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
                  Column(
                    children: [
                      Text(
                        'Track Booking Status',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ConstantWidgets.hight10(context),
                  BlocBuilder<FetchBookingWithBarberBloc,  FetchBookingWithBarberState>(
                    builder: (context, state) {
                      if (state is FetchBookingWithBarberLoading) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                          highlightColor: AppPalette.whiteClr,
                          child: HorizontalIconTimelineHelper(
                            screenWidth: MediaQuery.of(context).size.width,
                            screenHeight: MediaQuery.of(context).size.height,
                            createdAt: DateTime.parse('2025-05-05T15:10:38+05:30'),
                            duration: 90,
                            bookingId: '',
                            slotTimes: [
                              DateTime.parse('2025-05-12T08:00:00+05:30'),
                              DateTime.parse('2025-05-12T08:45:00+05:30'),
                            ],
                            onTapInformation: () {},
                            onTapCall: () {},
                            onTapDirection: () {},
                            onTapCancel: () {},
                            imageUrl: AppImages.barberEmpty,
                            onTapBarber: () {},
                            rating: 4,
                            shopName:
                                'Masterpiece - The Classic Cut Barbershop',
                            isBlocked: false,
                            shopAddress:
                                '123 Kingsway Avenue, Downtown District, Springfield, IL 62704',
                          ),
                        );
                      }
                       else if (state is FetchBookingWithBarberEmpty) {
                        return Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ConstantWidgets.hight30(context),
                                Icon(Icons.cloud_off_outlined,color: AppPalette.blackClr,size: 50,),
                                Text('No Bookings Yet!', style: TextStyle(color: AppPalette.orengeClr)),
                                Text( "No activity found — time to take action!"),
                                ConstantWidgets.hight30(context),
                              ]),
                        );
                      } 
                      else if (state is FetchBookingWithBarberLoaded) {
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemCount: state.combo.length,
                          separatorBuilder: (_, __) =>
                              ConstantWidgets.hight10(context),
                          itemBuilder: (context, index) {
                            final booking = state.combo[index];

                            return HorizontalIconTimelineHelper(
                              screenWidth: MediaQuery.of(context).size.width,
                              screenHeight: MediaQuery.of(context).size.height,
                              createdAt: booking.booking.createdAt,
                              duration: booking.booking.duration,
                              slotTimes: booking.booking.slotTime,
                              bookingId: booking.booking.bookingId ?? '',
                              rating: booking.barber.rating ?? 0.0,
                              onTapInformation: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MyBookingDetailScreen(
                                              docId: booking.booking.bookingId!,
                                              barberId:
                                                  booking.booking.barberId,
                                              userId: booking.booking.userId),
                                    ));
                              },
                              onTapCall: () {
                                CallHelper.makeCall(
                                    booking.barber.phoneNumber, context);
                              },
                              onTapDirection: () async {
                                try {
                                  final position = await context
                                      .read<LocationBloc>()
                                      .getLocationUseCase();
                                  final barberLatLng =
                                      await GeocodingHelper.addressToLatLng(
                                          booking.barber.address);

                                  await MapHelper.openGoogleMaps(
                                    sourceLat: position.latitude,
                                    sourceLng: position.longitude,
                                    destLat: barberLatLng.latitude,
                                    destLng: barberLatLng.longitude,
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  CustomeSnackBar.show(
                                    context: context,
                                    title: 'Unable to Access Directions',
                                    description:
                                        'Oops! Something went wrong while fetching the route. Please try again shortly.',
                                    titleClr: AppPalette.blackClr,
                                  );
                                }
                              },
                              onTapCancel: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CancelBookingScreen(
                                      booking: booking.booking,
                                    ),
                                  )),
                              imageUrl:
                                  booking.barber.image ?? AppImages.barberEmpty,
                              onTapBarber: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailBarberScreen(
                                            barberId: booking.barber.uid,
                                          ))),
                              shopName: booking.barber.ventureName,
                              isBlocked: booking.barber.isblok,
                              shopAddress: booking.barber.address,
                            );
                          },
                        );
                      }
                      return Center(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstantWidgets.hight30(context),
                              Icon(Icons.cloud_off_outlined,color: AppPalette.blackClr,size: 50,),
                              Text('Oops! Something went wrong!',style: TextStyle(color: AppPalette.redClr)),
                              Text(  "We're having trouble processing your request."),
                              IconButton(onPressed: (){
                                context .read<FetchBookingWithBarberBloc>().add(FetchBookingWithBarberFileterRequest(filtering: 'Pending'));
                              }, icon: Icon(Icons.refresh_rounded)),
                              ConstantWidgets.hight30(context),
                            ]),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}