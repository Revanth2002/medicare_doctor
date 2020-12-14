import 'package:medicare/services/firebase_services.dart';



class AppointmentCrud{

  deleteRecent(docId) {
    db.collection("users").doc(userUid.uid).collection("pending").doc(docId).delete().catchError((e) {
      print(e);
    });
  }

  addCompleted(data) async {
    db.collection("users").doc(userUid.uid).collection("completed").doc().set(data).catchError((e){
      print(e);
    });
  }

  addMissed(data){
    db.collection("users").doc(userUid.uid).collection("missed").doc().set(data).catchError((e){
      print(e);
    });
  }
}