import 'package:bloc/bloc.dart';

class PostLikeAnimationCubit extends Cubit<bool> {
  PostLikeAnimationCubit() : super(false);

  void showHeart() {
    emit(true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      emit(false);
    });
  }
}

