import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:oyasumi/models/user.dart';
import 'package:oyasumi/screens/post.dart';
import 'package:oyasumi/screens/post_tile.dart';
import 'package:oyasumi/screens/upload_image_page.dart';
import 'package:oyasumi/widgets/my_circular_progress.dart';
import 'package:oyasumi/widgets/my_header.dart';

import 'home_page.dart';

class Profile extends StatefulWidget {
  final String profileId;

  Profile({required this.profileId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isFollowing = false;
  final String currentUserId = currentUser.id;
  bool isLoading = false;
  List<Post> posts = [];
  int followerCount = 0;
  int followingCount = 0;

  @override
  void initState() {
    super.initState();
    getProfilePosts();
    getFollowers();
    getFollowing();
    checkIfFollowing();
  }

  checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get();
    setState(() {
      isFollowing = doc.exists;
    });
  }

  getFollowers() async {
    QuerySnapshot snapshot = await followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .get();
    setState(() {
      followerCount = snapshot.docs.length;
    });
  }

  getFollowing() async {
    QuerySnapshot snapshot = await followingRef
        .doc(widget.profileId)
        .collection('userFollowing')
        .get();
    setState(() {
      followingCount = snapshot.docs.length;
    });
  }

  getProfilePosts() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snapshot = await postsRef
        .doc(widget.profileId)
        .collection("userPosts")
        .orderBy('timestamp', descending: true)
        .get();
    setState(() {
      isLoading = false;
      posts = snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    });
  }

  buildCountColumn(String label, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(
              fontSize: 22,
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 15,
            ),
          ),
        )
      ],
    );
  }

  buildButton({
    required String text,
    required VoidCallback function,
  }) {
    return Container(
      padding: EdgeInsets.only(top: 2),
      child: TextButton(
        onPressed: function,
        child: Container(
          width: 250,
          height: 27,
          child: Text(
            text,
            style: TextStyle(
              color: isFollowing ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFollowing
                ? Theme.of(context).primaryColor
                : Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    // return Text("Profile button");
    bool isProfileOwner = currentUserId == widget.profileId;
    if (isProfileOwner) {
      return Text("");
    } else if (isFollowing) {
      return buildButton(text: "Unfollow", function: handleUnfollowUser);
    } else if (!isFollowing) {
      return buildButton(text: "Follow", function: handleFollowUser);
    }
  }

  handleUnfollowUser() {
    setState(() {
      isFollowing = false;
    });

    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });
  }

  handleFollowUser() {
    setState(() {
      isFollowing = true;
    });

    followersRef
        .doc(widget.profileId)
        .collection('userFollowers')
        .doc(currentUserId)
        .set({});

    followingRef
        .doc(currentUserId)
        .collection('userFollowing')
        .doc(widget.profileId)
        .set({});
  }

  buildProfileHeader() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return circularProgress(context);
        }
        MyUser user =
            MyUser.fromDocument(snapshot.data as DocumentSnapshot<Object?>);
        return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          AssetImage("lib/images/default_profile_pic.png"),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildCountColumn("followers", followerCount),
                              buildCountColumn("following", followingCount),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              buildProfileButton(),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              user.username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(top: 4),
                            child: Text(
                              user.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(top: 2),
                            child: Text(
                              user.bio,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ));
      },
      future: usersRef.doc(widget.profileId).get(),
    );
  }

  buildProfilePosts() {
    if (isLoading) {
      return circularProgress(context);
    }
    List<GridTile> gridTiles = [];
    posts.forEach((post) {
      gridTiles.add(GridTile(child: PostTile(post)));
    });
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      mainAxisSpacing: 1.5,
      crossAxisSpacing: 1.5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: gridTiles,
    );
    // return Column(
    //   children: posts,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/images/background_image.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.transparent,
        appBar: MyHeader(),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(left: 21, right: 21, bottom: 15),
            decoration: BoxDecoration(
              color: Color(0xFFF4E7F0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListView(
              children: <Widget>[
                buildProfileHeader(),
                Divider(
                  height: 0,
                ),
                buildProfilePosts(),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 0,
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).accentColor,
                      elevation: 8,
                      onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UploadImage(currentUser: currentUser);
                            // return HomePage();
                          },
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Expanded(child: Column(children: [
            //       Text("Username"),
            //       SizedBox(
            //         height: 20,
            //       ),
            //       Row(
            //         children: [
            //           Icon(
            //             Icons.account_circle,
            //             size: 30,
            //           ),
            //           Column(
            //             children: [
            //               Text("Full name"),
            //               SizedBox(
            //                 height: 10,
            //               ),
            //               Text("Hii this is my about me"),
            //             ],
            //           ),
            //         ],
            //       ),
            //       SizedBox(
            //         height: 30,
            //       ),
            //     ],),),
            //
            //     Expanded(
            //       child: Row(
            //         children: [
            //           FloatingActionButton(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10),
            //             ),
            //             backgroundColor: Theme.of(context).primaryColor,
            //             foregroundColor: Theme.of(context).accentColor,
            //             elevation: 8,
            //             onPressed: () => Navigator.pushReplacement(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) {
            //                   return UploadImage(currentUser: currentUser);
            //                   // return HomePage();
            //                 },
            //               ),
            //             ),
            //             child: Icon(
            //               Icons.add,
            //               size: 40,
            //             ),
            //           ),
            //         ],
            //       ),
            //     )
            //   ],
            // ),
          ),
        ),
      ),
    );
  }
}
