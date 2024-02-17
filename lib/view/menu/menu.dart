// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/controllers/core_controller.dart';
import 'package:restaurent_pos/models/item.dart';
import 'package:restaurent_pos/theme/palette.dart';
import 'package:restaurent_pos/view/menu/bottom_category_bar.dart';
import 'package:restaurent_pos/view/menu/cards.dart';

class Menu extends ConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(itemsListProvider);
    return Expanded(
        child: items.when(
            data: (List<Item> items) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemBuilder: (context, index) {
                  return ItemCard(items[index].name, items[index].price,
                      items[index].category);
                },
                itemCount: items.length,
              );
            },
            error: (_, __) => Placeholder(),
            loading: () {
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
