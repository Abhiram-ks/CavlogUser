
import 'package:bloc/bloc.dart';

import '../../../../../data/models/slot_model.dart';
import 'date_selection_state.dart';

class SlotSelectionCubit extends Cubit<SlotSelectionState> {
  SlotSelectionCubit() : super(SlotSelectionState());

  void toggleSlot(SlotModel slot, int maxSelectableSlots) {
    final updatedSlots = List<SlotModel>.from(state.selectedSlots);
    final index = updatedSlots.indexWhere((s) => s.subDocId == slot.subDocId);

    if (index != -1) {
      updatedSlots.removeAt(index);
    } else {
      if (updatedSlots.length < maxSelectableSlots) {
        updatedSlots.add(slot);
      } else {
      }
    }

    emit(state.copyWith(selectedSlots: updatedSlots));
  }

  bool isSlotSelected(String subDocId) {
    return state.selectedSlots.any((s) => s.subDocId == subDocId);
  }

  void clearSlots() {
    emit(SlotSelectionState(selectedSlots: []));
  }
}
