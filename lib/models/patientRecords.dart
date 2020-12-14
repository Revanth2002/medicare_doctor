import 'package:cloud_firestore/cloud_firestore.dart';

class PatientRecords{
  String img;
  String name;
  String contact;
  Timestamp date;
  String doctor;
  String gender;
  String id;
  String mail;
  String problem;
  String treatment;
  String age;
  String address;
  String docRef;

  PatientRecords(this.name,this.id,this.img,this.mail,this.contact,this.date,this.docRef,this.treatment,this.problem,this.address,this.gender,this.age,this.doctor);

  Map<String,dynamic> toJson() =>{
    'name' : name,
    "id":id,
    'img':img,
    'date':date,
    'contact':contact,
    'mail': mail,
    'doctor':doctor,
    'gender':gender,
    'problem':problem,
    'treatment':treatment,
    'age':age,
    'address':address,
    'docRef':docRef,

  };

  PatientRecords.fromSnapshot(DocumentSnapshot snapshot):
  name = snapshot['name'],
  img = snapshot['img'],
  id = snapshot['id'],
  date = snapshot['date'],
  contact = snapshot['contact'],
  docRef = snapshot.id,
  mail = snapshot['mail'],
  doctor =snapshot['doctor'],
  gender =snapshot['gender'],
  problem = snapshot['problem'],
  treatment = snapshot['treatment'],
  age = snapshot['age'],
  address = snapshot['address'];

}