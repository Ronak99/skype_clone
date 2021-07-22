import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/person.dart';
import 'package:skype_clone/resources/firebase_methods.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/appbar.dart';
import 'package:skype_clone/widgets/custom_tile.dart';

class ChatScreen extends StatefulWidget {
  final Person receiver;
  const ChatScreen({Key? key, required this.receiver}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textfeildController = TextEditingController();

  FirebaseMethods _firebaseMethods = FirebaseMethods();

  Person _senderUser = Person();

  String _currentUserId = "";

  @override
  void initState() {
    _firebaseMethods.getCurrentUser().then((user) {
      setState(() {
        _currentUserId = user.uid;
        _senderUser = Person(
            uid: user.uid, name: user.displayName, profilePhoto: user.photoURL);
      });
    });
    super.initState();
  }

  bool iswriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(
        children: [Flexible(child: messageList()), chatControls()],
      ),
    );
  }

  Widget messageList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("messages")
            .doc(_currentUserId)
            .collection(widget.receiver.uid.toString())
            .orderBy("timestamp", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return chatMessageItem(snapshot.data!.docs[index]);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Container(child: messageLayout(snapshot)),
    );
  }

  Widget messageLayout(DocumentSnapshot snapshot) {
    Radius messageRadius = Radius.circular(10);
    return Align(
      alignment: snapshot["senderId"] == _currentUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(top: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        decoration: BoxDecoration(
          color: UniversalVariables.senderColor,
          borderRadius: snapshot["senderId"] == _currentUserId
              ? BorderRadius.only(
                  topLeft: messageRadius,
                  topRight: messageRadius,
                  bottomLeft: messageRadius)
              : BorderRadius.only(
                  bottomRight: messageRadius,
                  topRight: messageRadius,
                  bottomLeft: messageRadius),
        ),
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              snapshot["message"],
              style: TextStyle(color: Colors.white, fontSize: 16),
            )),
      ),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        iswriting = val;
      });
    }

    _addMediaModel(BuildContext context) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () => Navigator.maybePop(context),
                          child: Icon(Icons.close)),
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Context and tools",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ))
                    ],
                  ),
                ),
                Flexible(
                    child: ListView(
                  children: [
                    ModalTile(
                        title: "Media",
                        subtitle: "Share Photos and Video",
                        icon: Icons.image),
                    ModalTile(
                        title: "File",
                        subtitle: "Share files",
                        icon: Icons.tab),
                    ModalTile(
                        title: "Contact",
                        subtitle: "Share Contacts",
                        icon: Icons.contacts),
                    ModalTile(
                        title: "Location",
                        subtitle: "Share a Location",
                        icon: Icons.add_location),
                    ModalTile(
                        title: "Schedule Call",
                        subtitle: "Arrange a skype call and get reminders",
                        icon: Icons.schedule),
                    ModalTile(
                        title: "Create Poll",
                        subtitle: "Share Polls",
                        icon: Icons.poll),
                  ],
                ))
              ],
            );
          });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _addMediaModel(context),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextField(
                controller: textfeildController,
                onChanged: (val) => val.length > 0 && val.trim() != ""
                    ? setWritingTo(true)
                    : setWritingTo(false),
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: UniversalVariables.greyColor,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide.none),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: UniversalVariables.separatorColor,
                    suffixIcon: GestureDetector(
                      onTap: () {},
                      child: Icon(Icons.face),
                    ))),
          ),
          iswriting
              ? Container()
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          iswriting ? Container() : Icon(Icons.camera_alt),
          iswriting
              ? Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 15,
                    ),
                    onPressed: () {
                      sendMessage();
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  sendMessage() {
    Message _message = Message(
        senderId: _senderUser.uid,
        receiverId: widget.receiver.uid!,
        type: "text",
        message: textfeildController.text,
        timestamp: FieldValue.serverTimestamp());

    setState(() {
      iswriting = false;
    });

    _firebaseMethods.addMessageToDb(_message);
  }

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)),
      centertitle: true,
      title: Text(widget.receiver.name ?? ""),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.video_call)),
        IconButton(onPressed: () {}, icon: Icon(Icons.phone)),
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const ModalTile(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        title: Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        mini: false,
        leading: Container(
          margin: EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: UniversalVariables.greyColor),
        ),
      ),
    );
  }
}
