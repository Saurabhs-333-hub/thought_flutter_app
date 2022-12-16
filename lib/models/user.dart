import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String username;
  final String uid;
  final String bio;
  final String email;
  final List followers;
  final List following;
  final String profilePic;

  UserModel(
      {required this.username,
      required this.uid,
      required this.bio,
      required this.email,
      required this.followers,
      required this.following,
      required this.profilePic});

  get isNotEmpty => null;
  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'bio': bio,
        'email': email,
        'followers': followers,
        'following': following,
        'profilePic': profilePic
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
        username: snapshot['username'],
        uid: snapshot['uid'],
        bio: snapshot['bio'],
        email: snapshot['email'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        profilePic: snapshot['profilePic']);
  }
}
