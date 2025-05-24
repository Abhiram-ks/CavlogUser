import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pinch_to_zoom_scrollable/pinch_to_zoom_scrollable.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_panel/app/data/datasources/chat_remote_datasources.dart';
import 'package:user_panel/app/data/models/chat_model.dart';
import 'package:user_panel/app/data/repositories/fetch_barber_repo.dart';
import 'package:user_panel/app/data/repositories/image_picker_repo.dart';
import 'package:user_panel/app/data/repositories/messagedelete_repo.dart';
import 'package:user_panel/app/data/repositories/request_for_chatupdate_repo.dart';
import 'package:user_panel/app/domain/usecases/image_picker_usecase.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_barber_bloc/fetch_barber_id_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/image_picker/imge_picker_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/send_message_bloc/send_message_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/status_chat_requst_bloc/status_chat_requst_cubit.dart';
import 'package:user_panel/app/presentation/screens/pages/search/detail_screen/detail_screen.dart';
import 'package:user_panel/app/presentation/widget/chat_widget/chat_indivitual_widget/handle_sendmessage_state.dart';
import 'package:user_panel/auth/presentation/provider/cubit/button_progress_cubit/button_progress_cubit.dart';
import 'package:user_panel/core/cloudinary/cloudinary_service.dart';
import 'package:user_panel/core/utils/constant/constant.dart';

import '../../../../../core/common/custom_imageshow_widget.dart';
import '../../../../../core/themes/colors.dart';
import '../../../../../core/utils/image/app_images.dart';
import '../../../widget/chat_widget/chat_indivitual_widget/chat_image_building_widget.dart';

class IndividualChatScreen extends StatefulWidget {
  final String userId;
  final String barberId;

