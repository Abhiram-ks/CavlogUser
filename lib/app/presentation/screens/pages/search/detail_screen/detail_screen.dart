import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/data/datasources/wishlist_remote_datasources.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_barber_bloc/fetch_barber_id_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_barber_details_bloc/fetch_barber_details_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_posts_bloc/fetch_posts_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/wishlist_function_cubit/wishlist_function_cubit.dart';
import 'package:user_panel/core/routes/routes.dart';
import '../../../../../../core/common/custom_actionbutton_widget.dart';
import '../../../../../data/repositories/fetch_barber_repo.dart';
import '../../../../../data/repositories/fetch_wishlist_repo.dart';
import '../../../../provider/cubit/fetch_wishlist_singlebarber_cubit/fetch_wishlist_singlebarber_cubit.dart';
import '../../../../widget/search_widget/details_screen_widget/details_screen_builder_widget.dart';
class DetailBarberScreen extends StatefulWidget {
  final String barberId;
  const DetailBarberScreen({
    super.key,
    required this.barberId,
  });

  @override
  State<DetailBarberScreen> createState() => _DetailBarberScreenState();
}

class _DetailBarberScreenState extends State<DetailBarberScreen> {
  late final List<String> imageList;
  @override
  void initState() {
    super.initState();
    context.read<FetchBarberIdBloc>().add(FetchBarberDetailsAction(widget.barberId));
    context.read<FetchPostsBloc>().add(FetchPostRequest(barberId: widget.barberId));
    context.read<FetchBarberDetailsBloc>() .add(FetchBarberServicesRequested(widget.barberId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
  create: (context) {
    final cubit = FetchWishlistSinglebarberCubit(FetchWishlistRepositoryImpl(FetchBarberRepositoryImpl()));
    cubit.listenToBarberLikedStatus(widget.barberId);
    return cubit;
  }),
        BlocProvider(create: (context) => WishlistFunctionCubit(WishlistRemoteDatasourcesImpl())),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Scaffold(
              body: DetailScreenWidgetBuilder(screenHeight: screenHeight, screenWidth: screenWidth),
              floatingActionButton: Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.09),
                child: ButtonComponents.actionButton(
                  screenWidth: screenWidth,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.booking,
                      arguments: widget.barberId),
                  label: 'Booking Now',
                  screenHeight: screenHeight,
                ),
              ));
        },
      ),
    );
  }
}
