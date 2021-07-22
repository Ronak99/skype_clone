import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skype_clone/models/message.dart';

import '../models/person.dart';
import '../utils/utilities.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
        .collection("users")
        .where("email", isEqualTo: userCredential.user?.email)
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

    firestore.collection("users").doc(userCred.user?.uid).set(
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

    QuerySnapshot querysnapshot = await firestore.collection("users").get();

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
        .collection("messages")
        .doc(message.senderId)
        .collection(message.receiverId.toString())
        .add(msg);

    await firestore
        .collection("messages")
        .doc(message.receiverId)
        .collection(message.senderId.toString())
        .add(msg);
  }
}
