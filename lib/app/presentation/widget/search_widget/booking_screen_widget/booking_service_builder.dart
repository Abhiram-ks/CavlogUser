
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_barber_details_bloc/fetch_barber_details_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/booking_cubits/service_selection_cubit/service_selection_cubit.dart';
import 'package:user_panel/app/presentation/widget/search_widget/booking_screen_widget/booking_chips_maker.dart';
import 'package:user_panel/core/themes/colors.dart';
import 'package:user_panel/core/utils/constant/constant.dart';

class BookingServiceBuilder extends StatelessWidget {
  const BookingServiceBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchBarberDetailsBloc, FetchBarberDetailsState>(
      builder: (context, state) {
        if (state is FetchBarberServicesLoading) {
           return SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => ConstantWidgets.width40(context),
            itemCount: 10,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                highlightColor: AppPalette.whiteClr,
                child: ClipChipMaker.build(
                  text: 'HairCut ₹150',
                  actionColor: AppPalette.hintClr,
                  textColor: AppPalette.blackClr,
                  backgroundColor:
                      AppPalette.scafoldClr ?? AppPalette.hintClr,
                  borderColor: AppPalette.greyClr,
                  onTap: () {},
                ),
              );
            },
          ),
        );
        }
        if (state is FetchBarberServicesEmpty) {
         return Center(
            child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Icon(Icons.face_retouching_natural),
                  ConstantWidgets.width40(context),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   
                     Text("Oops! There's nothing here yet."),
                    Text('Still waiting for that first style.'),
                  ],
                ),
              ],
            ),
          );
        } 
        else if (state is FetchBarberServiceSuccess) {
          final services = state.barberServices;
          return BlocBuilder<ServiceSelectionCubit, ServiceSelectionState>(
            builder: (context, serviceState) {
              return SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length,
                  separatorBuilder: (context, index) =>
                      ConstantWidgets.width40(context),
                  itemBuilder: (context, index) {
                    final service = services[index];
                    final isSelected = context
                        .watch<ServiceSelectionCubit>()
                        .isSelected(service.serviceName);
                    return ClipChipMaker.build(
                      text:
                          "${service.serviceName}   ₹ ${service.amount}",
                      actionColor: isSelected
                          ? const Color.fromARGB(255, 227, 229, 234)
                          : Color.fromARGB(255, 248, 239, 216),
                      textColor: AppPalette.blackClr,
                      backgroundColor: isSelected
                          ? Color.fromARGB(255, 248, 239, 216)
                          : AppPalette.whiteClr,
                      borderColor: isSelected
                          ? Color(0xFFFEBA43)
                          : AppPalette.hintClr,
                      onTap: () {
                        context.read<ServiceSelectionCubit>().toggleSelection(service.serviceName,service.amount.toDouble());
                      },
                    );
                  },
                ),
              );
            },
          );
        }
        return Center(
            child: Row(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Icon(Icons.face_retouching_natural,color: AppPalette.redClr,),
                  ConstantWidgets.width40(context),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Oop's Unable to complete the request."),
                     Text('Please try again later.'),
                  ],
                ),
              ],
            ),
          );
      },
    );
  }
}