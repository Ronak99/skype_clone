import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/models/message.dart';

import '../models/person.dart';
import '../utils/utilities.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage _storageReference = FirebaseStorage.instance;
  Person user = Person();

  Future<User> getCurrentUser() async {
    return _auth.currentUser!;
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await _auth.signInWithCredential(credential);
  }

  Future<bool> authenticateUser(UserCredential userCredential) async {
    QuerySnapshot result = await firestore
        .collection(USERS_COLLECTION)
        .where(EMAIL_FIELD, isEqualTo: userCredential.user?.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;
    // If user is registred then legth of list > 0 or else less than 0
    return docs.length == 0 ? true : false;
  }

  Future<void> addDataToDb(UserCredential userCred) async {
    String username = Utils.getUsername(userCred.user?.email);
    print(userCred.user);
    Person user = Person(
        uid: userCred.user?.uid,
        name: userCred.user?.displayName,
        email: userCred.user?.email,
        username: username,
        profilePhoto: userCred.user?.photoURL);

    firestore.collection(USERS_COLLECTION).doc(userCred.user?.uid).set(
          user.toMap(user),
        );
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
    return await _auth.signOut();
  }

  Future<List<Person>> fetchAllUsers(User currentUser) async {
    List<Person> userList = [];

    QuerySnapshot querysnapshot =
        await firestore.collection(USERS_COLLECTION).get();

    for (var i = 0; i < querysnapshot.docs.length; i++) {
      if (querysnapshot.docs[i].id != currentUser.uid) {
        userList.add(
          Person.fromMap(querysnapshot.docs[i].data() as Map<String, dynamic>),
        );
      }
    }

    return userList;
  }

  Future<void> addMessageToDb(Message message) async {
    var msg = message.toMap();

    await firestore
        .collection(MESSAGE_COLLECTION)
        .doc(message.senderId)
        .collection(message.receiverId.toString())
        .add(msg);

    await firestore
        .collection(MESSAGE_COLLECTION)
        .doc(message.receiverId)
        .collection(message.senderId.toString())
        .add(msg);
  }

  Future<String> uploadImageToStorage(File image) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    String url = "";
    Reference ref = storage.ref().child("image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(image);
    uploadTask.whenComplete(() {
      ref.getDownloadURL().then((value) {
        url = value;
      });
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }

  void uploadImage(File image, String receiverId, String senderId) async {
    String url = await uploadImageToStorage(image);

    Message message = Message.imageMessage(
        senderId: senderId,
        receiverId: receiverId,
        message: "IMAGE",
        type: "IMAGE",
        timestamp: Timestamp.now(),
        photoUrl: url);

    var msg = message.toImageMap();

    addMessageToDb(message);
  }
}
