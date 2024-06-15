// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurent_pos/firebase_options.dart';
import 'package:restaurent_pos/shared/models/user.dart';
import 'package:restaurent_pos/routes.dart';
import 'package:restaurent_pos/theme/palette.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

final userProvider = StateProvider<User?>((ref) => null);

final _isAuthenticateProvider = Provider<bool>((ref) {
  ref.watch(userProvider);
  return ref.watch(userProvider) == null ? false : true;
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(
    child: MainApp(),
  ));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('is auth: ${ref.watch(_isAuthenticateProvider)}');
    // return MaterialApp(
    //   theme: Palette().lightTheme,
    //   debugShowCheckedModeBanner: false,
    //   title: 'Restaurant POS',
    //   home: Scaffold(
    //     body: OrdersScreen(),
    //   ),
    // );
    return MaterialApp.router(
      theme: Palette().lightTheme,
      debugShowCheckedModeBanner: false,
      title: 'Restaurant POS',
      routeInformationParser: RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        if (ref.read(_isAuthenticateProvider)) {
          return cashierRoutes;
        } else {
          return loggedOutRoute;
        }
      }),
    );
  }
}
