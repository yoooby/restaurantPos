// routemaster
import 'package:flutter/material.dart';
import 'package:restaurent_pos/main.dart';
import 'package:restaurent_pos/view/menu/menu.dart';
import 'package:restaurent_pos/view/tables/tables_screen.dart';
import 'package:routemaster/routemaster.dart';

// cashier routes, admin routes both have login

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: MainApp()),
});

final cashierRoutes = RouteMap(routes: {
  '/': (_) => const Redirect('/tables'),
  '/menu': (_) => const MaterialPage(child: Menu()),
  "/tables": (_) => const MaterialPage(child: TablesScreen()),
});
