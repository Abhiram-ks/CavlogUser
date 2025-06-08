import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/data/datasources/firebase_review_datasource.dart';
import 'package:user_panel/app/data/repositories/barbershop_repo.dart';
import 'package:user_panel/app/data/repositories/fetch_banner_repo.dart';
import 'package:user_panel/app/presentation/provider/bloc/take_review_bloc/take_review_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import '../../../../../auth/domain/usecases/get_location_usecase.dart';
import '../../../../../auth/presentation/provider/bloc/location_bloc/location_bloc.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../data/repositories/fetch_barber_repo.dart';
import '../../../../data/repositories/fetch_booking_with_barber_model.dart';
import '../../../../domain/repositories/barbershop_services_repo.dart';
import '../../../provider/bloc/fetching_bloc/fetch_banners_bloc/fetch_banners_bloc.dart';
import '../../../provider/bloc/fetching_bloc/fetch_booking_with_barber_bloc/fetch_booking_with_barber_bloc.dart';
import '../../../widget/home_widget/home_screen_widget/home_screen_customscrollview_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          final fetchBarberRepo = FetchBarberRepositoryImpl();
          final barberService = BarberService(fetchBarberRepo);
          final repository = FetchBookingAndBarberRepositoryImpl(barberService);

          return FetchBookingWithBarberBloc(repository);
        }),
        BlocProvider(create: (_) => FetchBannersBloc(FetchBannerRepositoryImpl())),
        BlocProvider(create: (_) => NearbyBarbersBloc(GetNearbyBarberShops(BarberShopRepositoryImpl()))),
        BlocProvider(create: (_) => LocationBloc(GetLocationUseCase())..add(GetCurrentLocationEvent())),
        BlocProvider(create: (_) => TakeReviewBloc(ReviewRemoteDatasourcesImpl()))
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
                body: HomePageCustomScrollViewWidget(
                    screenHeight: screenHeight, screenWidth: screenWidth),
              ),
            ),
          );
        },
      ),
    );
  }
}

