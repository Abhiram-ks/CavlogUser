import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/widget/search_widget/details_screen_widget/details_imagescroll_widget.dart';
import 'package:user_panel/app/presentation/widget/search_widget/details_screen_widget/details_loading_widget.dart';
import 'package:user_panel/core/themes/colors.dart';

import '../../../../../core/utils/constant/constant.dart';
import '../../../../../core/utils/image/app_images.dart';
import '../../../../data/models/barber_model.dart' show BarberModel;
import '../../../provider/bloc/fetching_bloc/fetch_barber_bloc/fetch_barber_id_bloc.dart';
import '../../../provider/cubit/tab_cubit/tab_cubit.dart';
import '../rating_review_widget/reviews_rating_widget.dart';
import 'details_post_widget.dart';
import 'details_services_buld_widget.dart';
import 'details_top_portion_widget.dart';

class DetailScreenWidgetBuilder extends StatelessWidget {
  const DetailScreenWidgetBuilder({
    super.key,
    required this.screenHeight,
    required this.screenWidth,
    required this.barberId,
  });

  final double screenHeight;
  final String barberId;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchBarberIdBloc, FetchBarberIdState>(
      builder: (context, state) {
        if (state is FetchBarberDetailsLoading) {
          BarberModel barber = BarberModel(
              uid:'',
              barberName:'barberNamei',
              ventureName:'Cavlog - Executing smarter, Manaing better',
              phoneNumber: 'phoneNumber',
              address:'221B Baker street Santa clau 101 saint NIcholas Dive North Pole, Landon -  99705',
              email: 'cavlogenoia@gmail.com',
              isVerified: true,
              isblok: false);
          return detailshowWidgetLoading(
              barber, screenHeight, screenWidth, context);
        } else if (state is FetchBarberDetailsSuccess) {
          final barber = state.barberServices;
          return Column(
            children: [
              ImageScolingWidget(
                  imageList: [
                    barber.image ?? AppImages.barberEmpty,
                    barber.detailImage ?? AppImages.barberEmpty
                  ],
                  show: true,
                  screenHeight: screenHeight,
                  screenWidth: screenWidth),
              DetailTopPortionWidget(screenWidth: screenWidth, barber: barber),
              ConstantWidgets.hight30(context),
              BlocProvider(
                create: (context) => TabCubit(),
                child: Expanded(
                  child: Column(
                    children: [
                      BlocBuilder<TabCubit, int>(
                        builder: (context, selectedIndex) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(3, (index) {
                              final tabs = ['Post', 'Services', 'review'];
                              return GestureDetector(
                                onTap: () =>
                                    context.read<TabCubit>().changeTab(index),
                                child: Column(
                                  children: [
                                    Text(
                                      tabs[index],
                                      style: TextStyle(
                                        fontWeight: selectedIndex == index
                                            ? FontWeight.w900
                                            : FontWeight.bold,
                                        color: selectedIndex == index
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                    ),
                                    ConstantWidgets.hight20(context)
                                  ],
                                ),
                              );
                            }),
                          );
                        },
                      ),
                      Expanded(
                        child: BlocBuilder<TabCubit, int>(
                          builder: (context, selectedIndex) {
                            return IndexedStack(
                              index: selectedIndex,
                              children: [
                                DetailPostWidget(),
                                DetilServiceWidget(screenWidth: screenWidth),
                                DetailsReviewWidget(
                                    barber: barber,
                                    screenHight: screenHeight,
                                    screenWidth: screenWidth)
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                color: AppPalette.blackClr,
                size: 50,
              ),
              Text("Oop's Unable to complete the request."),
              Text('Please try again later.'),
              IconButton(
                  onPressed: () {
                    context
                        .read<FetchBarberIdBloc>()
                        .add(FetchBarberDetailsAction(barberId));
                  },
                  icon: Icon(Icons.refresh_rounded))
            ],
          ),
        );
      },
    );
  }
}
