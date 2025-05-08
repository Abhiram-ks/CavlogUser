import 'barber_model.dart' show BarberModel;
import 'booking_model.dart' show BookingModel;

class BookingWithBarberModel {
  final BookingModel booking;
  final BarberModel barber;

  BookingWithBarberModel({
    required this.booking,
    required this.barber,
  });
}
