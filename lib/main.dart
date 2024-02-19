// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:restaurent_pos/controllers/core_controller.dart';
import 'package:restaurent_pos/firebase_options.dart';
import 'package:restaurent_pos/models/item.dart';
import 'package:restaurent_pos/models/table.dart';
import 'package:restaurent_pos/models/user.dart';
import 'package:restaurent_pos/routes.dart';
import 'package:restaurent_pos/theme/palette.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/view/core/appbar.dart';
import 'package:restaurent_pos/view/menu/menu.dart';
import 'package:restaurent_pos/view/orders/order_bar.dart';
import 'package:restaurent_pos/view/tables/tables_screen.dart';
import 'package:routemaster/routemaster.dart';

final userProvider = StateProvider<User?>((ref) => null);

final _isAuthenticateProvider =
    Provider<bool>((ref) => ref.watch(userProvider) == null ? false : true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(
    child: MainApp(),
  ));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Restaurant POS',
      routeInformationParser: RoutemasterParser(),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        if (ref.watch(_isAuthenticateProvider)) {
          return cashierRoutes;
        } else {
          return loggedOutRoute;
        }
      }),
    );
  }
}



// SafeArea(
//         child: Scaffold(
//             drawer: Drawer(
//               backgroundColor: Palette.drawerColor,
//             ),
//             // check out, tables, orders, tools with Pallete.txtcolor
//             backgroundColor: Palette.backgroundColor,
//             body: Row(
//               children: [
//                 Expanded(
//                     flex: 3,
//                     child: Column(
//                       children: [
//                         TopBar(),
//                         const TablesScreen(),
//                       ],
//                     )),
//                 Expanded(child: const OrderBar()),
//               ],
//             )),
//       ),
//     );
//   }