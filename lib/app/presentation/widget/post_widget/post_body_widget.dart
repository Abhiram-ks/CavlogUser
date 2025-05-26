

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/data/models/post_with_barber_model.dart';
import 'package:user_panel/app/domain/usecases/data_listing_usecase.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_post_with_barber_bloc/fetch_post_with_barber_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/post_like_cubit/post_like_cubit.dart';
import 'package:user_panel/app/presentation/screens/pages/chat/individual_chat_screen.dart';
import 'package:user_panel/app/presentation/screens/pages/search/detail_screen/detail_screen.dart';
import 'package:user_panel/app/presentation/widget/post_widget/post_card_widget.dart';
import 'package:user_panel/auth/data/datasources/auth_local_datasource.dart' show SecureStorageService;
import 'package:user_panel/core/themes/colors.dart';
import 'package:user_panel/core/utils/constant/constant.dart';

import '../../../../core/utils/image/app_images.dart';
import '../../provider/cubit/share_post_cubit/share_post_cubit.dart';

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
          return RefreshIndicator(
            color: AppPalette.buttonClr,
            backgroundColor: AppPalette.whiteClr,
            onRefresh: () async {
              context
                  .read<FetchPostWithBarberBloc>()
                  .add(FetchPostWithBarberRequest());
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: model.length,
              itemBuilder: (context, index) {
                final data = model[index];
                final formattedDate = formatDate(data.post.createdAt);
                String formattedStartTime =   formatTimeRange(data.post.createdAt);

                return PostScreenMainWidget(
                  screenHeight: widget.screenHeight,
                  heightFactor: widget.heightFactor,
                  screenWidth: widget.screenWidth,
                  shopName: data.barber.ventureName,
                  description: data.post.description,
                  favoriteColor: data.post.likes.contains(state.userId)
                      ? AppPalette.redClr
                      : AppPalette.blackClr,
                  favoriteIcon: data.post.likes.contains(state.userId)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  likes: data.post.likes.length,
                  location: data.barber.address,
                  postUrl: data.post.imageUrl,
                  shopUrl: data.barber.image ?? AppImages.loginImageAbove,
                  chatOnTap: () async {
                    final credentials =  await SecureStorageService.getUserCredentials();
                    final String? userId = credentials['userId'];
                    if (userId == null || userId.isEmpty) {
                      return;
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.push(context, MaterialPageRoute(builder: (context) => IndividualChatScreen(userId: userId, barberId: data.barber.uid)));
                  },
                  shareOnTap: () {
                    context.read<ShareCubit>().sharePost(
                          text: data.post.description,
                          ventureName: data.barber.ventureName,
                          location: data.barber.address,
                          imageUrl: data.post.imageUrl,
                        );
                  },
                  likesOnTap: () {
                    context.read<LikePostCubit>().toggleLike(
                        barberId: data.barber.uid,
                        postId: data.post.postId,
                        userId: state.userId,
                        currentLikes: data.post.likes);
                  },
                  profilePage: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetailBarberScreen(barberId: data.barber.uid)),
                  ),
                  dateAndTime: '$formattedDate at $formattedStartTime',
                );
              },
              separatorBuilder: (context, index) =>
                  ConstantWidgets.hight10(context),
            ),
          );
        } else if (state is FetchPostWithBarberEmpty) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_size_select_actual_outlined,
                  color: AppPalette.hintClr,
                ),
                Text('No Posts Yet!'),
                Text('No posts yet. Fresh styles coming soon!',
                    style: TextStyle(color: AppPalette.greyClr)),
                IconButton(
                    onPressed: () {
                      context
                          .read<FetchPostWithBarberBloc>()
                          .add(FetchPostWithBarberRequest());
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: AppPalette.blueClr,
                    ))
              ],
            ),
          );
        } else if (state is FetchPostWithBarberFailure) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.image_not_supported_rounded,
                  color: AppPalette.hintClr,
                ),
                Text(
                  'Something went wrong!',
                ),
                Text('Oops! That didn’t work. Please try again',
                    style: TextStyle(color: AppPalette.greyClr)),
                IconButton(
                    onPressed: () {
                      context
                          .read<FetchPostWithBarberBloc>()
                          .add(FetchPostWithBarberRequest());
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: AppPalette.redClr,
                    ))
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
                screenHeight: widget.screenHeight,
                heightFactor: widget.heightFactor,
                screenWidth: widget.screenWidth,
                chatOnTap: () {},
                description: 'Not only did it reduce effort, but it also gave me a clearer structure I could reuse across other components. I’ve attached a screenshot of the modified widget and how it now dynamically adapts to different screen sizes.',
                favoriteColor: AppPalette.redClr,
                favoriteIcon: Icons.favorite,
                likes: 120,
                likesOnTap: () {},
                location:
                    'Wayanad,Kerala(sulthan Bathery), india, mangalam carp',
                postUrl: '',
                profilePage: () {},
                shareOnTap: () {},
                shopName: 'Skilink- Baldes & Fades',
                shopUrl: '',
                dateAndTime: '27-September-2025 10:16 AM',
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