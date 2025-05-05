import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String userId;
  final String barberId;
  final int duration;
  final String paymentMethod;
  final DateTime createdAt;
  final Map<String, double> serviceType;
  final List<DateTime> slotTime;
  final double amountPaid;
  final String status;
  final String? bookingId;
  final String otp;

  BookingModel({
    this.bookingId,
    required this.userId,
    required this.barberId,
    required this.duration,
    required this.paymentMethod,
    required this.createdAt,
    required this.serviceType,
    required this.slotTime,
    required this.amountPaid,
    required this.status,
    required this.otp,
  });

  factory BookingModel.fromMap(String bookingId,Map<String, dynamic> map) {
    return BookingModel(
      bookingId : bookingId,
      userId: map['userId'],
      barberId: map['barberId'],
      duration: map['duration'],
      paymentMethod: map['paymentMethod'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      serviceType: Map<String, double>.from((map['serviceType'] as Map).map((key, value) => MapEntry(key, (value as num).toDouble()))),
      slotTime: (map['slotTime'] as List<dynamic>).map((ts) => (ts as Timestamp).toDate()).toList(),
      amountPaid: (map['amountPaid'] as num).toDouble(),
      status: map['status'],
      otp: map['otp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'barberId': barberId,
      'duration': duration,
      'paymentMethod': paymentMethod,
      'createdAt': Timestamp.fromDate(createdAt),
      'serviceType': serviceType,
      'slotTime': slotTime.map((dt) => Timestamp.fromDate(dt)).toList(),
      'amountPaid': amountPaid,
      'status': status,
      'otp': otp,
    };
  }
}
