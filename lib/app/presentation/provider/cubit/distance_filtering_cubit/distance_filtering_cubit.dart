import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_panel/app/presentation/provider/cubit/distance_filtering_cubit/distance_filtering_enum.dart' show DistanceFilter;

class DistanceFilterCubit extends Cubit<DistanceFilter> {
  DistanceFilterCubit() : super(DistanceFilter.km5);

  void selectDistance(DistanceFilter distance) => emit(distance);
}

class SearchInputCubit extends Cubit<bool> {
  SearchInputCubit() : super(true); 

  void update(String text) => emit(text.isEmpty);
}
