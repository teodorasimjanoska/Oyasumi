import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oyasumi/screens/search_users_page.dart';
import 'package:oyasumi/screens/timeline_page.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({super.key});

  @override
  State<ForYouPage> createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage> {

  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.jumpToPage(pageIndex);
  }

  Scaffold buildForYouPage() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
          Search(),
          // Profile(),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.brightness_3_outlined),),
          BottomNavigationBarItem(icon: Icon(Icons.search),),
          // BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined),),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildForYouPage();
  }
}