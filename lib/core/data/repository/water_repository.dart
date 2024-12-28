import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrate/core/data/models/daily_model.dart';
import 'package:hydrate/core/data/models/water_model.dart';

class WaterRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  WaterRepository(this._auth, this._firestore);

  String get _userId => _auth.currentUser!.uid;

  Future<String?> getUid() async => _userId;

  Stream<List<WaterModel>> getDrinks() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day + 1);
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('drinks')
        .where('uid', isEqualTo: _userId)
        .where('dateAndTime', isGreaterThanOrEqualTo: startOfDay)
        .where('dateAndTime', isLessThan: endOfDay)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => WaterModel.fromFirestore(doc)).toList();
    });
  }

  Stream<List<DailyModel>> getDailys() {
    return _firestore
        .collection('users')
        .doc(_userId)
        .collection('dailyAmount')
        .where('uid', isEqualTo: _userId)
        .orderBy('time', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => DailyModel.fromFirestore(doc)).toList();
    });
  }

  Future<void> createInitialDailyAmount(String uid) async {
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('dailyAmount')
        .add({
      'uid': uid,
      'dailyAmount': 2000,
      'time': DateTime.now(),
    });
  }

  Future<void> deleteDailyAmount(String id) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('dailyAmount')
        .doc(id)
        .delete();
  }

  Future<void> addDailyAmount(int dailyAmount, String id) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('dailyAmount')
        .add(
      {
        'id': id,
        'dailyAmount': dailyAmount,
        'uid': _userId,
        'time': DateTime.now(),
      },
    );
  }

  Future<void> addDrink(int amountTaken, DateTime date, String uid) async {
    await _firestore.collection('users').doc(_userId).collection('drinks').add(
      {
        'amountTaken': amountTaken,
        'dateAndTime': date,
        'uid': _userId,
      },
    );
  }

  Future<void> deleteDrink(String drinkId) async {
    await _firestore
        .collection('users')
        .doc(_userId)
        .collection('drinks')
        .doc(drinkId)
        .delete();
  }

  Future<List<WaterModel>> getDrinksForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final snapshot = await _firestore
        .collection('users')
        .doc(_userId)
        .collection('drinks')
        .where('dateAndTime', isGreaterThanOrEqualTo: startOfDay)
        .where('dateAndTime', isLessThanOrEqualTo: endOfDay)
        .get();

    return snapshot.docs.map((doc) => WaterModel.fromFirestore(doc)).toList();
  }
}
