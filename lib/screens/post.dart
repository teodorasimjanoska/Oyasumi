import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oyasumi/models/user.dart';
import 'package:oyasumi/screens/register_page.dart';
import 'package:oyasumi/widgets/custom_image.dart';
import 'package:oyasumi/widgets/my_circular_progress.dart';

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;

  Post({
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.location,
    required this.description,
    required this.mediaUrl,
  });

  factory Post.fromDocument(DocumentSnapshot doc) {
    return Post(
      postId: doc['postId'],
      ownerId: doc['ownerId'],
      username: doc['username'],
      location: doc['location'],
      description: doc['description'],
      mediaUrl: doc['mediaUrl'],
    );
  }

  @override
  State<Post> createState() => _PostState(
        postId: this.postId,
        ownerId: this.ownerId,
        username: this.username,
        location: this.location,
        description: this.description,
        mediaUrl: this.mediaUrl,
      );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  final String username;
  final String location;
  final String description;
  final String mediaUrl;

  _PostState({
    required this.postId,
    required this.ownerId,
    required this.username,
    required this.location,
    required this.description,
    required this.mediaUrl,
  });

  buildPostHeader() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress(context);
        }
        MyUser user =
            MyUser.fromDocument(snapshot.data as DocumentSnapshot<Object?>);
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage("lib/images/default_profile_pic.png"),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () {},
            child: Text(
              user.username,
              style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold),
            ),
          ),
          subtitle: Text(location),
        );
      },
      future: usersRef.doc(ownerId).get(),
    );
  }

  buildPostImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        cachedNetworkImage(mediaUrl),
      ],
    );
  }

  buildPostFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 40,
                left: 20,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.favorite_rounded,
                size: 28,
                color: Colors.pinkAccent,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 40,
                right: 20,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.chat_bubble_rounded,
                size: 28,
                color: Color(0xffE0D1F3),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(left: 20),
              child: Text(
                "$username",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(description),
            ),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildPostHeader(),
        buildPostImage(),
        buildPostFooter(),
      ],
    );
  }
}
