import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/features/orders/repository/orders_repository.dart';
import 'package:restaurent_pos/shared/models/order.dart' as Model;
import 'package:restaurent_pos/shared/models/table.dart';
import 'package:restaurent_pos/shared/providers/current_order_provider.dart';
import 'package:restaurent_pos/main.dart';
import 'package:uuid/uuid.dart';

import '../../../common/utils.dart';

final getOrdersProvider = StreamProvider.autoDispose<List<Model.Order>>((ref) {
  final controller = ref.read(ordersControllerProvider.notifier);
  return controller.getOrders();
});

final getOrderByIDProvider =
    FutureProvider.family<Model.Order?, String>((ref, id) async {
  final controller = ref.read(ordersControllerProvider.notifier);
  return controller.getOrderByID(id);
});


final ordersControllerProvider =
    StateNotifierProvider<OrdersController, bool>((ref) {
  final ordersRepository = ref.watch(ordersRepositoryProvider);
  return OrdersController(ref, ordersRepository);
});

class OrdersController extends StateNotifier<bool> {
  final Ref _ref;
  final OrdersRepository _ordersRepository;

  OrdersController(this._ref, this._ordersRepository) : super(false);

  Future<void> createOrder(BuildContext context, Booth table) {
    if (table.orderId != null) {
      showErrorSnackBar(context, 'Table Already has an order!');
      return Future.value();
    }

    state = true;
    final order = Model.Order(
      user: _ref.read(userProvider)!,
      id: const Uuid().v1(),
      note: '',
      items: _ref.read(currentOrderProvider),
      isDone: false,
      createdAt: DateTime.now(),
      tableId: table.name,
    );

    return _ordersRepository.createOrder(order, table).then((value) {
      value.fold((l) {
        state = false;
        showErrorSnackBar(context, l.message);
      }, (r) {
        _ref.read(currentOrderProvider.notifier).clearOrder();
        state = false;
        return;
      });
    });
  }

  // get order
  Future<Model.Order?> getOrderByID(String id) async {
    final order = await _ordersRepository.getOrder(id);
    return order.fold((l) {
      return null;
    }, (r) => r);
  }

  Future<void> updateOrder(BuildContext context, Model.Order order) {
    return _ordersRepository.updateOrder(order).then((value) {
      value.fold((l) {
        showErrorSnackBar(context, l.message);
      }, (r) {
        return;
      });
    });
  }

  // get all orders
  Stream<List<Model.Order>> getOrders() async* {
    final orders = _ordersRepository.getOrders();
    yield* orders;
  }
}
