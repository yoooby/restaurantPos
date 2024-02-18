// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/controllers/core_controller.dart';
import 'package:restaurent_pos/models/item.dart';
import 'package:restaurent_pos/theme/palette.dart';
import 'package:restaurent_pos/view/core/appbar.dart';
import 'package:restaurent_pos/view/menu/bottom_category_bar.dart';
import 'package:restaurent_pos/view/menu/cards.dart';
import 'package:restaurent_pos/view/orders/order_bar.dart';
import 'package:restaurent_pos/view/tables/tables_screen.dart';

class Menu extends ConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsListProvider);
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
                  child: Column(
                    children: [
                      TopBar(),
                      Expanded(
                          child: items.when(
                              data: (List<Item> items) {
                                return GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4),
                                  itemBuilder: (context, index) {
                                    return ItemCard(items[index]);
                                  },
                                  itemCount: items.length,
                                );
                              },
                              error: (_, __) => Placeholder(),
                              loading: () {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              })),
                    ],
                  )),
              Expanded(child: const OrderBar()),
            ],
          )),
    );
  }
}
