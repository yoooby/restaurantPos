// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/common/drawer.dart';
import 'package:restaurent_pos/common/failure.dart';
import 'package:restaurent_pos/controllers/auth_controller.dart';
import 'package:restaurent_pos/main.dart';
import 'package:restaurent_pos/models/user.dart';
import 'package:restaurent_pos/theme/palette.dart';
import 'package:restaurent_pos/view/core/appbar.dart';
import 'package:routemaster/routemaster.dart';

final _currentSelectedUser = StateProvider<User?>((ref) => null);
// text controller autodispot
final _pinController = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier);
    final usersList = ref.watch(userListProvider(context));
    return Scaffold(
        drawer: buildDrawer(ref, context),
        backgroundColor: Palette.backgroundColor,
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Welcome',
                          style: TextStyle(
                              fontSize: 30,
                              color: Palette.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        // show all items in userlist

                        Expanded(
                          child: usersList.when(
                              data: (users) {
                                return ListView.builder(
                                    itemCount: users.length,
                                    itemBuilder: (context, index) {
                                      return _buildUserTile(users[index], ref);
                                    });
                              },
                              loading: () => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              error: (error, stack) {
                                if (error is Failure) {
                                  return Center(
                                    child: Text(error.message),
                                  );
                                }
                                return Center(
                                  child: Text('Something went wrong'),
                                );
                              }),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Container(
                    color: Palette.drawerColor,
                    child: Center(child: PinKeyPad()),
                  )),
            ],
          ),
        ));
  }

  _buildUserTile(User user, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          ref.watch(_currentSelectedUser.notifier).state = user;
        },
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: CircleAvatar(
            backgroundColor: Palette.textColor,
            child: Text(
              user.name[0],
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          tileColor: ref.watch(_currentSelectedUser) == user
              ? Palette.primaryColor
              : Palette.drawerColor,
          title: Text(user.name, style: TextStyle(color: Colors.white)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}

class PinKeyPad extends ConsumerStatefulWidget {
  PinKeyPad({super.key});

  void login(
      BuildContext context, WidgetRef ref, TextEditingController controller) {
    final user = ref.watch(_currentSelectedUser);
    if (user != null && controller.text.length == 4) {
      ref
          .read(authControllerProvider.notifier)
          .login(context, user.name, int.parse(controller.text));
      controller.clear();
    }
  }

  void updateText(String text, TextEditingController controller) {
    controller.text += text;
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PinKeyPadState();
}

class _PinKeyPadState extends ConsumerState<PinKeyPad> {
  final TextEditingController controller = TextEditingController();

  // dispose
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Enter Pin',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 4; i++)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        // length of pin is white
                        color: controller.text.length > i
                            ? Colors.white
                            : Colors.white.withOpacity(.5),
                        shape: BoxShape.circle),
                  )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // hidden pin dot
            Expanded(
              child: LayoutBuilder(
                  builder: (context, constraints) => ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: constraints.maxWidth / 2,
                            maxHeight: constraints.maxHeight),
                        child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                            ),
                            itemCount: 12,
                            itemBuilder: (BuildContext context, int index) {
                              switch (index) {
                                case 11:
                                  return _buildKeyNumber("delete", ref, () {
                                    setState(() {
                                      if (controller.text.isNotEmpty) {
                                        controller.text = controller.text
                                            .substring(
                                                0, controller.text.length - 1);
                                      }
                                    });
                                  });
                                case 10:
                                  return _buildKeyNumber("0", ref, () {
                                    setState(() {
                                      controller.text = "${controller.text}0";
                                      widget.login(context, ref, controller);
                                    });
                                  });
                                case 9:
                                  if (Routemaster.of(context)
                                      .currentRoute
                                      .path
                                      .contains("login")) {
                                    _buildKeyNumber(".", ref, () {
                                      controller.text = "${controller.text}.";
                                      widget.login(context, ref, controller);
                                    });
                                  } else {
                                    return Container(
                                      color: Colors.transparent,
                                    );
                                  }
                                default:
                                  return _buildKeyNumber(
                                      (index + 1).toString(), ref, () {
                                    setState(() {
                                      controller.text = controller.text +
                                          (index + 1).toString();
                                      widget.login(context, ref, controller);
                                    });
                                  });
                              }
                            }),
                      )),
            )
          ]),
    );
  }

  _buildKeyNumber(String btn, WidgetRef ref, VoidCallback onTap) {
    final user = ref.watch(_currentSelectedUser);
    return Material(
      child: InkWell(
        onTap: ref.watch(_currentSelectedUser) == null ? null : onTap,
        child: Ink(
          color: Palette.textColor,
          child: Center(
            child: btn != "delete"
                ? Text(
                    btn,
                    style: TextStyle(
                        color: Colors.white.withOpacity(.8), fontSize: 20),
                  )
                : Icon(Icons.backspace),
          ),
        ),
      ),
    );
  }
}
