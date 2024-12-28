import 'package:cloud_firestore/cloud_firestore.dart';

class DailyModel {
  final String id;
  final String uid;
  final int dailyAmount;

  DailyModel({
    required this.id,
    required this.uid,
    required this.dailyAmount,
  });

  factory DailyModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DailyModel(
      id: doc.id,
      uid: data['uid'],
      dailyAmount: data['dailyAmount'] ?? 2000,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uid': uid,
      'dailyAmount': dailyAmount,
    };
  }
}
