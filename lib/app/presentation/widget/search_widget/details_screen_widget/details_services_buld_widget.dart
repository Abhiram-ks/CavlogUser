
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetching_bloc/fetch_barber_details_bloc/fetch_barber_details_bloc.dart';

class DetilServiceWidget extends StatelessWidget {
  final double screenWidth;
  const DetilServiceWidget({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchBarberDetailsBloc, FetchBarberDetailsState>
    (builder: (context, state) {
      if (state is FetchBarberServicesLoading) {
        return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ConstantWidgets.hight30(context),
                      SpinKitCircle(color: AppPalette.orengeClr),
                      ConstantWidgets.hight10(context),
                      Text('Just a moment...'),
                      Text('Please wait while we process your request'),
                    ],
                  ),
                );
       } 
      else if (state is FetchBarberServiceSuccess) {
       final services = state.barberServices;

       return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: screenWidth * .08),
          child: Column(
            children: [
              ListView.separated(
                itemCount: services.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text( service.serviceName,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold) ),
                          Row(
                            children: [
                               Text( "₹ ",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppPalette.greenClr)),
                               Text( "${service.amount} ",style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))
                            ],
                          )
                    ],
                  );
                }, 
                separatorBuilder: (context, index) => ConstantWidgets.hight10(context), 
                ),
                ConstantWidgets.hight50(context),
                ConstantWidgets.hight50(context),
            ],
            
          ),
          ),
       );
      }
      else if (state is FetchBarberServicesEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.face_retouching_natural, size: 50,),
              ConstantWidgets.hight20(context),
              Text('Still waiting for that first style.'),
            ],
          ),
        );
      }
                   return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstantWidgets.hight30(context),
                    Icon(
                      Icons.cloud_off_outlined,
                      color: AppPalette.blackClr,
                      size: 50,
                    ),
                    Text("Oop's Unable to complete the request."),
                    Text('Please try again later.'),
                  ],
                ),
              );
    },);
  }
}
