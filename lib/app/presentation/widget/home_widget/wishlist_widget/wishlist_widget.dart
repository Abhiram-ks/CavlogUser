
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/custom_loadingscreen_widget.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/constant/constant.dart';
import '../../../../../core/utils/image/app_images.dart';
import '../../../../data/models/barber_model.dart';
import '../../../provider/bloc/fetching_bloc/fetch_widhlists_bloc/fetch_wishlists_bloc.dart';
import '../../../screens/pages/search/detail_screen/detail_screen.dart';
import '../../search_widget/search_screen_widget/custom_cards_barberlist.dart';

class WishlistScreenWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  const WishlistScreenWidget(
      {super.key, required this.screenHeight, required this.screenWidth});

  @override
  State<WishlistScreenWidget> createState() => _WishlistScreenWidgetState();
}

class _WishlistScreenWidgetState extends State<WishlistScreenWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchWishlistsBloc>().add(FetchWishlistsRequst());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchWishlistsBloc, FetchWishlistsState>(
      builder: (context, state) {
        if (state is FetchWishlistsLoding) {
          return SizedBox(
            height: widget.screenHeight * .7,
            child: LoadingScreen(
              screenHeight: widget.screenHeight,
              screenWidth: widget.screenWidth,
            ),
          );
        } else if (state is FetchWishlistsEmpty) {
           return Center(
             child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstantWidgets.hight50(context),
                Icon(Icons.heart_broken,color: AppPalette.redClr,size: 50,),
                Text("Something’s missing… maybe your favorites?"),
                Text('It’s time to turn intent into impact.')
              ],
                       ),
           );
        } 
         else if (state is FetchWishlistsLoaded) {
          final List<BarberModel> barbers = state.barbers;

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: barbers.length,
            itemBuilder: (context, index) {
              final barber = barbers[index];
              return ListForBarbers(
                ontap: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailBarberScreen(barberId: barber.uid),
                    ),
                  );
                },
                screenHeight: widget.screenHeight,
                screenWidth: widget.screenWidth,
                imageURl: barber.image ?? AppImages.barberEmpty,
                rating: barber.rating ?? 0.0,
                shopName: barber.ventureName,
                shopAddress: barber.address,
                isBlocked: barber.isblok,
              );
            },
            separatorBuilder: (context, index) => ConstantWidgets.hight10(context),
          );
        }

           return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ConstantWidgets.hight50(context),
              Center( child:Icon(Icons.heart_broken,color: AppPalette.redClr,size: 50,)),
              Text("Looks like there was an issue."),
             Text("No results matched your request. Please try again."),
             IconButton(onPressed: (){
               context.read<FetchWishlistsBloc>().add(FetchWishlistsRequst());
             }, icon: Icon(Icons.refresh_rounded))
            ],
          );
      },
    );
  }
}
