import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/controllers/core_controller.dart';
import 'package:restaurent_pos/models/table.dart';
import 'package:restaurent_pos/theme/palette.dart';

class TablesScreen extends ConsumerWidget {
  const TablesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.watch(tablesListProvider);
    return Expanded(
        child: tables.when(data: (List<Booth> data) {
      return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return TableIcon(
            () {
              ref
                  .watch(currentSelectedTableProvider.notifier)
                  .update((state) => data[index]);
            },
            tableNumber: data[index].name,
            hasOrder: data[index].orderId == null
                ? false
                : true, // TODO: check if table has order or not,
            isSelected: ref.watch(currentSelectedTableProvider) == data[index],
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
    }));
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
