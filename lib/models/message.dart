import "package:cloud_firestore/cloud_firestore.dart";

class Message {
  String? senderId;
  String? receiverId;
  String? type;
  String? message;
  Timestamp timestamp = Timestamp.now();
  String? photoUrl = "";

  Message(
      {required this.senderId,
      required this.receiverId,
      required this.type,
      required this.message,
      required this.timestamp});

  Message.imageMessage(
      {required this.senderId,
      required this.receiverId,
      required this.message,
      required this.type,
      required this.timestamp,
      required this.photoUrl});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {};
    map["senderId"] = this.senderId;
    map["receiverId"] = this.receiverId;
    map["type"] = this.type;
    map["message"] = this.message;
    map["timestamp"] = this.timestamp;
    return map;
  }

  Message.fromMap(Map<String, dynamic> map) {
    this.message = map["message"];
    this.senderId = map["senderId"];
    this.receiverId = map["receiverId"];
    this.type = map["type"];
    this.timestamp = map["timestamp"];
  }

  Map<String, dynamic> toImageMap() {
    Map<String, dynamic> map = {};
    map["senderId"] = this.senderId;
    map["receiverId"] = this.receiverId;
    map["type"] = this.type;
    map["message"] = this.message;
    map["timestamp"] = this.timestamp;
    map["photoUrl"] = this.photoUrl;
    return map;
  }
}
