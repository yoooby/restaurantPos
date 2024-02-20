// routemaster
import 'package:flutter/material.dart';
import 'package:restaurent_pos/view/login/login_screen.dart';
import 'package:restaurent_pos/view/menu/menu.dart';
import 'package:restaurent_pos/view/orders/orders_screen.dart';
import 'package:restaurent_pos/view/orders/payment_screen.dart';
import 'package:restaurent_pos/view/tables/tables_screen.dart';
import 'package:routemaster/routemaster.dart';

// cashier routes, admin routes both have login

final loggedOutRoute = RouteMap(routes: {
  // redirect to login
  '/login': (_) => const MaterialPage(child: LoginScreen()),
  // redirect non found routes to login
  '/:path*': (_) => const Redirect('/login'),
  "/": (_) => const Redirect('/login'),
});

final cashierRoutes = RouteMap(routes: {
  // redirect all non found routes to tables
  '/:path*': (_) => const Redirect('/'),
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

  "/orders": (_) => const MaterialPage(child: OrdersScreen()),
});
