
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_panel/app/data/datasources/chat_remote_datasources.dart';
import 'package:user_panel/app/data/repositories/fetch_barber_repo.dart';
import 'package:user_panel/app/data/repositories/image_picker_repo.dart';
import 'package:user_panel/app/data/repositories/request_for_chatupdate_repo.dart';
import 'package:user_panel/app/domain/usecases/image_picker_usecase.dart';
import 'package:user_panel/app/presentation/provider/bloc/fetching_bloc/fetch_barber_bloc/fetch_barber_id_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/image_picker/imge_picker_bloc.dart';
import 'package:user_panel/app/presentation/provider/bloc/send_message_bloc/send_message_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/status_chat_requst_bloc/status_chat_requst_cubit.dart';
import 'package:user_panel/app/presentation/widget/chat_widget/chat_indivitual_widget/chat_customappbar_widget.dart';
import 'package:user_panel/app/presentation/widget/chat_widget/chat_indivitual_widget/chat_window_widget.dart' show ChatWindowWidget;
import 'package:user_panel/core/cloudinary/cloudinary_service.dart';

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
        BlocProvider( create: (_) => FetchBarberIdBloc(FetchBarberRepositoryImpl())),
        BlocProvider( create: (_) => ImagePickerBloc(PickImageUseCase(ImagePickerRepositoryImpl(ImagePicker())))),
        BlocProvider( create: (_) => SendMessageBloc(chatRemoteDatasources: ChatRemoteDatasourcesImpl(),cloudinaryService:CloudinaryService())),
        BlocProvider( create: (_) => StatusChatRequstDartCubit(RequestForChatupdateRepoImpl())),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
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

