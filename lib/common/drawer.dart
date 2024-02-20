import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

Widget buildDrawer(WidgetRef ref, BuildContext context) {
  return Drawer(
    backgroundColor: Palette.drawerColor,
    child: Column(
      children: [
        _buildDrawerListTile('Tables', () {
          Routemaster.of(context).replace('/tables');
        }, Icons.table_bar_sharp),
        _buildDrawerListTile('Menu', () {
          Routemaster.of(context).replace('/menu');
        }, Icons.menu_book_outlined),
        _buildDrawerListTile('Payment', () {
          Routemaster.of(context).replace('/payment');
        }, Icons.payment_outlined),
        _buildDrawerListTile('Orders', () {
          Routemaster.of(context).replace('/orders');
        }, Icons.shopping_cart_outlined),
      ],
    ),
  );
}

_buildDrawerListTile(String title, VoidCallback onTap, IconData? icon) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: ListTile(
      leading: Icon(icon, color: Colors.white.withOpacity(.3)),
      title: Text(title,
          style: TextStyle(color: Colors.white.withOpacity(.3), fontSize: 20)),
      onTap: onTap,
    ),
  );
}
