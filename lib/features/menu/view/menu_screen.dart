// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/common/drawer.dart';
import 'package:restaurent_pos/shared/models/item.dart';
import 'package:restaurent_pos/theme/palette.dart';
import 'package:restaurent_pos/shared/view/appbar.dart';
import 'package:restaurent_pos/features/menu/view/bottom_category_bar.dart';
import 'package:restaurent_pos/features/menu/view/cards.dart';
import 'package:restaurent_pos/shared/view/order_bar.dart';
import 'package:restaurent_pos/features/tables/view/tables_screen.dart';
import 'package:routemaster/routemaster.dart';

import '../controller/menu_controller.dart';

class Menu extends ConsumerWidget {
  String? category;
  Menu({
    this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(itemsListProvider);
    return SafeArea(
      child: Scaffold(
          drawer: buildDrawer(ref, context),
          backgroundColor: Palette.backgroundColor,
          body: Row(
            children: [
              Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      TopBar(),
                      Expanded(
                          child: data.when(
                              data: (List<Item> items) {
                                if (category != null) {
                                  items = items
                                      .where((element) =>
                                          element.category == category)
                                      .toList();
                                } else if (category == null) {
                                  return _buildCategoryGrid(ref, context);
                                }
                                // Items list
                                return GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4),
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return CategoryCard(onTap: () {
                                          Routemaster.of(context).pop();
                                        });
                                      }
                                      return ItemCard(items[index - 1]);
                                    },
                                    itemCount:
                                        items.length + 1 // for the back button,
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

  Widget _buildCategoryGrid(WidgetRef ref, BuildContext context) {
    final categories = ref.watch(categoriesListProvider);
    return categories.when(data: (List<Map<String, int>> data) {
      return GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
          itemBuilder: (context, index) {
            return CategoryCard(
              onTap: () => Routemaster.of(context)
                  .push('/menu/${data[index].keys.first}'),
              category: data[index].keys.first,
            );
          },
          itemCount: data.length);
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
    });
  }
}
