import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMethod {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Future<String> uploadToStorage(
      String childname, Uint8List file, bool isPost) async {
    Reference ref = await _storage
        .ref()
        .child(childname)
        .child(FirebaseAuth.instance.currentUser!.uid);
    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snap = await uploadTask;
    String pic = await snap.ref.getDownloadURL();
    return pic;
  }

  Future<String> uploadToStorage1(
      String childname, File file, bool isPost) async {
    Reference ref = await _storage
        .ref()
        .child(childname)
        .child(FirebaseAuth.instance.currentUser!.uid);
    if (isPost) {
      String id = Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putFile(file);
    TaskSnapshot snap = await uploadTask;
    String pic = await snap.ref.getDownloadURL();
    return pic;
  }
}
