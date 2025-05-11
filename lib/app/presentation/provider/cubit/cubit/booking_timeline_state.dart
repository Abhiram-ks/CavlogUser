enum TimelineStep { created, waiting, inProgress, completed }

class TimelineState {
  final TimelineStep currentStep;

  TimelineState(this.currentStep);
}
