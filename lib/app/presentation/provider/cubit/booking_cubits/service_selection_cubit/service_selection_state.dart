part of 'service_selection_cubit.dart';

class ServiceSelectionState {
  final List<Map<String, dynamic>> selectedServices;

  ServiceSelectionState({this.selectedServices = const[]});

  ServiceSelectionState copyWith({
    List<Map<String, dynamic>>? selectedServices,
  }) {
    return ServiceSelectionState(
      selectedServices: selectedServices ?? this.selectedServices
    );
  }
}