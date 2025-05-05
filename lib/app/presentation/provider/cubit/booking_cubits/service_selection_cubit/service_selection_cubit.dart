
import 'package:bloc/bloc.dart';

part 'service_selection_state.dart';

class ServiceSelectionCubit extends Cubit<ServiceSelectionState> {
  ServiceSelectionCubit() : super(ServiceSelectionState());

  void toggleSelection(String serviceName, double amount) {
    final updatedList = List<Map<String, dynamic>>.from(state.selectedServices);

    final index = updatedList.indexWhere((item) => item['serviceName'] == serviceName);

    if (index != -1) {
      updatedList.removeAt(index);
    } else {
      updatedList.add({
        'serviceName': serviceName,
        'serviceAmount': amount,
      });
    }
    emit(state.copyWith(selectedServices: updatedList));
  }
  bool isSelected(String serviceName) {
    return state.selectedServices.any((item) => item['serviceName'] == serviceName);
  }
}
