import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/shared/models/item.dart';
import 'package:restaurent_pos/shared/models/order.dart';

final currentOrderProvider =
    StateNotifierProvider<CurrentOrder, List<OrderItem>>((ref) {
  return CurrentOrder();
});

class CurrentOrder extends StateNotifier<List<OrderItem>> {
  // init state if the currentselectedTable has an order id aleardy get the order and set it as the state
  CurrentOrder() : super([]);

  void addItem(Item item) {
    final index = state.indexWhere((element) => element.item == item);
    if (index != -1) {
      final orderItem = state[index];
      state = List<OrderItem>.from(state)
        ..replaceRange(index, index + 1, [
          orderItem.copyWith(quantity: orderItem.quantity + 1),
        ]);
    } else {
      state = [
        ...state,
        OrderItem(item: item, quantity: 1),
      ];
    }
  }

  void removeItem(Item item) {
    final index = state.indexWhere((element) => element.item == item);
    if (index != -1) {
      final orderItem = state[index];
      if (orderItem.quantity > 1) {
        state[index] = orderItem.copyWith(quantity: orderItem.quantity - 1);
      } else {
        state = List<OrderItem>.from(state)..removeAt(index);
      }
    }
  }

  void clearOrder() {
    state = [];
  }

  void removeOrderItem(OrderItem orderItem) {
    state = List<OrderItem>.from(state)..remove(orderItem);
  }

  // get total price of the order
  double get totalPrice {
    return state.fold(
        0,
        (previousValue, element) =>
            previousValue + element.quantity * element.item.price);
  }

  void setOrder(Order? order) {
    // set currentselected table order id to the order id
    if (order?.items == null || order!.items.isEmpty) {
      state = [];
      return;
    }
    state = order.items;
  }
}
