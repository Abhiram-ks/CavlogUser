import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';

import '../../../../data/repositories/delete_account_repo.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc() : super(DeleteAccountInitial()) {
    on<DeleteAccountProceed>((event, emit) async {
      emit(DeleteAccountLoadingState());

      try {
        final bool isDeleted = await deleteCurrentUserAuthOnly(event.password);

        if (isDeleted) {
          emit(DeleteAccountSuccessState());
        } else {
          emit(DeleteAccountFailureState());
        }
      } catch (e) {
        emit(DeleteAccountFailureState());
      }
    });
  }
}

