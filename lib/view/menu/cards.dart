// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/theme/palette.dart';

class ItemCard extends ConsumerWidget {
  final String foodName;
  final double price;
  final String category;
  const ItemCard(this.foodName, this.price, this.category, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {},
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
                  category,
                  style: TextStyle(color: Colors.grey),
                ),
                Spacer(),
                Text(
                  foodName,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text("\$" + price.toString(), style: TextStyle(fontSize: 20)),
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
  const CategoryCard({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: InkWell(
        onTap: () {},
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
