import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restaurent_pos/common/failure.dart';
import 'package:restaurent_pos/common/type_defs.dart';
import 'package:restaurent_pos/shared/models/table.dart';
import 'package:restaurent_pos/shared/providers/firebase.dart';

final tablesRepositoryProvider = Provider<TablesRepository>((ref) {
  final firestore = ref.watch(fireStoreProvider);
  return TablesRepository(firestore);
});

class TablesRepository {
  final FirebaseFirestore _firestore;

  TablesRepository(this._firestore);

  FutureVoid addTable(Booth booth) async {
    try {
      // add with the name of the table
      return right(_firestore
          .collection(FirebaseConstants.tableCollection)
          .doc(booth.name)
          .set(booth.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Booth>> getTables() async* {
    //snapshot.docs.map((e) => Item.fromMap(e.data())).toList()

    // get stream of tables
    yield* _firestore
        .collection(FirebaseConstants.tableCollection)
        .snapshots()
        .map(
            (event) => event.docs.map((e) => Booth.fromMap(e.data())).toList());
  }

  FutureVoid deleteTable(Booth table) async {
    try {
      return right(_firestore
          .collection(FirebaseConstants.tableCollection)
          .doc(table.name)
          .delete());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
