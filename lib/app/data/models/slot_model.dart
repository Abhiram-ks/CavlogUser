import 'package:cloud_firestore/cloud_firestore.dart';

class SlotModel {
  final String docId;
  final String subDocId;
  final String shopId;
  final DateTime startTime;
  final DateTime endTime;
  final String date;
  final bool booked;
  final bool available;
  final Duration duration;
  


  SlotModel({
    required this.docId,
    required this.subDocId,
    required this.shopId,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.booked,
    required this.available,
    required this.duration,
  });


  Map<String, dynamic> toMap() {
    return {
      'docId': docId, 
      'subdocId': subDocId,
      'shopId': shopId,
      'startTime': startTime,
      'endTime': endTime,
      'date': date,
      'booked': booked,
      'available': available,
      'duration': duration.inMinutes,
    };
  }

  factory SlotModel.fromMap( Map<String, dynamic> map) {
   return SlotModel(
      docId: map['docId'] ?? '',
      subDocId: map['subdocId'] ?? '',
      shopId: map['shopId'] ?? '',
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      date: map['date'] ?? '',
      booked: map['booked'] ?? false,
      available: map['available'] ?? true,
      duration: Duration(minutes: map['duration'] ?? 0)
  );
  }
}