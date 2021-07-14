import 'package:flutter/material.dart';

import '../../widgets/custom_tile.dart';
import '../../utils/utilities.dart';
import '../../widgets/appbar.dart';
import '../../resources/firebase_repository.dart';
import '../../utils/universal_variables.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

final FirebaseRepository _repository = FirebaseRepository();

class _ChatListScreenState extends State<ChatListScreen> {
  String? currentUserId;
  String initials = "";

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((value) {
      setState(() {
        currentUserId = value.uid;
        initials = Utils.getInitials(value.displayName);
      });
    });
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
        title: UserCircle(text: initials),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/search_screen");
            },
            icon: Icon(Icons.search),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
            color: Colors.white,
          ),
        ],
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.notifications),),
        centertitle: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      floatingActionButton: NewChatButton(),
      body: ChatListContainer(
        currentUserId: "uid",
      ),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  final String currentUserId;
  const ChatListContainer({Key? key, required this.currentUserId})
      : super(key: key);

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 2,
        itemBuilder: (context, index) {
          return CustomTile(
            mini: false,
            onTap: () {},
            leading: Container(
              constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
              child: Stack(
                children: [
                  CircleAvatar(
                    maxRadius: 30,
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(
                        "https://avatars.githubusercontent.com/u/39453065?v=4"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: UniversalVariables.onlinDotColor,
                          border: Border.all(
                              color: UniversalVariables.blackColor, width: 2),),
                    ),
                  )
                ],
              ),
            ),
            subtitle: Text(
              "hello",
              style: TextStyle(color: UniversalVariables.greyColor),
            ),
            title: Text(
              "Rohit Jain",
              style: TextStyle(
                  color: Colors.white, fontFamily: "Arial", fontSize: 19),
            ),
          );
        },
      ),
    );
  }
}

class UserCircle extends StatelessWidget {
  final String text;
  const UserCircle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: UniversalVariables.separatorColor),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: UniversalVariables.lightBlueColor,
                    fontSize: 13),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: UniversalVariables.blackColor, width: 2),
                    color: UniversalVariables.onlinDotColor),
              ),
            )
          ],
        ),);
  }
}

class NewChatButton extends StatelessWidget {
  const NewChatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: UniversalVariables.fabGradient,
          borderRadius: BorderRadius.circular(50),),
      child: Icon(
        Icons.edit,
        color: Colors.white,
        size: 25,
      ),
      padding: EdgeInsets.all(15),
    );
  }
}
