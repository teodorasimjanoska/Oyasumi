import 'package:flutter/material.dart';
import 'package:oyasumi/screens/post.dart';
import 'package:oyasumi/screens/post_screen.dart';
import 'package:oyasumi/widgets/custom_image.dart';

class PostTile extends StatelessWidget {
  final Post post;

  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    showPost(context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PostScreen(userId: post.ownerId, postId: post.postId),
        ),
      );
    }

    return GestureDetector(
      onTap: () => showPost(context),
      child: cachedNetworkImage(post.mediaUrl),
    );
  }
}
