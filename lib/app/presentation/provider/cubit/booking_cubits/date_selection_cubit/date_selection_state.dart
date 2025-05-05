
import '../../../../../data/models/slot_model.dart';

class SlotSelectionState {
  final List<SlotModel> selectedSlots;

  SlotSelectionState({this.selectedSlots = const []});

  SlotSelectionState copyWith({List<SlotModel>? selectedSlots}) {
    return SlotSelectionState(
      selectedSlots: selectedSlots ?? this.selectedSlots,
    );
  }
}
