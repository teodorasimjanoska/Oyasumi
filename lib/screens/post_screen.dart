import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oyasumi/screens/post.dart';
import 'package:oyasumi/widgets/my_circular_progress.dart';
import 'home_page.dart';

class PostScreen extends StatelessWidget {
  final String userId;
  final String postId;

  PostScreen({
    required this.userId,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: postsRef.doc(userId).collection('userPosts').doc(postId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress(context);
          }
          Post post = Post.fromDocument(
              snapshot.data as DocumentSnapshot<Object?>);
          return Center(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(post.description,
                    overflow: TextOverflow.ellipsis,),
                ),
                body: ListView(
                  children: [
                    Container(
                      child: post,
                    ),
                  ],
                ),
              ),
          );
        });
  }
}
