import 'package:cloud_firestore/cloud_firestore.dart';

class FactModel {
  final String username;
  final String uid;
  final String facts;
  final String factId;
  final String datePublished;
  // final String factUrl;
  final String email;
  // final List datePublished;
  final String profilePic;
  final likes;

  FactModel({
    required this.username,
    required this.uid,
    required this.facts,
    required this.factId,
    // required this.factUrl,
    required this.datePublished,
    required this.likes,
    required this.profilePic,
    required this.email,
  });

  get isNotEmpty => null;
  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'facts': facts,
        'factId': factId,
        // 'factUrl': factUrl,
        'profilePic': profilePic,
        'likes': likes,
        'datePublished': datePublished,
        'email': email,
      };

  static FactModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return FactModel(
      username: snapshot['username'],
      uid: snapshot['uid'],
      facts: snapshot['facts'],
      factId: snapshot['factId'],
      // factUrl: snapshot['factUrl'],
      datePublished: snapshot['datePublished'],
      profilePic: snapshot['profilePic'],
      likes: snapshot['likes'],
      email: snapshot['email'],
    );
  }
}
