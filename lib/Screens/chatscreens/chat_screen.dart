import 'package:flutter/material.dart';
import 'package:skype_clone/models/person.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/appbar.dart';

class ChatScreen extends StatefulWidget {
  final Person receiver;
  const ChatScreen({Key? key, required this.receiver}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController textfeildController = TextEditingController();

  bool iswriting = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: customAppBar(context),
      body: Column(),
    );
  }

  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        iswriting = val;
      });
    }

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              gradient: UniversalVariables.fabGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add),
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
          iswriting ? Container() 
        ],
      ),
    );
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
