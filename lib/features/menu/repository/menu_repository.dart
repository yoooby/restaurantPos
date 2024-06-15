import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restaurent_pos/common/failure.dart';
import 'package:restaurent_pos/common/type_defs.dart';
import 'package:restaurent_pos/shared/models/item.dart';
import 'package:restaurent_pos/shared/providers/firebase.dart';

final menuRepositoryProvider = Provider<MenuRepository>((ref) {
  final firestore = ref.watch(fireStoreProvider);
  return MenuRepository(firestore);
});

class MenuRepository {
  final FirebaseFirestore _firestore;

  MenuRepository(this._firestore);

  // get items
  FutureEither<List<Item>> getItems() async {
    try {
      final snapshot =
          await _firestore.collection(FirebaseConstants.itemCollection).get();
      final items = snapshot.docs.map((e) => Item.fromMap(e.data())).toList();
      return right(items);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // add item
  FutureVoid addItem(Item item) async {
    // check if category exists in the firestore if not create it

    try {
      // get categories Collection reference
      return right(_firestore
          .collection(FirebaseConstants.itemCollection)
          .add(item.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
