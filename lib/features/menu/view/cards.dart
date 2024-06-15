// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/common/utils.dart';
import 'package:restaurent_pos/shared/providers/current_order_provider.dart';
import 'package:restaurent_pos/shared/models/item.dart';
import 'package:restaurent_pos/shared/providers/current_selected_table.dart';
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
            showErrorSnackBar(context, "Please select a table");
            return;
          }
          ref.watch(currentOrderProvider.notifier).addItem(item);
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
  final int? count;
  final VoidCallback onTap;
  const CategoryCard(
      {super.key, this.category, required this.onTap, this.count});

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
