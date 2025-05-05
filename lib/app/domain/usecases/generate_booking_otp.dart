import 'dart:math';

class GenerateBookingOtp {
  String generateOtp() {
    final random = Random();
    final otp = random.nextInt(900000) + 100000;
    return otp.toString();
  }
}