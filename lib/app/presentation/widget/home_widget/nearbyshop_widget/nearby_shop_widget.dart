
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:user_panel/app/presentation/widget/home_widget/nearbyshop_widget/nearby_barbershop_map_widget.dart';
import 'package:user_panel/app/presentation/widget/home_widget/nearbyshop_widget/nearby_shop_details_widget.dart';
import 'package:user_panel/app/presentation/widget/home_widget/nearbyshop_widget/nerby_barbershop_dropdown_widget.dart';
import '../../../../../core/common/custom_formfield_widget.dart';
import '../../../../../core/utils/debouncer/debouncer.dart';
import '../../../provider/bloc/nearby_barbers_bloc/nearby_barbers_bloc.dart';
import '../../../provider/cubit/distance_filtering_cubit/distance_filtering_cubit.dart';

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

    searchController.addListener(() {
      context.read<SearchInputCubit>().update(searchController.text);
    });

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
        NearbyShopMapWidget(widget: widget, mapController: _mapController, searchController: searchController, debouncer: debouncer),
        nearbyShopDrpdownWIdget(context, widget.screenHeight, widget.screenWidth),
        nerbyWorkShopDetailsWIdget(screenHeight: widget.screenHeight, screenWidth: widget.screenWidth),
      ],
    );
  }
}