  const IndividualChatScreen({
    super.key,
    required this.userId,
    required this.barberId,
  });

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => FetchBarberIdBloc(FetchBarberRepositoryImpl())),
        BlocProvider(
          create: (_) => ImagePickerBloc(
            PickImageUseCase(ImagePickerRepositoryImpl(ImagePicker())),
          ),
        ),
        BlocProvider(
          create: (_) => SendMessageBloc(
            chatRemoteDatasources: ChatRemoteDatasourcesImpl(),
            cloudinaryService: CloudinaryService(),
          ),
        ),
        BlocProvider(
            create: (_) =>
                StatusChatRequstDartCubit(RequestForChatupdateRepoImpl())),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Scaffold(
              appBar: ChatAppBar(
                barberId: widget.barberId,
                screenWidth: screenWidth,
              ),
              body: ChatWindowWidget(
                userId: widget.userId,
                barberId: widget.barberId,
                controller: controller,
              ));
        },
      ),
    );
  }
}

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String barberId;
  final double screenWidth;

  const ChatAppBar({
    super.key,
    required this.barberId,
    required this.screenWidth,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    context.read<FetchBarberIdBloc>().add(FetchBarberDetailsAction(barberId));

    return BlocBuilder<FetchBarberIdBloc, FetchBarberIdState>(
      builder: (context, state) {
        if (state is FetchBarberDetailsSuccess) {
          final barber = state.barberServices;

          return AppBar(
            backgroundColor: AppPalette.blackClr,
            automaticallyImplyLeading: true,
            elevation: 0,
            titleSpacing: 0,
            iconTheme: const IconThemeData(color: AppPalette.whiteClr),
            title: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DetailBarberScreen(barberId: barberId))),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: imageshow(
                        imageUrl: barber.image ?? '',
                        imageAsset: AppImages.barberEmpty,
                      ),
                    ),
                  ),
                  ConstantWidgets.width20(context),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          barber.ventureName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.045,
                            color: AppPalette.whiteClr,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          barber.email,
                          style: TextStyle(
                            color: AppPalette.greenClr,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ConstantWidgets.width40(context),
                ],
              ),
            ),
          );
        }
        return AppBar(
          backgroundColor: AppPalette.blackClr,
          automaticallyImplyLeading: true,
          elevation: 0,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: AppPalette.whiteClr),
          title: Shimmer.fromColors(
            baseColor: Colors.grey[300] ?? AppPalette.greyClr,
            highlightColor: AppPalette.whiteClr,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: imageshow(
                      imageUrl: '',
                      imageAsset: AppImages.barberEmpty,
                    ),
                  ),
                ),
                ConstantWidgets.width20(context),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Venture Name Loading...",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.045,
                          color: AppPalette.whiteClr,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'loading...',
                        style: TextStyle(
                          color: AppPalette.greenClr,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatWindowWidget extends StatefulWidget {
  final String userId;
  final String barberId;
  final TextEditingController controller;

  const ChatWindowWidget({
    super.key,
    required this.userId,
    required this.barberId,
    required this.controller,
  });

  @override
  State<ChatWindowWidget> createState() => _ChatWindowWidgetState();
}

class _ChatWindowWidgetState extends State<ChatWindowWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _shouldAutoScroll = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatUpdateCubit = StatusChatRequstDartCubit(RequestForChatupdateRepoImpl());
      chatUpdateCubit.updateChatStatus(
        userId: widget.userId,
        barberId: widget.barberId,
      );
    });
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final isAtBottom = _scrollController.offset >=
        _scrollController.position.maxScrollExtent - 200;

    _shouldAutoScroll = isAtBottom;
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeOut,
      );
    }
  }

  Stream<List<ChatModel>> getMessagesStream() {
    return FirebaseFirestore.instance
        .collection('chat')
        .where('userId', isEqualTo: widget.userId)
        .where('barberId', isEqualTo: widget.barberId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatModel.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<ChatModel>>(
            stream: getMessagesStream(),
            builder: (context, snapshot) {
              final messages = snapshot.data ?? [];
              if (_shouldAutoScroll) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  scrollToBottom();
                });
              }
              if (snapshot.hasData && _scrollController.hasClients) {
                WidgetsBinding.instance
                    .addPostFrameCallback((_) => scrollToBottom());
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Loading..."),
                );
              }

              if (messages.isEmpty) {
                return Column(
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
                        color:
                            AppPalette.buttonClr.withAlpha((0.3 * 255).round()),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '⚿ No conversations yet.Your chats are private and end-to-end encrypted. Only you and your barber can read them. Start a conversation now and enjoy seamless, secure messaging!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppPalette.blackClr),
                      ),
                    )),
                  ],
                );
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final bool showDateLabel = index == 0 ||
                      messages[index - 1].createdAt.day !=
                          message.createdAt.day;

                  return Column(
                    children: [
                      if (showDateLabel)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppPalette.hintClr,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                DateFormat('dd MMM yyyy')
                                    .format(message.createdAt),
                                style:
                                    const TextStyle(color: AppPalette.whiteClr),
                              ),
                            ),
                          ),
                        ),
                      MessageBubleWidget(
                        message: message.message,
                        time: DateFormat('hh:mm a').format(message.createdAt),
                        isCurrentUser: message.senderId == widget.userId,
                        docId: message.docId ?? '',
                        delete: message.delete == true,
                        softDelete: message.senderId == widget.userId &&
                            message.softDelete == true,
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        imagePIckerChating(),
        BlocListener<SendMessageBloc, SendMessageState>(
          listener: (context, state) {
            handleSendMessage(context, state, widget.controller);
          },
          child: ChatWindowTextFiled(
            controller: widget.controller,
            sendButton: () {
              final text = widget.controller.text.trim();
              final imageState = context.read<ImagePickerBloc>().state;

              if (imageState is ImagePickerSuccess) {
                final imagePath = imageState.imagePath;
                context.read<SendMessageBloc>().add(SendImageMessage(
                    image: imagePath,
                    userId: widget.userId,
                    barberId: widget.barberId));
              }
              if (text.isEmpty) return;

              context.read<SendMessageBloc>().add(
                    SendTextMessage(
                      message: text,
                      userId: widget.userId,
                      barberId: widget.barberId,
                    ),
                  );
              Future.delayed(const Duration(milliseconds: 1), () {
                scrollToBottom();
              });
            },
          ),
        ),
      ],
    );
  }
}

