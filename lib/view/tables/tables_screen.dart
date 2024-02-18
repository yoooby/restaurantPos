// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/controllers/core_controller.dart';
import 'package:restaurent_pos/controllers/orders.dart';
import 'package:restaurent_pos/models/table.dart';
import 'package:restaurent_pos/theme/palette.dart';
import 'package:restaurent_pos/view/core/appbar.dart';
import 'package:restaurent_pos/view/orders/order_bar.dart';
import 'package:routemaster/routemaster.dart';

class TablesScreen extends ConsumerWidget {
  const TablesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.watch(tablesListProvider);
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Palette.drawerColor,
        ),
        backgroundColor: Palette.backgroundColor,
        body: Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(children: [
                TopBar(),
                Expanded(
                    child: tables.when(data: (List<Booth> data) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return TableIcon(
                        () async {
                          ref
                              .watch(currentSelectedTableProvider.notifier)
                              .update((state) => data[index]);
                          if (data[index].orderId == null) {
                            Routemaster.of(context).push('/menu');
                            ref
                                .read(currentOrderProvider.notifier)
                                .clearOrder();
                          } else {
                            final order = await ref
                                .read(coreControllerProvider.notifier)
                                .getOrderByID(data[index].orderId!);
                            ref
                                .read(currentOrderProvider.notifier)
                                .setOrder(order);
                          }
                        },
                        tableNumber: data[index].name,
                        hasOrder: data[index].orderId == null
                            ? false
                            : true, // TODO: check if table has order or not,
                        isSelected: ref.watch(currentSelectedTableProvider) ==
                            data[index],
                      );
                    },
                  );
                }, error: (error, stack) {
                  return Center(
                    child: Text(error.toString()),
                  );
                }, loading: () {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Palette.primaryColor,
                    ),
                  );
                })),
              ]),
            ),
            Expanded(child: const OrderBar()),
          ],
        ),
      ),
    );
  }
}

class TableIcon extends ConsumerWidget {
  final VoidCallback onTap;
  final bool hasOrder;
  final bool isSelected;
  final String tableNumber;
  const TableIcon(this.onTap,
      {required this.tableNumber,
      required this.hasOrder,
      required this.isSelected,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: isSelected ? Palette.primaryColor : Palette.backgroundColor,
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/table.png",
                height: 80,
                color: isSelected
                    ? Palette.backgroundColor
                    : !hasOrder
                        ? Colors.grey
                        : Palette.textColor,
              ),
              Text(tableNumber,
                  style: TextStyle(
                      color: isSelected
                          ? Palette.backgroundColor
                          : !hasOrder
                              ? Colors.grey
                              : Palette.textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
