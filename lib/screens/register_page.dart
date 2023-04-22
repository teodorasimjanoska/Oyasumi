import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oyasumi/models/user.dart';
import 'package:oyasumi/widgets/my_button.dart';
import 'package:oyasumi/widgets/my_textfield.dart';

final auth = FirebaseAuth.instance;
final usersRef = FirebaseFirestore.instance.collection('users');
// late MyUser currentUser;

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future signUserUp() async {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   },
    // );

    if (passwordConfirmed()) {
      // create user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      createUserInFirestore();

      // add user details
      // addUserDetails(
      //   _nameController.text.trim(),
      //   // _lastNameController.text.trim(),
      //   int.parse(_ageController.text.trim()),
      //   _usernameController.text.trim(),
      //   _emailController.text.trim(),
      // );

    } else {
      showErrorMessage("Passwords do not match");
    }

    Navigator.pop(context);

  }

  // Future addUserDetails(
  //     String name, int age, String username, String email) async {
  //   final user = FirebaseAuth.instance.currentUser!;
  //   await usersRef.doc(user.uid).set({
  //     'name': name,
  //     'age': age,
  //     'username' : username,
  //     'email': email,
  //     'photoUrl': "",
  //     'bio': "",
  //   });
  //
  // }

  createUserInFirestore() async {
    final user = auth.currentUser;
    final DocumentSnapshot doc = await usersRef.doc(user!.uid).get();

    usersRef.doc(user.uid).set({
      "id": user.uid,
      "username": _usernameController.text.trim(),
      "email": _emailController.text.trim(),
      "name": _nameController.text.trim(),
      "age": int.parse(_ageController.text.trim()),
      "bio": "Hello!",
    });

    // currentUser = MyUser.fromDocument(doc);
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() ==
        _confirmPasswordController.text.trim()) {
      return true;
    }
    return false;
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
        );
      },
    );
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
        appBar: AppBar(
          elevation: 2,
          toolbarHeight: 50,
          backgroundColor: const Color(0xFFBBACC5),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back, color: Color(0xFF55474F)),
          //   onPressed: () => Navigator.of(context).pop(),
          // ),
          // leading: IconButton(
          //   onPressed: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => LoginOrSignup()));
          //   },
          //   icon: Icon(Icons.arrow_back_rounded),
          // ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Create an account",
                  style: TextStyle(
                    fontSize: 35,
                    color: Color(0xFF66545E),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                MyTextField(
                  controller: _nameController,
                  hintText: "Enter your full name",
                  obscureText: false,
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _ageController,
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF66545E)),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Enter your age",
                      hintStyle: TextStyle(
                        color: Color(0xFF66545E),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                MyTextField(
                  controller: _usernameController,
                  hintText: "Enter your username",
                  obscureText: false,
                ),
                SizedBox(
                  height: 8,
                ),
                MyTextField(
                  controller: _emailController,
                  hintText: "Enter your email",
                  obscureText: false,
                ),
                SizedBox(
                  height: 8,
                ),
                MyTextField(
                  controller: _passwordController,
                  hintText: "Enter password",
                  obscureText: true,
                ),
                SizedBox(
                  height: 8,
                ),
                MyTextField(
                  controller: _confirmPasswordController,
                  hintText: "Confirm password",
                  obscureText: true,
                ),
                SizedBox(
                  height: 20,
                ),
                MyButton(onTap: signUserUp, text: "SIGN UP"),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "already have an account?",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Log in",
                    style: TextStyle(
                      color: Color(0xFF66545E),
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
