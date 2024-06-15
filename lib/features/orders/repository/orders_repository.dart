import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restaurent_pos/common/failure.dart';
import 'package:restaurent_pos/common/type_defs.dart';
import 'package:restaurent_pos/shared/models/order.dart' as Model;
import 'package:restaurent_pos/shared/models/table.dart';
import 'package:restaurent_pos/shared/providers/firebase.dart';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final firestore = ref.watch(fireStoreProvider);
  return OrdersRepository(firestore);
});

class OrdersRepository {
  final FirebaseFirestore _firestore;

  OrdersRepository(this._firestore);

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



  Stream<List<Model.Order>> getOrders() {
    return _firestore.collection('orders').snapshots().map((event) =>
        event.docs.map((e) => Model.Order.fromMap(e.data())).toList());
  }
}
