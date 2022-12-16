import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thought/models/post.dart';
import 'package:thought/resources/storageMethod.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future uploadPost(
    String thoughts,
    Uint8List file,
    String uid,
    String username,
    String profilePic,
    String email,
  ) async {
    try {
      String pic =
          await StorageMethod().uploadToStorage("postImage", file, true);
      String postId = Uuid().v1();
      PostModel post = PostModel(
        username: username,
        uid: uid,
        thoughts: thoughts,
        postId: postId,
        postUrl: pic,
        datePublished: DateTime.now().toString(),
        likes: [],
        profilePic: profilePic,
        email: email,
      );
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      String res = 'success';
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  String commentId = Uuid().v1();
  Future postComment(String postId, String text, String uid, String profilePic,
      String name) async {
    try {
      if (text.isNotEmpty) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now()
        });
      } else {
        print("Text is Empty");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
