import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'pageviews/chat_list_screen.dart';
import '../utils/universal_variables.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController();

  int _page = 0;

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  Widget text(String tx) {
    return Text(
      tx,
      style: TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    // double lableFontSize = 10;
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(
            child: ChatListScreen(),
          ),
          Center(
            child: text("Call Logs"),
          ),
          Center(
            child: text("Contact Screen"),
          ),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat,
                  color: _page == 0
                      ? UniversalVariables.lightBlueColor
                      : UniversalVariables.greyColor,
                ),
                label: "Chats",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.call,
                  color: _page == 1
                      ? UniversalVariables.lightBlueColor
                      : UniversalVariables.greyColor,
                ),
                label: "Call",
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.contact_phone,
                  color: _page == 2
                      ? UniversalVariables.lightBlueColor
                      : UniversalVariables.greyColor,
                ),
                label: "Contacts",
              ),
            ],
            backgroundColor: UniversalVariables.blackColor,
            onTap: navigationTapped,
            currentIndex: _page,
          ),
        ),
      ),
    );
  }
}
