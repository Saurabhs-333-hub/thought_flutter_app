import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thought/models/fact.dart';
import 'package:thought/models/post.dart';
import 'package:thought/models/story.dart';
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
      String size,
      String font) async {
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
          size: size,
          font: font);
      await _firestore.collection('posts').doc(postId).set(post.toJson());
      String res = 'success';
    } catch (e) {
      print(e.toString());
    }
  }

  Future uploadFact(
    String facts,
    // Uint8List file,
    String uid,
    String username,
    String profilePic,
    String email,
    String size,
    String font,
    String color1,
    String color2,
    String textColor,
  ) async {
    try {
      // String pic =
      //     await StorageMethod().uploadToStorage("factImage", file, true);
      String factId = Uuid().v1();
      FactModel fact = FactModel(
          username: username,
          uid: uid,
          facts: facts,
          factId: factId,
          // factUrl: pic,
          datePublished: DateTime.now().toString(),
          likes: [],
          profilePic: profilePic,
          email: email,
          size: size,
          font: font,
          color1: color1,
          color2: color2,
          textColor:textColor);
      await _firestore.collection('facts').doc(factId).set(fact.toJson());
      String res = 'success';
    } catch (e) {
      print(e.toString());
    }
  }

  Future uploadStory(
      String stories,
      // Uint8List file,
      String uid,
      String username,
      String profilePic,
      String email,
      String size,
      String font,
      String color1,
    String color2,) async {
    try {
      // String pic =
      //     await StorageMethod().uploadToStorage("factImage", file, true);
      String storyId = Uuid().v1();
      StoryModel story = StoryModel(
          username: username,
          uid: uid,
          stories: stories,
          storyId: storyId,
          // factUrl: pic,
          datePublished: DateTime.now().toString(),
          likes: [],
          profilePic: profilePic,
          email: email,
          size: size,
          font: font,
          color1: color1,
          color2: color2);
      await _firestore.collection('stories').doc(storyId).set(story.toJson());
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

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
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

  Future<void> deleteFact(factId) async {
    try {
      await FirebaseFirestore.instance.collection('facts').doc(factId).delete();
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(factId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteStory(storyId) async {
    try {
      await FirebaseFirestore.instance
          .collection('stories')
          .doc(storyId)
          .delete();
      await FirebaseFirestore.instance
          .collection('stories')
          .doc(storyId)
          .collection('comments')
          .doc(commentId)
          .delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
