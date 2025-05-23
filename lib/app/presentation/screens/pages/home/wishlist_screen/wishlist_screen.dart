import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_panel/app/data/repositories/fetch_barber_repo.dart';
import 'package:user_panel/app/data/repositories/fetch_wishlist_repo.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_widhlists_bloc/fetch_wishlists_bloc.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import '../../../../../../core/themes/colors.dart';
import '../../../../../../core/utils/constant/constant.dart';
import '../../../../widget/home_widget/wishlist_widget/wishlist_widget.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FetchWishlistsBloc(
          FetchWishlistRepositoryImpl(FetchBarberRepositoryImpl())),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.hintClr,
            child: SafeArea(
                child: Scaffold(
              appBar: CustomAppBar(),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("My Top Picks", style: GoogleFonts.plusJakartaSans(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        ConstantWidgets.hight10(context),
                        Text( 'Keep track of your favorite barbershops — browse your top picks, revisit saved spots, and book again with ease.',
                        ),
                        ConstantWidgets.hight20(context)
                      ],
                    ),
                  ),
                  Expanded(
                      child: SingleChildScrollView(
                          child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                    child: WishlistScreenWidget(
                        screenHeight: screenHeight, screenWidth: screenWidth),
                  )))
                ],
              ),
            )),
          );
        },
      ),
    );
  }
}