import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String id;
  final String username;
  final String email;
  // final String photoUrl;
  final String name;
  final int age;
  final String bio;

  MyUser({
    required this.id,
    required this.username,
    required this.email,
    // required this.photoUrl,
    required this.name,
    required this.age,
    required this.bio,
  });

  factory MyUser.fromDocument(DocumentSnapshot doc) {
    return MyUser(
      id: (doc.data() as dynamic)['id'],
      username: (doc.data() as dynamic)['username'],
      email: (doc.data() as dynamic)['email'],
      // photoUrl: (doc.data() as dynamic)['photoUrl'],
      name: (doc.data() as dynamic)['name'],
      age: (doc.data() as dynamic)['age'],
      bio: (doc.data() as dynamic)['bio'],
    );
  }
}
