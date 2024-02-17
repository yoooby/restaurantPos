import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/theme/palette.dart';

class TablesScreen extends ConsumerWidget {
  const TablesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: GridView(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6),
        children: [
          TableIcon("T1", true, true),
          TableIcon("T2", false, false),
          TableIcon("T3", false, false),
          TableIcon("T4", false, false),
          TableIcon("T5", true, false),
          TableIcon("T6", false, false),
          TableIcon("T7", false, false),
          TableIcon("T8", false, false),
          TableIcon("T9", true, false),
          TableIcon("T10", false, false),
        ],
      ),
    );
  }
}

class TableIcon extends ConsumerWidget {
  final bool hasOrder;
  final bool isSelected;
  final String tableNumber;
  const TableIcon(this.tableNumber, this.hasOrder, this.isSelected,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: isSelected ? Palette.primaryColor : Palette.backgroundColor,
      elevation: 0,
      child: InkWell(
        onTap: () {},
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
