import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medicare/services/firebase_services.dart';



class EventCrud{

  deleteData(docId) {
    FirebaseFirestore.instance.collection("users").doc(userUid.uid).collection("events").doc(docId).delete().catchError((e) {
      print(e);
    });
  }
}