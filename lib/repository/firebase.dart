import 'package:flutter_riverpod/flutter_riverpod.dart';
// import firebase storage
import 'package:firebase_storage/firebase_storage.dart';
// import firebase firestore
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseConstants {
  static String itemCollection = 'items';
  static String tableCollection = 'tables';
  static String userCollection = 'user';
  static String categoryCollection = 'categories';
}

final fireStoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final storageProvider =
    Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);
