import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String username;
  final String uid;
  final String stories;
  final String storyId;
  final String datePublished;
  // final String storyUrl;
  final String email;
  // final List datePublished;
  final String profilePic;
  final likes;
  final String size;
  final String font;
  final String color1;
  final String color2;
  StoryModel(
      {required this.username,
      required this.uid,
      required this.stories,
      required this.storyId,
      // required this.storyUrl,
      required this.datePublished,
      required this.likes,
      required this.profilePic,
      required this.email,
      required this.size,
      required this.font,
      required this.color1,
      required this.color2});

  get isNotEmpty => null;
  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'stories': stories,
        'storyId': storyId,
        // 'storyUrl': storyUrl,
        'profilePic': profilePic,
        'likes': likes,
        'datePublished': datePublished,
        'email': email,
        'size': size,
        'font': font,
        'color1': color1,
        'color2': color2
      };

  static StoryModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return StoryModel(
        username: snapshot['username'],
        uid: snapshot['uid'],
        stories: snapshot['stories'],
        storyId: snapshot['storyId'],
        // storyUrl: snapshot['storyUrl'],
        datePublished: snapshot['datePublished'],
        profilePic: snapshot['profilePic'],
        likes: snapshot['likes'],
        email: snapshot['email'],
        size: snapshot['size'],
        font: snapshot['font'],
        color1: snapshot['color1'],
        color2: snapshot['color2']);
  }
}
