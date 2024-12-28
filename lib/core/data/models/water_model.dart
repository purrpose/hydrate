import 'package:cloud_firestore/cloud_firestore.dart';

class WaterModel {
  final String drinkId;
  final String uid;
  final int amountTaken;
  final DateTime dateAndTime;

  WaterModel({
    required this.drinkId,
    required this.uid,
    required this.amountTaken,
    required this.dateAndTime,
  });

  factory WaterModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WaterModel(
        drinkId: doc.id,
        uid: data['uid'],
        amountTaken: data['amountTaken'] ?? 0,
        dateAndTime: (data['dateAndTime'] as Timestamp).toDate());
  }

  Map<String, dynamic> toMap() {
    return {
      'drinkId': drinkId,
      'uid': uid,
      'amountTaken': amountTaken,
      'dateAndTime': dateAndTime,
    };
  }
}
