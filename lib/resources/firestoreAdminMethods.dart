// ignore_for_file: prefer_const_constructors, file_names, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:thought/models/post.dart';
import 'package:thought/models/quotePostSuggestions.dart';
import 'package:thought/resources/storageMethod.dart';
import 'package:thought/screens/uploadQuoteSuggestions.dart';
import 'package:uuid/uuid.dart';

class FirestoreAdminMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future uploadQuotePostSuggestionsPost(
    // String thoughts,
    File? file,
    String uid,
    String username,
    String profilePic,
    String email,
  ) async {
    try {
      String pic = await StorageMethod()
          .uploadToStorage1("quoteImage", imageFile!, true);
      String quotePostId = Uuid().v1();
      QuotePostSuggestions quotePost = QuotePostSuggestions(
        username: username,
        uid: uid,
        // thoughts: thoughts,
        postId: quotePostId,
        postUrl: pic,
        datePublished: DateTime.now().toString(),
        // likes: [],
        profilePic: profilePic,
        email: email,
      );
      await _firestore
          .collection('quotePostSuggestions')
          .doc(quotePostId)
          .set(quotePost.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  List values1 = [];
  Future<void> readLoacationData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc('2utCPTr9wJhB8V6bJ3CnigqFwt03')
        .get()
        .then((value) {
      List<String> values = List.from((value.data() as dynamic)['followers']);
      values1.add(values.every((element) => true));
      return values;
    });
    print(values1);
// query.

    // print(values);

    // query.snapshots().
  }
}
