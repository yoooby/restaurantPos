// what should i call this class
// ignore_for_file: void_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restaurent_pos/common/failure.dart';
import 'package:restaurent_pos/common/type_defs.dart';
import 'package:restaurent_pos/models/item.dart';
import 'package:restaurent_pos/models/table.dart';
import 'package:restaurent_pos/models/order.dart' as Model;
import 'package:restaurent_pos/repository/firebase.dart';

// repository Provider
final coreRepositoryProvider = Provider<CoreRepository>((ref) {
  final firestore = ref.watch(fireStoreProvider);
  return CoreRepository(firestore);
});

class CoreRepository {
  final FirebaseFirestore _firestore;

  CoreRepository(this._firestore);

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
    // get stream of tables
    yield* _firestore
        .collection(FirebaseConstants.tableCollection)
        .snapshots()
        .map(
            (event) => event.docs.map((e) => Booth.fromMap(e.data())).toList());
  }

  FutureVoid createOrder(Model.Order order, Booth table) async {
    // link the order with table
    try {
      table = table.copyWith(orderId: order.id);
      await _firestore
          .collection(FirebaseConstants.tableCollection)
          .doc(table.name)
          .update(table.toMap());

      return right(
          _firestore.collection('orders').doc(order.id).set(order.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<Model.Order> getOrder(String orderId) async {
    try {
      final snapshot = await _firestore.collection('orders').doc(orderId).get();
      // i keep gettiing expected value of type list<int> but got value of type list<dynamic>

      

      final order = Model.Order.fromMap(snapshot.data()!);
      return right(order);
    } catch (e) {
      print(e.toString());
      return left(Failure(e.toString()));
    }
  }

  FutureVoid updateOrder(Model.Order order) async {
    try {
      return right(
          _firestore.collection('orders').doc(order.id).update(order.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid markOrderAsDone(Model.Order order) async {
    try {
      return right(_firestore
          .collection('orders')
          .doc(order.id)
          .update({'isDone': true}));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteOrder(Model.Order order) async {
    try {
      return right(_firestore.collection('orders').doc(order.id).delete());
    } catch (e) {
      return left(Failure(e.toString()));
    }
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
