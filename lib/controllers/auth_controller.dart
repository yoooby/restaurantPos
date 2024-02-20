// auth controller state notifier

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:restaurent_pos/common/utils.dart';
import 'package:restaurent_pos/main.dart';
import 'package:restaurent_pos/models/user.dart';
import 'package:restaurent_pos/repository/auth_repository.dart';

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) {
    final authRepository = ref.watch(AuthRepositoryProvider);
    return AuthController(ref, authRepository);
  },
);

// getusers method provider
final userListProvider = FutureProvider.autoDispose
    .family<List<User>, BuildContext>((ref, contex) =>
        ref.watch(authControllerProvider.notifier).getUsers(contex));

class AuthController extends StateNotifier<bool> {
  final Ref _ref;
  final AuthRepository _authRepository;

  AuthController(this._ref, this._authRepository) : super(false);

  // get users list getUsers methld
  Future<List<User>> getUsers(BuildContext context) async {
    final result = await _authRepository.getUsers();
    return result.fold((l) {
      // show snackbar
      showErrorSnackBar(context, l.message);
      return [];
    }, (r) {
      return r;
    });
  }

  // add user method
  Future<void> addUser(BuildContext context, User user, int pin) async {
    state = true;
    final result = await _authRepository.addUser(user.name, pin, user.role);
    state = false;
    result.fold((l) {
      showErrorSnackBar(context, l.message);
    }, (r) {
      showSuccessSnackBar(context, 'User added successfully');
    });
  }

  // login
  void login(BuildContext context, String name, int pin) async {
    state = true;
    final result = await _authRepository.login(name, pin);
    state = false;
    result.fold((l) {
      return showErrorSnackBar(context, l.message);
    }, (r) {
      _ref.read(userProvider.notifier).state = r;
    });
  }
}
