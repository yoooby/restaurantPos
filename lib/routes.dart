// routemaster
import 'package:flutter/material.dart';
import 'package:restaurent_pos/main.dart';
import 'package:restaurent_pos/view/menu/menu.dart';
import 'package:restaurent_pos/view/orders/payment_screen.dart';
import 'package:restaurent_pos/view/tables/tables_screen.dart';
import 'package:routemaster/routemaster.dart';

// cashier routes, admin routes both have login

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: MainApp()),
});

final cashierRoutes = RouteMap(routes: {
  '/': (_) => const Redirect('/tables'),
  '/menu': (_) => MaterialPage(child: Menu()),
  "/tables": (_) => const MaterialPage(child: TablesScreen()),
  // '/menu/:category
  "/menu/:category": (route) {
    final category = route.pathParameters['category'];
    return MaterialPage(
        child: Menu(
      category: category,
    ));
  },
  // payment
  "/payment": (_) => const MaterialPage(child: PaymentScreen()),
});
