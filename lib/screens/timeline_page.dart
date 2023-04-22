import 'package:flutter/material.dart';
import 'package:oyasumi/widgets/my_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  const Timeline({Key? key}) : super(key: key);

  @override
  State<Timeline> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<dynamic> users = [];

  @override
  void initState() {
    // getUsers();
    super.initState();
  }

  getUsers() async {
    final QuerySnapshot snapshot = await usersRef.get();

    setState(() {
      users = snapshot.docs;
    });
    // snapshot.docs.forEach((DocumentSnapshot doc) {
    //   print(doc.data());
    // });
  }

  getUserById() async {
    final String id = "not a real id";
    final DocumentSnapshot doc = await usersRef.doc(id).get();
  }

  deleteUser() async {
    final String id = "not a real id";
    final DocumentSnapshot doc = await usersRef.doc(id).get();
    if (doc.exists) {
      doc.reference.delete();
    }
  }

  // sample list of recommended items
  final List<String> _recommendedItems = [
    "Artificial Intelligence",
    "Data Science",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeader(),
      body: StreamBuilder<QuerySnapshot>(
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final List<Text> children = snapshot.data!.docs.map((doc) => Text(doc['age'].toString())).toList();
          return Container(
            child: ListView(
              children: children,
            ),
          );
        },
      ),
    );
  }
}

class ItemDetailPage extends StatelessWidget {
  final String itemName;

  ItemDetailPage({required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(itemName),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "This is the detail page for $itemName.",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
