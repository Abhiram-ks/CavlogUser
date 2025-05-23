
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../auth/presentation/provider/bloc/searchlocation_bloc/serchlocaton_bloc.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../../core/utils/debouncer/debouncer.dart';
import '../../../provider/cubit/distance_filtering_cubit/distance_filtering_cubit.dart';

class NearbyShopSearchFiledWidget extends StatelessWidget {
  const NearbyShopSearchFiledWidget({
    super.key,
    required this.searchController,
    required this.debouncer,
    required MapController mapController,
    required this.screenHeight
  }) : _mapController = mapController;

  final TextEditingController searchController;
  final Debouncer debouncer;
  final MapController _mapController;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
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
            prefixIcon: BlocBuilder<SearchInputCubit, bool>(
              builder: (context, isEmpty) {
                return isEmpty
                    ? const Icon(Icons.search)
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          FocusScope.of(context).unfocus();
                          context
                              .read<SerchlocatonBloc>()
                              .add(SearchLocationEvent(''));
                        },
                      );
              },
            ),
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
                          _mapController.move(LatLng(lat, lon), 15.0);
                        });
                      },
                    );
                  },
                ),
              );
            } else if (state is SearchLocationError) {
              return Container(
                width: double.infinity,
                height: screenHeight * .06,
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
                        'Search for ${searchController.text}',
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
    );
  }
}