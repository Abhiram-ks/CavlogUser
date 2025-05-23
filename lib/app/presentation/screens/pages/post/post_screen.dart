import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/data/repositories/fetch_barber_repo.dart';
import 'package:user_panel/app/data/repositories/fetch_post_with_barber_mode.dart';
import 'package:user_panel/app/domain/repositories/share_function_services.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_post_with_barber_bloc/fetch_post_with_barber_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/share_post_cubit/share_post_cubit.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import 'package:user_panel/core/utils/constant/constant.dart';
import 'package:user_panel/core/utils/image/app_images.dart';
import 'package:readmore/readmore.dart';

import '../../../../../core/common/custom_imageshow_widget.dart';
import '../../../../data/models/post_with_barber_model.dart';
import '../../../../domain/usecases/data_listing_usecase.dart';
import '../../../provider/cubit/post_like_cubit/post_like_cubit.dart';
import '../search/detail_screen/detail_screen.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => FetchPostWithBarberBloc(PostService(FetchBarberRepositoryImpl()))),
        BlocProvider(create: (_) => LikePostCubit()),
        BlocProvider(create: (_) => ShareCubit(ShareServicesImpl()))
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;
          double heightFactor = 0.5;

          return ColoredBox(
            color: AppPalette.blackClr,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(
                  isTitle: true,
                  backgroundColor: AppPalette.blackClr,
                  title: 'Posts ˅',
                  titleColor: AppPalette.whiteClr,
                ),
                body: PostScreenWidget(
                    screenHeight: screenHeight,
                    heightFactor: heightFactor,
                    screenWidth: screenWidth),
              ),
            ),
          );
        },
      ),
    );
  }
}

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
              context.read<FetchPostWithBarberBloc>().add(FetchPostWithBarberRequest());
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: model.length,
              itemBuilder: (context, index) {
                final data = model[index];
                final formattedDate = formatDate(data.post.createdAt);
                String formattedStartTime =
                    formatTimeRange(data.post.createdAt);

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
                  chatOnTap: () {},
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
                description:
                    'Not only did it reduce effort, but it also gave me a clearer structure I could reuse across other components. I’ve attached a screenshot of the modified widget and how it now dynamically adapts to different screen sizes.',
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

class PostScreenMainWidget extends StatelessWidget {
  final double screenHeight;
  final double heightFactor;
  final double screenWidth;
  final String postUrl;
  final String shopUrl;
  final String shopName;
  final String location;
  final int likes;
  final String description;
  final VoidCallback profilePage;
  final VoidCallback likesOnTap;
  final VoidCallback shareOnTap;
  final VoidCallback chatOnTap;
  final Color favoriteColor;
  final IconData favoriteIcon;
  final String dateAndTime;

  const PostScreenMainWidget({
    super.key,
    required this.screenHeight,
    required this.heightFactor,
    required this.screenWidth,
    required this.postUrl,
    required this.shopUrl,
    required this.shopName,
    required this.location,
    required this.likes,
    required this.description,
    required this.profilePage,
    required this.likesOnTap,
    required this.shareOnTap,
    required this.chatOnTap,
    required this.favoriteColor,
    required this.favoriteIcon,
    required this.dateAndTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConstantWidgets.hight10(context),
        SizedBox(
          width: double.infinity,
          child: InkWell(
            onTap: profilePage,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SizedBox(
                      height: 48,
                      width: 48,
                      child: ClipOval(
                        child: Container(
                            color: Colors.grey.shade800,
                            child: (shopUrl.startsWith('http'))
                                ? imageshow(
                                    imageUrl: shopUrl,
                                    imageAsset: AppImages.loginImageAbove)
                                : Image.asset(
                                    AppImages.loginImageAbove,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                    ),
                  ),
                ),
                ConstantWidgets.width20(context),
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.location_history_rounded,
                            color: Colors.black,
                            size: 16,
                          ),
                          ConstantWidgets.width20(context),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        ConstantWidgets.hight10(context),
        SizedBox(
          height: screenHeight * heightFactor,
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: (postUrl.startsWith('http'))
                  ? imageshow(
                      imageUrl: postUrl, imageAsset: AppImages.barberEmpty)
                  : Image.asset(
                      AppImages.barberEmpty,
                      fit: BoxFit.cover,
                    )),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                favoriteIcon,
                color: favoriteColor,
              ),
              onPressed: likesOnTap,
            ),
            IconButton(
              icon: Icon(
                Icons.send_and_archive_rounded,
              ),
              onPressed: shareOnTap,
            ),
            IconButton(
              icon: Icon(
                CupertinoIcons.chat_bubble_fill,
                color: Colors.blueGrey,
              ),
              onPressed: chatOnTap,
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * .04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$likes Appreciations',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              ReadMoreText(
                description,
                trimMode: TrimMode.Line,
                trimLines: 2,
                colorClickableText: AppPalette.blueClr,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                moreStyle: TextStyle(color: AppPalette.blueClr),
              ),
              Text(
                dateAndTime,
                style: TextStyle(color: AppPalette.greyClr),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
