import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String username;
  final String uid;
  final String thoughts;
  final String postId;
  final String datePublished;
  final String postUrl;
  final String email;
  // final List datePublished;
  final String profilePic;
  final likes;
  final String size;

  PostModel({
    required this.username,
    required this.uid,
    required this.thoughts,
    required this.postId,
    required this.postUrl,
    required this.datePublished,
    required this.likes,
    required this.profilePic,
    required this.email,
    required this.size,
  });

  get isNotEmpty => null;
  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'thoughts': thoughts,
        'postId': postId,
        'postUrl': postUrl,
        'profilePic': profilePic,
        'likes': likes,
        'datePublished': datePublished,
        'email': email,
        'size': size
      };

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      username: snapshot['username'],
      uid: snapshot['uid'],
      thoughts: snapshot['thoughts'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
      datePublished: snapshot['datePublished'],
      profilePic: snapshot['profilePic'],
      likes: snapshot['likes'],
      email: snapshot['email'],
      size: snapshot['size'],
    );
  }
}
