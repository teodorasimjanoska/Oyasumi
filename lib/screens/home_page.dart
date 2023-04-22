import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oyasumi/models/user.dart';
import 'package:oyasumi/screens/for_you_page.dart';
import 'package:oyasumi/screens/profile_screen.dart';
import 'package:oyasumi/widgets/my_header.dart';

final auth = FirebaseAuth.instance;
final usersRef = FirebaseFirestore.instance.collection('users');
MyUser currentUser = MyUser.fromDocument(usersRef.doc(auth.currentUser!.uid).get() as DocumentSnapshot);
final Reference storageRef = FirebaseStorage.instance.ref();
final postsRef = FirebaseFirestore.instance.collection('posts');
final followersRef = FirebaseFirestore.instance.collection('followers');
final followingRef = FirebaseFirestore.instance.collection('following');

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  getCurrentUser() async {
    final user = auth.currentUser;
    final DocumentSnapshot doc = await usersRef.doc(user!.uid).get();

    setState(() {
      currentUser = MyUser.fromDocument(doc);
    });

  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
        backgroundColor: Colors.transparent,
        appBar: MyHeader(),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(left: 21, right: 21, bottom: 15),
            decoration: BoxDecoration(
              color: Color(0xFFF4E7F0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            right: 5,
                            top: 5,
                          ),
                          child: Text(
                            "Hi, ${currentUser.username}!",
                            style: GoogleFonts.mulish(
                                fontSize: 28, color: Color(0xFF55474F)),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                            top: 5,
                          ),
                          child: Text(
                            "How can I help you today?",
                            style: GoogleFonts.mulish(
                                fontSize: 16, color: Color(0xFF55474F)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(3, 3),
                            ),
                          ],
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Outfit maker",
                              style: GoogleFonts.mulish(
                                color: Color(0xFF55474F),
                                fontSize: 22,
                              ),
                            ),
                            SizedBox(
                              width: 120,
                            ),
                            Icon(Icons.keyboard_arrow_right_outlined),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ForYouPage();
                            // return HomePage();
                          },
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(3, 3),
                            ),
                          ],
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Find inspiration",
                              style: GoogleFonts.mulish(
                                color: Color(0xFF55474F),
                                fontSize: 22,
                              ),
                            ),
                            SizedBox(
                              width: 91,
                            ),
                            Icon(Icons.keyboard_arrow_right_outlined),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Profile(profileId: currentUser.id);
                            // return HomePage();
                          },
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(3, 3),
                            ),
                          ],
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Share inspiration",
                              style: GoogleFonts.mulish(
                                color: Color(0xFF55474F),
                                fontSize: 22,
                              ),
                            ),
                            SizedBox(
                              width: 75,
                            ),
                            Icon(Icons.keyboard_arrow_right_outlined),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Image.asset('lib/images/homepage_image.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
