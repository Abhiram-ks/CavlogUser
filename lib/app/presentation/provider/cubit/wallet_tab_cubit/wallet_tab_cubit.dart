import 'package:bloc/bloc.dart';

class WalletTabCubit extends Cubit<int> {
  WalletTabCubit() : super(0); 

  void selectTab(int index) => emit(index);
}
