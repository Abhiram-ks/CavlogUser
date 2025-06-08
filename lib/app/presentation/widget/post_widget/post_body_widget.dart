import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/data/models/post_with_barber_model.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_post_with_barber_bloc/fetch_post_with_barber_bloc.dart';
import 'package:user_panel/app/presentation/widget/post_widget/post_card_widget.dart';
import 'package:user_panel/app/presentation/widget/post_widget/post_succes_state_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import 'package:user_panel/core/utils/constant/constant.dart';

class PostScreenWidget extends StatefulWidget {
  const PostScreenWidget({
    super.key,
    required this.screenHeight,
    required this.heightFactor,
    required this.screenWidth,
  });

  final double screenHeight;
  final double heightFactor;
  final double screenWidth;

  @override
  State<PostScreenWidget> createState() => _PostScreenWidgetState();
}

class _PostScreenWidgetState extends State<PostScreenWidget> {
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FetchPostWithBarberBloc>().add(FetchPostWithBarberRequest());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchPostWithBarberBloc, FetchPostWithBarberState>(
      builder: (context, state) {
         if (state is FetchPostWithBarberLoaded) {
          final List<PostWithBarberModel> model = state.model;
          return postBlocSuccessStateBuilder(commentController: commentController, context: context, heightFactor: widget.heightFactor,model: model, screenHeight: widget.screenHeight, screenWidth: widget.screenWidth,state: state);
        }
          if (state is FetchPostWithBarberEmpty) {
               return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off_sharp,color: AppPalette.blackClr,size: 50,),
                const Text('No Posts Yet!',style: TextStyle(fontWeight: FontWeight.bold),),
                Text('No posts yet. Fresh styles coming soon!',
                    style: TextStyle(color: AppPalette.greyClr)),
              ],
            ),
          );
        } 
        else if (state is FetchPostWithBarberFailure) {
                   return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off,  color: AppPalette.blackClr,size: 50,),
                const Text('Something went wrong!',style: TextStyle(fontWeight: FontWeight.bold),),
                Text('Oops! That didn’t work. Please try again',
                    style: TextStyle(color: AppPalette.greyClr)),
                IconButton(
                  onPressed: () {
                    context
                        .read<FetchPostWithBarberBloc>()
                        .add(FetchPostWithBarberRequest());
                  },
                  icon: Icon(Icons.refresh, color: AppPalette.redClr),
                )
              ],
            ),
          );
        }
     

        return Shimmer.fromColors(
          baseColor: Colors.grey[300] ?? AppPalette.greyClr,
          highlightColor: AppPalette.whiteClr,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return PostScreenMainWidget(
                isLiked: false,
                screenHeight: widget.screenHeight,
                heightFactor: widget.heightFactor,
                screenWidth: widget.screenWidth,
                chatOnTap: () {},
                description: 'Loading...',
                favoriteColor: AppPalette.redClr,
                favoriteIcon: Icons.favorite_border,
                likes: 0,
                likesOnTap: () {},
                commentOnTap: () {},
                location: 'Loading...',
                postUrl: '',
                profilePage: () {},
                shareOnTap: () {},
                shopName: 'Loading...',
                shopUrl: '',
                dateAndTime: '',
              );
            },
            separatorBuilder: (context, index) =>
                ConstantWidgets.hight10(context),
          ),
        );
      },
    );
  }

}
