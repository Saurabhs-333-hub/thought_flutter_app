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
  final String size;
  final String font;
  final String color1;
  final String color2;
  final String textColor;

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
    required this.size,
    required this.font,
    required this.color1,
    required this.color2,
    required this.textColor,
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
        'size': size,
        'font': font,
        'color1': color1,
        'color2': color2,
        'textColor': textColor
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
        size: snapshot['size'],
        font: snapshot['font'],
        color1: snapshot['color1'],
        color2: snapshot['color2'],
        textColor: snapshot['textColor']);
  }
}