class MessageBubleWidget extends StatelessWidget {
  final String message;
  final String time;
  final String docId;
  final bool isCurrentUser;
  final bool delete;
  final bool softDelete;

  const MessageBubleWidget({
    super.key,
    required this.message,
    required this.time,
    required this.docId,
    required this.isCurrentUser,
    required this.delete,
    required this.softDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (softDelete) {
      return const SizedBox.shrink();
    }

    final bubbleColor = delete
        ? Colors.grey.shade300.withAlpha((0.6 * 255).toInt())
        : isCurrentUser
            ? AppPalette.buttonClr
            : Colors.grey.shade300;

    final textColor = delete
        ? Colors.black54
        : isCurrentUser
            ? AppPalette.whiteClr
            : AppPalette.blackClr;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onLongPress: () {
          if (isCurrentUser && !delete) {
            showCupertinoModalPopup(
              context: context,
              builder: (BuildContext context) => CupertinoActionSheet(
                title: const Text(
                  'Are you sure you want to delete this message?',
                ),
                message: const Text(
                  'This action cannot be undone. Choose how you want to delete the message.',
                ),
                actions: <CupertinoActionSheetAction>[
                  CupertinoActionSheetAction(
                    onPressed: () {
                      DeleteMessage().hardDeleteMessage(docId);
                      Navigator.pop(context);
                    },
                    isDestructiveAction: true,
                    child: const Text(
                      'Delete for Everyone',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  CupertinoActionSheetAction(
                    onPressed: () {
                      DeleteMessage().softDelete(docId);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Delete for Me',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppPalette.blackClr,
                      ),
                    ),
                  ),
                ],
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppPalette.blackClr,
                    ),
                  ),
                ),
              ),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft:
                  isCurrentUser ? const Radius.circular(16) : Radius.zero,
              bottomRight:
                  isCurrentUser ? Radius.zero : const Radius.circular(16),
            ),
          ),
          constraints: const BoxConstraints(maxWidth: 280),
          child: Column(
            crossAxisAlignment: isCurrentUser
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (delete) ...[
                Row(
                  children: [
                    const Icon(CupertinoIcons.nosign,
                        size: 16, color: Colors.black54),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'This message was deleted',
                        style: TextStyle(
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else if (message.startsWith('http')) ...[
                PinchToZoomScrollableWidget(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.zero,
                          child: InteractiveViewer(
                            child: Image.network(
                              message,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: imageshow(
                          imageUrl: message,
                          imageAsset: AppImages.barberEmpty,
                        ),
                      ),
                    ),
                  ),
                )
              ] else ...[
                Text(
                  message,
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
              ],
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatWindowTextFiled extends StatelessWidget {
  const ChatWindowTextFiled({
    super.key,
    required TextEditingController controller,
    required this.sendButton,
  }) : _controller = controller;

  final TextEditingController _controller;
  final VoidCallback sendButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      color: AppPalette.whiteClr,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Type a message",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {
                      context.read<ImagePickerBloc>().add(PickImageAction());
                    },
                  ),
                ),
                textInputAction: TextInputAction.send,
              ),
            ),
            ConstantWidgets.width20(context),
            GestureDetector(
              onTap: sendButton,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppPalette.buttonClr,
                  shape: BoxShape.circle,
                ),
                child: BlocBuilder<ButtonProgressCubit, ButtonProgressState>(
                  builder: (context, state) {
                    if (state is MessageSendLoading) {
                      return const SpinKitFadingCircle(
                        color: AppPalette.whiteClr,
                        size: 23.0,
                      );
                    }
                    return const Icon(
                      Icons.send,
                      color: AppPalette.whiteClr,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
