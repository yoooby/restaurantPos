// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/controllers/core_controller.dart';
import 'package:restaurent_pos/controllers/orders.dart';
import 'package:restaurent_pos/models/item.dart';
import 'package:restaurent_pos/models/order.dart';
import 'package:restaurent_pos/theme/palette.dart';

// statenotifier currentOrderprovider with a list and add item to list method

class OrderBar extends ConsumerWidget {
  const OrderBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentselectedTable = ref.watch(currentSelectedTableProvider);
    final List<OrderItem> currentOrder = ref.watch(currentOrderProvider);
    final bool coreControllerState = ref.watch(coreControllerProvider);
    // show Check mark when order is sent succesfully

    return Container(
      color: Palette.textColor,
      child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: coreControllerState
                ? _buildOrderSuccess()
                : Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.table_restaurant_sharp,
                                color: Colors.grey,
                              ),
                              Text(
                                currentselectedTable?.name ?? "",
                                style: TextStyle(
                                    fontSize: 20, color: Palette.textColor),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        flex: 9,
                        child: ListView.builder(
                          itemCount: currentOrder.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              direction: DismissDirection.startToEnd,
                              onDismissed: (direction) {
                                ref
                                    .watch(currentOrderProvider.notifier)
                                    .removeOrderItem(currentOrder[index]);
                              },
                              key: UniqueKey(),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    // leading is a circle with count of items
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Colors.grey.withOpacity(0.2),
                                      child: Text(
                                        ref
                                            .watch(currentOrderProvider)[index]
                                            .quantity
                                            .toString(),
                                        style: TextStyle(
                                            color: Palette.textColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    title: Text(currentOrder[index].item.name),
                                    subtitle: Text(
                                      "\$${currentOrder[index].item.price}",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    trailing: Text(
                                      "\$${(currentOrder[index].item.price * currentOrder[index].quantity).toStringAsFixed(2)}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Palette.textColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )),
                            );
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            'Total',
                            style: TextStyle(fontSize: 20),
                          ),
                          Spacer(),
                          Text(
                            '\$${ref.watch(currentOrderProvider.notifier).totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Divider(),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          // two buttons each of them takes half ot available space
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                ref
                                    .watch(currentOrderProvider.notifier)
                                    .clearOrder();
                              },
                              style: ElevatedButton.styleFrom(
                                shape: BeveledRectangleBorder(),
                                backgroundColor: Colors.redAccent,
                              ),
                              child: Text('CLEAR',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (currentselectedTable == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Please select a table'),
                                    ),
                                  );
                                  return;
                                }
                                ref
                                    .read(coreControllerProvider.notifier)
                                    .createOrder(context, currentselectedTable);
                                // clear the order after sending
                              },
                              style: ElevatedButton.styleFrom(
                                shape: BeveledRectangleBorder(),
                                backgroundColor: Colors.green,
                              ),
                              child: Text('SEND',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          )),
    );
  }

  _buildOrderSuccess() {
    // show for 1 second then clear the order

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Palette.primaryColor,
            size: 100,
          ),
          Text(
            'Order Sent',
            style: TextStyle(fontSize: 20, color: Palette.primaryColor),
          ),
        ],
      ),
    );
  }
}
