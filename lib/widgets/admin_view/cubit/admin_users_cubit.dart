import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../login/login.dart';
import 'admin_users_states.dart';

class AdminUsersCubit extends Cubit<AdminUsersState> {
  AdminUsersCubit() : super(AdminUsersInitialState()) {
    // load users immediately when cubit is created (global provider in main.dart)
    fetchUsers();
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> createUser({
    required BuildContext context,
    required String email,
    required String password,
    required String role,
    String? name,
    String? phone,
    String? bankName,
    String? branchName,
    String? managerName,
    String? managerPhone,
    String? branchAddress,
    String? jobTitle,
  }) async {
    try {
      emit(AdminUsersLoadingState());
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      final data = <String, dynamic>{
        'userID': uid,
        'email': email,
        'role': role,
        'createdAt': DateTime.now().toIso8601String(),
      };

      if (role == 'Bank') {
        data.addAll({
          'bankName': bankName ?? '',
          'branchName': branchName ?? '',
          'managerName': managerName ?? '',
          'managerPhone': managerPhone ?? '',
          'branchAddress': branchAddress ?? '',
        });
      } else if (role == 'Technician') {
        data.addAll({
          'name': name ?? '',
          'jobTitle': jobTitle ?? '',
          'phone': phone ?? '',
        });
      } else {
        // default for other roles
        data.addAll({
          'name': name ?? '',
          'phone': phone ?? '',
        });
      }

      await _firestore.collection('users').doc(uid).set(data);

      // refresh list
      await fetchUsers();
    } catch (e) {
      emit(AdminUsersErrorState(e.toString()));
    }
  }

  Future<void> fetchUsers() async {
    try {
      emit(AdminUsersLoadingState());
      final snapshot = await _firestore.collection('users').get();

      // Convert documents to maps
      final allUsers = snapshot.docs.map((d) => d.data()).toList();

      // ✅ Filter: only show "Bank" and "Technician"
      final filteredUsers = allUsers.where((user) {
        final role = (user['role'] ?? '').toString().toLowerCase();
        return role == 'bank' || role == 'technician';
      }).toList();

      emit(AdminUsersLoadedState(List<Map<String, dynamic>>.from(filteredUsers)));
    } catch (e) {
      emit(AdminUsersErrorState(e.toString()));
    }
  }

  //
  // Future<void> fetchUsers() async {
  //   try {
  //     emit(AdminUsersLoadingState());
  //     final snapshot = await _firestore.collection('users').get();
  //     final users = snapshot.docs.map((d) => d.data()).toList();
  //     emit(AdminUsersLoadedState(List<Map<String, dynamic>>.from(users)));
  //   } catch (e) {
  //     emit(AdminUsersErrorState(e.toString()));
  //   }
  // }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>const LoginScreen()), (route) => false,);
  }
}
//                       onPressed: () {
//                         FirebaseAuth.instance.signOut().then((value) {
//                           Navigator.pushAndRemoveUntil(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const LoginScreen(),
//                             ),
//                                 (route) => false,
//                           );
//                         });
//                       },
