// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomCategoryBar extends ConsumerWidget {
  const BottomCategoryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        height: 20,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'ALl',
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              Text(
                'Dishes',
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              Text(
                'Drinks',
                style: TextStyle(fontSize: 20),
              ),
              Spacer(),
              Text(
                'Desserts',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ));
  }
}
