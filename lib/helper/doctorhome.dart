

import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorCarousel{

  Future carouselFirebase() async{
    var db = FirebaseFirestore.instance;
    QuerySnapshot carouselSnapshot = await db.collection("CarouselDoctor").get();
    return carouselSnapshot.docs;
  }

}