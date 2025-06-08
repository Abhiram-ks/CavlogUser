
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/data/repositories/fetch_barber_repo.dart';
import 'package:user_panel/app/data/repositories/fetch_post_with_barber_mode.dart';
import 'package:user_panel/app/domain/repositories/share_function_services.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_post_with_barber_bloc/fetch_post_with_barber_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/share_post_cubit/share_post_cubit.dart';
import 'package:user_panel/core/common/custom_appbar_widget.dart';
import 'package:user_panel/core/themes/colors.dart';
import '../../../provider/cubit/like_comment_cubit/like_comment_cubit.dart';
import '../../../provider/cubit/post_like_cubit/post_like_cubit.dart';
import '../../../widget/post_widget/post_body_widget.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FetchPostWithBarberBloc(PostService(FetchBarberRepositoryImpl()))),
        BlocProvider(create: (_) => LikePostCubit()),
        BlocProvider(create: (_) => LikeCommentCubit()),
        BlocProvider(create: (_) => ShareCubit(ShareServicesImpl())),
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
