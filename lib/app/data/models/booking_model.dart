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
  final String serviceStatus;
  final String? bookingId;
  final String otp;
  final String transaction;

  BookingModel({
    this.bookingId,
    required this.serviceStatus, 
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
    required this.transaction,
  });

  factory BookingModel.fromMap(String bookingId, Map<String, dynamic> map) {
    return BookingModel(
      bookingId: bookingId,
      serviceStatus: map['service_status'] as String? ?? 'Pending',
      userId: map['userId'] as String? ?? '',
      barberId: map['barberId'] as String? ?? '',
      duration: map['duration'] is int ? map['duration'] : int.tryParse(map['duration'].toString()) ?? 0,
      paymentMethod: map['paymentMethod'] as String? ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      serviceType: (map['serviceType'] as Map?)?.map( (key, value) => MapEntry(key.toString(), (value is num) ? value.toDouble() : 0.0) ) ?? {},
      slotTime: (map['slotTime'] as List<dynamic>?)
              ?.map((ts) => (ts is Timestamp) ? ts.toDate() : DateTime.now())
              .toList() ??
          [],
      amountPaid: (map['amountPaid'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] as String? ?? 'Pending',
      otp: map['otp'] as String? ?? '',
      transaction: map['transaction'] as String? ?? '',
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
      'transaction': transaction,
      'service_status': serviceStatus,
    };
  }
}