import '../../../provider/cubit/distance_filtering_cubit/distance_filtering_enum.dart';

int getDistanceInMeters(DistanceFilter filter) {
  switch (filter) {
    case DistanceFilter.m500:
      return 500;
    case DistanceFilter.km1:
      return 1000;
    case DistanceFilter.km2:
      return 2000;
    case DistanceFilter.km3:
      return 3000;
    case DistanceFilter.km4:
      return 4000;
    case DistanceFilter.km5:
      return 5000;
    case DistanceFilter.km10:
      return 10000;
    case DistanceFilter.km15:
      return 15000;
    case DistanceFilter.km20:
      return 20000;
    case DistanceFilter.km30:
      return 30000;
  }
}
