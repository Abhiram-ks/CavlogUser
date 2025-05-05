
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/image/app_images.dart';
import '../../../provider/bloc/fetching_bloc/fetch_barber_bloc/fetch_barber_id_bloc.dart';
import '../../../screens/pages/search/detail_screen/detail_screen.dart';
import '../details_screen_widget/details_screen_actionbuttos.dart';
import 'payment_top_portion_detail_widget.dart';

class PaymentTopPortion extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String barberUId;
  const PaymentTopPortion(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.barberUId});

  @override
  State<PaymentTopPortion> createState() => _PaymentTopPortionState();
}

class _PaymentTopPortionState extends State<PaymentTopPortion> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchBarberIdBloc>().add(FetchBarberDetailsAction(widget.barberUId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.screenHeight * 0.28,
      width: widget.screenWidth,
      color: AppPalette.orengeClr,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppPalette.greyClr.withAlpha((0.19 * 255).toInt()),
                BlendMode.modulate,
              ),
              child: Image.asset(
                AppImages.loginImageBelow,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              top: 4,
              left: 10,
              child: iconsFilledDetail(
                icon: Icons.arrow_back,
                forgroudClr: AppPalette.whiteClr,
                context: context,
                borderRadius: 100,
                padding: 10,
                fillColor: AppPalette.blackClr.withAlpha((0.45 * 255).toInt()),
                onTap: () => Navigator.pop(context),
              )),
          Center(
            child: BlocBuilder<FetchBarberIdBloc, FetchBarberIdState>(
             builder: (context, state) {
              if(state is FetchBarberDetailsSuccess){
              final barber = state.barberServices;
              return ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                    height: widget.screenHeight * 0.13,
                    width: widget.screenWidth * 0.77,
                    color: AppPalette.blackClr.withAlpha((0.27 * 255).toInt()),

                    alignment: Alignment.center,
                          child: InkWell(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailBarberScreen(barberId: barber.uid,))),
                            child: paymentSectionBarberData(
                                context: context,
                                imageURl: barber.image ?? AppImages.barberEmpty,
                                shopName: barber.ventureName,
                                shopAddress:barber.address,
                                ratings: barber.rating ?? 0,
                                screenHeight: widget.screenHeight,
                                screenWidth: widget.screenWidth),
                          ),
                        )
                       ));
                        }return Shimmer.fromColors(
                            baseColor: Colors.grey[300] ?? AppPalette.greyClr,
                             highlightColor: AppPalette.whiteClr,
                           child: ClipRRect(
                           borderRadius: BorderRadius.circular(13),
                               child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                  child: Container(
                               height: widget.screenHeight * 0.13,
                                 width: widget.screenWidth * 0.77,
                              color: AppPalette.hintClr.withAlpha((0.5 * 255).toInt()),
                                  alignment: Alignment.center,
                             child: paymentSectionBarberData(
                                context: context,
                                imageURl: AppImages.barberEmpty,
                                shopName: 'Automatic trading mechanics',
                                shopAddress: 'Ambalawayal sulthan bathery eranakulam',
                                ratings: 3,
                                screenHeight: widget.screenHeight,
                                screenWidth: widget.screenWidth),
                           ),
                         )));
                      },
                    )
          )
        ],
      ),
    );
  }
}