// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/common/drawer.dart';
import 'package:restaurent_pos/common/utils.dart';
import 'package:restaurent_pos/controllers/auth_controller.dart';
import 'package:restaurent_pos/controllers/core_controller.dart';
import 'package:restaurent_pos/main.dart';
import 'package:restaurent_pos/models/order.dart';
import 'package:restaurent_pos/models/table.dart';
import 'package:restaurent_pos/theme/palette.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:restaurent_pos/view/core/appbar.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
          drawer: buildDrawer(ref, context),
          // check out, tables, orders, tools with Pallete.txtcolor
          body: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      TopBar(),
                      Container(
                        color: Palette.backgroundColor,
                      ),
                    ],
                  )),
              Expanded(child: const OrdersBar()),
            ],
          )),
    );
  }
}

class OrdersBar extends ConsumerWidget {
  const OrdersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(getOrdersProvider);
    ref.watch(authControllerProvider.notifier);
    ref.watch(userProvider);
    return Container(
      color: Palette.drawerColor,
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
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
            ),
          ),
          child: orders.when(
            data: (data) => Column(
              children: [
                // title
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.restaurant_menu,
                        color: Palette.textColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Orders",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25,
                            color: Palette.textColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GroupedListView(
                    groupSeparatorBuilder: (value) => Container(
                      color: Colors.grey.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Text(
                        value,
                        textAlign: TextAlign.left,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    groupComparator: (group1, group2) {
                      // pending orders are shown first
                      if (group1 == "Pending") {
                        return -1;
                      }
                      if (group2 == "Pending") {
                        return 1;
                      }
                      return group2.compareTo(group1);
                    },
                    elements: data,
                    // gorup elements of the same day together and active orders are shown first
                    groupBy: (element) {
                      if (!element.isDone) {
                        return "Pending";
                      } else {
                        return getFormattedDate(element.createdAt);
                      }
                    },
                    itemBuilder: (context, element) =>
                        _buildOrderListTile(element),
                  ),
                ),
              ],
            ),
            error: (error, stack) => Center(
              child: Text(error.toString()),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          )),
    );
  }

  Widget _buildOrderListTile(Order order) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
          ),
          top: BorderSide(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
      ),
      child: ListTile(
        // divider on top and down]

        onTap: () {},
        // title is totoal price
        title: Text("\$${order.total}",
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("Table ${order.tableId}",
            style: const TextStyle(color: Colors.grey)),
        // time of order
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // i want a dot next to flashing

            Text("${order.createdAt.hour}:${order.createdAt.minute}",
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                )),
            Text(order.isDone ? "Done" : "Active",
                style: TextStyle(
                    color: order.isDone ? Colors.grey : Palette.primaryColor,
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
