// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:restaurent_pos/theme/palette.dart';
// flutter_riverpod
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/view/core/appbar.dart';
import 'package:restaurent_pos/view/menu/menu.dart';
import 'package:restaurent_pos/view/payment/paymentBar.dart';
import 'package:restaurent_pos/view/tables/tables_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
            drawer: Drawer(
              backgroundColor: Palette.drawerColor,
              child: // checkout, tables, orders, tools
                  ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Palette.drawerColor,
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        color: Palette.textColor,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Checkout',
                      style: TextStyle(
                        color: Palette.textColor,
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      'Tables',
                      style: TextStyle(
                        color: Palette.textColor,
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      'Orders',
                      style: TextStyle(
                        color: Palette.textColor,
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    title: Text(
                      'Tools',
                      style: TextStyle(
                        color: Palette.textColor,
                        fontSize: 20,
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            // check out, tables, orders, tools with Pallete.txtcolor
            backgroundColor: Palette.backgroundColor,
            body: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        TopBar(), // divider
                        const TablesScreen(),
                      ],
                    )),
                Expanded(child: const PaymentBar()),
              ],
            )),
      ),
    );
  }
}
