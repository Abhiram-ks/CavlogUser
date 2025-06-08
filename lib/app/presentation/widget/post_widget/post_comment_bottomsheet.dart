import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:user_panel/app/data/repositories/fetch_comment_repo.dart';
import 'package:user_panel/app/presentation/provider/cubit/like_comment_cubit/like_comment_cubit.dart';
import 'package:user_panel/app/presentation/widget/post_widget/handle_send_commentstate.dart';
import 'package:user_panel/app/presentation/widget/post_widget/post_comment_custom_card.dart';

import '../../../../core/themes/colors.dart';
import '../../../../core/utils/constant/constant.dart';
import '../../../data/models/comment_model.dart';
import '../../../domain/usecases/data_listing_usecase.dart';
import '../../provider/bloc/fetching_bloc/fetch_comments_bloc/fetch_comments_bloc.dart';
import '../../provider/bloc/send_comment_bloc/send_comment_bloc.dart';
import '../chat_widget/chat_indivitual_widget/chat_sendmessage_textfiled.dart';

void showCommentSheet({
  required BuildContext context,
  required double screenHeight,
  required double screenWidth,
  required String barberId,
  required String docId,
  required TextEditingController commentController,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppPalette.scafoldClr,
    enableDrag: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;

      return MultiBlocProvider(
        providers: [
          BlocProvider<FetchCommentsBloc>(
            create: (context) {
              final bloc = FetchCommentsBloc(SendCommentRepositoryImpl());
              bloc.add(FetchCommentRequst(barberId: barberId, docId: docId));
              return bloc;
            },
          ),
          BlocProvider<LikeCommentCubit>(
            create: (_) => LikeCommentCubit(),
          ),
        ],
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SizedBox(
            height: screenHeight,
            child: Column(
              children: [
                ConstantWidgets.hight10(context),
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ConstantWidgets.hight10(context),
                Expanded(
                  child: BlocBuilder<FetchCommentsBloc, FetchCommentsState>(
                    builder: (context, state) {
                      if (state is FetchCommentsLoading) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SpinKitCircle(color: AppPalette.buttonClr),
                              ConstantWidgets.hight10(context),
                              Text('Just a moment...'),
                              Text('Please wait while we process your request'),
                            ],
                          ),
                        );
                      } else if (state is FetchCommentsEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstantWidgets.hight50(context),
                              Center(
                                  child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(4),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppPalette.buttonClr
                                      .withAlpha((0.3 * 255).round()),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "💬 No comments yet. Be the first to start the conversation — your words are end-to-end encrypted, respected, and might just make someone's day. Share your thoughts, compliments, or experiences — let’s keep the good vibes rolling!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppPalette.blackClr),
                                ),
                              )),
                            ],
                          ),
                        );
                      }
                      if (state is FetchCommentsSuccess) {
                        return ListView.separated(
                          itemCount: state.comments.length,
                          padding: const EdgeInsets.all(8),
                          itemBuilder: (context, index) {
                            final CommentModel comment = state.comments[index];
                            final formattedDate = formatDate(comment.createdAt);
                            final formattedStartTime =
                                formatTimeRange(comment.createdAt);
                            return commentListWidget(
                                createdAt: '$formattedDate At $formattedStartTime',
                                favoriteColor:
                                    comment.likes.contains(state.userId)
                                        ? AppPalette.redClr
                                        : AppPalette.blackClr,
                                favoriteIcon:
                                    comment.likes.contains(state.userId)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                likesCount: comment.likes.length,
                                likesOnTap: () {
                                  context.read<LikeCommentCubit>().toggleLike(
                                      userId: state.userId,
                                      docId: comment.docId,
                                      currentLikes: comment.likes);
                                },
                                context: context,
                                userName: comment.userName,
                                comment: comment.description,
                                imageUrl: comment.imageUrl);
                          },
                          separatorBuilder: (context, index) =>
                              ConstantWidgets.hight10(context),
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
                                  context.read<FetchCommentsBloc>().add(FetchCommentRequst(barberId: barberId, docId: docId));
                                },
                                icon: Icon(Icons.refresh_rounded))
                          ],
                        ),
                      );
                    },
                  ),
                ),
                BlocListener<SendCommentBloc, SendCommentState>(
                  listener: (context, state) {
                    handleSendComments(context, state, commentController);
                  },
                  child: ChatWindowTextFiled(
                    controller: commentController,
                    isICon: false,
                    sendButton: () {
                      final text = commentController.text.trim();
                      if (text.isNotEmpty) {
                        context.read<SendCommentBloc>().add(
                            SendCommentButtonPressed(
                                comment: text,
                                barberId: barberId,
                                docId: docId));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
