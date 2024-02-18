// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/controllers/core_controller.dart';
import 'package:restaurent_pos/controllers/orders.dart';
import 'package:restaurent_pos/models/item.dart';
import 'package:restaurent_pos/theme/palette.dart';

class ItemCard extends ConsumerWidget {
  final Item item;

  const ItemCard(this.item);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {
          if (ref.watch(currentSelectedTableProvider) == null) {
            return;
          }
          ref.watch(currentOrderProvider.notifier).addItem(item);
          print("Item added to order");
        },
        child: Card(
          surfaceTintColor: Colors.white,
          borderOnForeground: false,
          elevation: 3,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  item.category,
                  style: TextStyle(color: Colors.grey),
                ),
                Spacer(),
                Text(
                  item.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text("\$" + item.price.toString(),
                    style: TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String? category;
  final VoidCallback onTap;
  const CategoryCard({super.key, this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Card(
          surfaceTintColor: Colors.white,
          borderOnForeground: false,
          elevation: 3,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              // if category is null then an icon will be displayed
              child: category == null
                  ? Icon(
                      Icons.arrow_back,
                      size: 40,
                      color: Palette.primaryColor,
                    )
                  : Text(
                      category!,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
