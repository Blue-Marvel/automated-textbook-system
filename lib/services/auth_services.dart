import 'package:automated_texbook_system/model/librarian.dart';
import 'package:automated_texbook_system/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static final AuthServices _instance = AuthServices._internal();
  factory AuthServices() => _instance;
  AuthServices._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> studentRegister(
      UserModel userModel, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userModel.email, password: password);
      final uid = userCredential.user!.uid;

      final updateUser = userModel.copyWith(id: uid.toString());

      await _firestore.collection('students').doc(uid).set(updateUser.toMap());
      return updateUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<Librarian> librarianRegister(
      Librarian librarian, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: librarian.email, password: password);
      final uid = userCredential.user!.uid;

      var updateLibrarian = librarian.copyWith(id: () => uid.toString());
      await _firestore
          .collection('librarians')
          .doc(uid)
          .set(updateLibrarian.toMap());
      return updateLibrarian;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> studentLogin(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final uid = userCredential.user!.uid;

      final userData = await _firestore.collection('students').doc(uid).get();
      final userDataMap = userData.data() as Map<String, dynamic>;

      return UserModel.fromMap(userDataMap);
    } catch (e) {
      rethrow;
    }
  }

  Future<Librarian> librarianLogin(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final uid = userCredential.user!.uid;

      final userData = await _firestore.collection('librarians').doc(uid).get();
      final userDataMap = userData.data() as Map<String, dynamic>;

      return Librarian.fromMap(userDataMap);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
