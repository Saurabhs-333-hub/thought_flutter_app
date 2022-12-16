import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thought/resources/storageMethod.dart';
import 'package:thought/resources/storageMethod.dart';
import 'package:thought/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    return model.UserModel.fromSnap(snap);
  }

  Future signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Something Went Wrong!";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.email);
        String photoUrl =
            await StorageMethod().uploadToStorage("profilePic", file, false);
        model.UserModel user = model.UserModel(
            username: username,
            bio: bio,
            email: email,
            followers: [],
            following: [],
            profilePic: photoUrl,
            uid: cred.user!.uid);
        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        print(cred);
        res = "success";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future signInUser({
    required String email,
    required String password,
  }) async {
    String res = "Something Went Wrong!";
    try {
      if (email != null || password != null) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        res = "Please enter all the fields";
      }
      res = 'success';
    } catch (e) {
      return e.toString();
    }
  }
}
