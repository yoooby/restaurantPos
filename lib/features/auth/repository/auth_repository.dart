import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:restaurent_pos/common/failure.dart';
import 'package:restaurent_pos/common/type_defs.dart';
import 'package:restaurent_pos/shared/models/user.dart';
import 'package:restaurent_pos/shared/providers/firebase.dart';

final AuthRepositoryProvider = Provider<AuthRepository>((ref) {
  final firestore = ref.watch(fireStoreProvider);
  return AuthRepository(firestore: firestore);
});

class AuthRepository {
  final FirebaseFirestore _firestore;

  AuthRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid addUser(String name, int pin, Role role) async {
    // add user to the firestore
    try {
      return right(_firestore.collection('users').doc(name).set({
        'name': name,
        'pin': pin,
        'role': role.index,
      }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<User> getUser(int pin) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('pin', isEqualTo: pin)
          .get();
      if (snapshot.docs.isEmpty) {
        return left(Failure('User not found'));
      }
      final user = snapshot.docs.first;
      return right(
          User(name: user['name'], role: Role.values[user['role'] as int]));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid deleteUser(String name) async {
    try {
      return right(_firestore.collection('users').doc(name).delete());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid updateUser(String name, int pin, Role role) async {
    try {
      return right(_firestore.collection('users').doc(name).update({
        'name': name,
        'pin': pin,
        'role': role.index,
      }));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List<User>> getUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      final users = snapshot.docs
          .map(
              (e) => User(name: e['name'], role: Role.values[e['role'] as int]))
          .toList();
      return right(users);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  // login
  FutureEither<User> login(String name, int pin) async {
    try {
      final snapshot = await _firestore.collection('users').doc(name).get();
      // check if pin is correct
      if (snapshot['pin'] != pin) {
        return left(Failure('Invalid pin'));
      }

      final user = snapshot.data()!;
      return right(
          User(name: user['name'], role: Role.values[user['role'] as int]));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
