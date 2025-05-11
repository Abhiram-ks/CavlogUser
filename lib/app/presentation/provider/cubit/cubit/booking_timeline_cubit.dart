import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/cubit/booking_timeline_state.dart';

class TimelineCubit extends Cubit<TimelineState> {
  TimelineCubit() : super(TimelineState(TimelineStep.created));

  void updateTimeline({
    required DateTime createdAt,
    required List<DateTime> slotTimes,
    required int duration,
  }) {
    final now = DateTime.now();
    final sortedSlots = slotTimes..sort();
    final start = sortedSlots.first;
    final end = start.add(Duration(minutes: duration));

    if (now.isBefore(start)) {
      emit(TimelineState(TimelineStep.waiting));
    } else if (now.isAfter(start) && now.isBefore(end)) {
      emit(TimelineState(TimelineStep.inProgress));
    } else if (now.isAfter(end)) {
      emit(TimelineState(TimelineStep.completed));
    } else {
      emit(TimelineState(TimelineStep.created));
    }
  }
}
