import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/models/message.dart';
import 'package:skype_clone/models/person.dart';
import 'package:skype_clone/resources/firebase_methods.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/utils/utilities.dart';
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
  final FirebaseMethods _firebaseMethods = FirebaseMethods();
  Person _senderUser = Person();
  String _currentUserId = "";
  bool iswriting = false;

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

  sendMessage() {
    Message _message = Message(
        senderId: _senderUser.uid,
        receiverId: widget.receiver.uid!,
        type: "text",
        message: textfeildController.text,
        timestamp: Timestamp.now());
    setState(() {
      iswriting = false;
    });
    textfeildController.text = "";
    _firebaseMethods.addMessageToDb(_message);
  }

  pickImage({required ImageSource source}) async {
    File selectedImage = await Utils.pickImage(source: source);
    _firebaseMethods.uploadImage(
        selectedImage, widget.receiver.uid!, _currentUserId);
  }

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
            .collection(messageCollection)
            .doc(_currentUserId)
            .collection(widget.receiver.uid.toString())
            .orderBy(timestampField, descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return chatMessageItem(snapshot.data!.docs[index]);
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget chatMessageItem(DocumentSnapshot snapshot) {
    Message _msg = Message.fromMap(snapshot.data() as Map<String, dynamic>);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: Container(child: messageLayout(_msg)),
    );
  }

  Widget messageLayout(Message msg) {
    Radius messageRadius = const Radius.circular(10);
    return Align(
      alignment: msg.senderId == _currentUserId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.65,
        ),
        decoration: BoxDecoration(
          color: UniversalVariables.senderColor,
          borderRadius: msg.senderId == _currentUserId
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
            padding: const EdgeInsets.all(10),
            child: Text(
              msg.message!,
              style: const TextStyle(color: Colors.white, fontSize: 16),
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
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      TextButton(
                          onPressed: () => Navigator.maybePop(context),
                          child: const Icon(Icons.close)),
                      const Expanded(
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
                  children: const [
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
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _addMediaModel(context),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                gradient: UniversalVariables.fabGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(
            width: 5,  
          ),
          Expanded(
            child: TextField(
                controller: textfeildController,
                onChanged: (val) => val.isNotEmpty && val.trim() != ""
                    ? setWritingTo(true)
                    : setWritingTo(false),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: const TextStyle(
                      color: UniversalVariables.greyColor,
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        borderSide: BorderSide.none),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    fillColor: UniversalVariables.separatorColor,
                    suffixIcon: GestureDetector(
                      onTap: () {},
                      child: const Icon(Icons.face),
                    ))),
          ),
          iswriting
              ? Container()
              : const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.record_voice_over),
                ),
          iswriting
              ? Container()
              : GestureDetector(
                  child: const Icon(Icons.camera_alt),
                  onTap: () => pickImage(source: ImageSource.camera),
                ),
          iswriting
              ? Container(
                  margin: const EdgeInsets.only(left: 10),
                  decoration: const BoxDecoration(
                      gradient: UniversalVariables.fabGradient,
                      shape: BoxShape.circle),
                  child: IconButton(
                    icon: const Icon(
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

  CustomAppBar customAppBar(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)),
      centertitle: true,
      title: Text(widget.receiver.name ?? ""),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        title: Text(
          title,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
        ),
        mini: false,
        leading: Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: UniversalVariables.greyColor),
        ),
      ),
    );
  }
}
