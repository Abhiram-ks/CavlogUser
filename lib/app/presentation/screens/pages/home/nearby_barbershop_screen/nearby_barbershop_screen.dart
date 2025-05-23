import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../auth/domain/usecases/get_location_usecase.dart';
import '../../../../../../auth/presentation/provider/bloc/location_bloc/location_bloc.dart';
import '../../../../../data/repositories/barbershop_repo.dart';
import '../../../../../domain/repositories/barbershop_services_repo.dart';
import '../../../../provider/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import '../../../../provider/cubit/distance_filtering_cubit/distance_filtering_cubit.dart';
import '../../../../widget/home_widget/nearbyshop_widget/nearby_shop_widget.dart';


class NearbyBarbershopScreen extends StatelessWidget {
  final LatLng currentPosition;

  const NearbyBarbershopScreen({super.key, required this.currentPosition});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SearchInputCubit()),
        BlocProvider(create: (context) => DistanceFilterCubit()),
        BlocProvider(create: (context) => NearbyBarbersBloc(GetNearbyBarberShops(BarberShopRepositoryImpl()))),
        BlocProvider(create: (context) => LocationBloc(GetLocationUseCase()) ..add(GetCurrentLocationEvent())),
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
