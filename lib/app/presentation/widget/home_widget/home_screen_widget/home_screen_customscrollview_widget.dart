import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/auth/presentation/provider/bloc/location_bloc/location_bloc.dart';
import 'package:user_panel/auth/presentation/widget/location_widget/location_formalt_converter_widget.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../provider/bloc/fetching_bloc/fetch_user_bloc/fetch_user_bloc.dart';
import '../../../screens/pages/home/home_screen.dart';
import '../../profile_widget/profile_scrollable_section.dart';
import 'home_screen_body_widget.dart';

class HomePageCustomScrollViewWidget extends StatelessWidget {
  const HomePageCustomScrollViewWidget({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
  });

  final double screenHeight;  
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverAppBar(
          backgroundColor: AppPalette.blackClr,
          expandedHeight: screenHeight * 0.13,
          pinned: true,
          flexibleSpace: LayoutBuilder(builder: (context, constraints) {
            bool isCollapsed = constraints.biggest.height <=
                kToolbarHeight + MediaQuery.of(context).padding.top;
            return FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              title: isCollapsed
                  ? Text(
                      'C Λ V L O G',
                      style: TextStyle(color: AppPalette.whiteClr),
                    )
                  : Text(''),
              background: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<LocationBloc, LocationState>(
                            builder: (context, state) {
                              if (state is LocationLoading) {
                                return profileviewWidget(
                                  screenWidth,
                                  context,
                                  Icons.location_on,
                                  'Loading...',
                                  AppPalette.redClr,
                                );
                              } else if (state is LocationLoaded) {
                                return FutureBuilder<String>(
                                  future: getFormattedAddress(
                                    state.position.latitude,
                                    state.position.longitude,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return profileviewWidget(
                                        screenWidth,
                                        context,
                                        Icons.location_on,
                                        'Loading...',
                                        AppPalette.redClr,
                                      );
                                    } else if (snapshot.hasError) {
                                      return profileviewWidget(
                                        screenWidth,
                                        context,
                                        Icons.location_on,
                                        'Error fetching location',
                                        AppPalette.redClr,
                                      );
                                    } else if (snapshot.hasData) {
                                      return profileviewWidget(
                                        screenWidth,
                                        context,
                                        Icons.location_on,
                                        snapshot.data ?? 'Unknown location',
                                        AppPalette.redClr,
                                      );
                                    }
                                    return profileviewWidget(
                                      screenWidth,
                                      context,
                                      Icons.location_on,
                                      'Location not available',
                                      AppPalette.redClr,
                                    );
                                  },
                                );
                              }
                              return profileviewWidget(
                                screenWidth,
                                context,
                                Icons.location_on,
                                'Error fetching location',
                                AppPalette.redClr,
                              );
                            },
                          ),
                          ConstantWidgets.hight10(context),
                          BlocBuilder<FetchUserBloc, FetchUserState>(
                            builder: (context, state) {
                              if (state is FetchUserLoading) {
                                return Text(
                                'Loading...',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                              } else if (state is FetchUserLoaded ){
                                return Text(
                               'Hello, ${state.user.userName}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                              }return Text(
                                'Faching Failure.',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                              
                            },
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
                              Navigator.pushNamed(context, AppRoutes.wallet);
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
                              Navigator.pushNamed(context, AppRoutes.wishList);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        SliverToBoxAdapter(
          child: HomeScreenBodyWIdget(
              screenHeight: screenHeight, screenWidth: screenWidth),
        ),
      ],
    );
  }
}
