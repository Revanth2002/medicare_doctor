import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//For getting User UID
final FirebaseAuth auth = FirebaseAuth.instance;
final User userUid = auth.currentUser;
final String uid = userUid.uid.toString();

final db = FirebaseFirestore.instance;