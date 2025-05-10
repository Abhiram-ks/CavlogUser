enum DistanceFilter {
  m500,
  km1,
  km2,
  km3,
  km4,
  km5,
  km10,
  km15,
  km20,
  km30,
}

extension DistanceFilterExtension on DistanceFilter {
  String get label {
    switch (this) {
      case DistanceFilter.m500:
        return '500 m';
      case DistanceFilter.km1:
        return '1 km';
      case DistanceFilter.km2:
        return '2 km';
      case DistanceFilter.km3:
        return '3 km';
      case DistanceFilter.km4:
        return '4 km';
      case DistanceFilter.km5:
        return '5 km';
      case DistanceFilter.km10:
        return '10 km';
      case DistanceFilter.km15:
        return '15 km';
      case DistanceFilter.km20:
        return '20 km';
      case DistanceFilter.km30:
        return '30 km';
    }
  }
}
