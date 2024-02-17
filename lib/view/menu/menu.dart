// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/theme/palette.dart';
import 'package:restaurent_pos/view/menu/bottom_category_bar.dart';
import 'package:restaurent_pos/view/menu/cards.dart';

class Menu extends ConsumerWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
        child: GridView(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      children: [
        CategoryCard(),
        ItemCard("4 Seasons", 20.0, "Pizza"),
        ItemCard("Margherita", 15.0, "Pizza"),
        ItemCard("4 Cheese", 60, "Pizza"),
        ItemCard("Royal", 20.0, "Pizza"),
        ItemCard("Pepperoni", 20.0, "Pizza"),
      ],
    ));
  }
}
