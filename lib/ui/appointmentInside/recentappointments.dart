import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'file:///D:/flutter_projects/medicare/lib/helper/appointments.dart';
import 'package:medicare/services/firebase_services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';



class RecentMQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth>1280){
          return RecentDesktop();
        }
        else if(constraints.maxWidth>840 && constraints.maxHeight<1280){
          return RecentTablet();
        }
        else{
          return RecentMobile();
        }
      },
    );
  }
}

class RecentDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
class RecentTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class RecentMobile extends StatefulWidget {
  @override
  _RecentMobileState createState() => _RecentMobileState();
}

class _RecentMobileState extends State<RecentMobile> {
  TextStyle name = TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontFamily: "CairoBold",fontSize: 21);
  TextStyle status = TextStyle(color: Colors.pinkAccent,fontWeight: FontWeight.bold,fontFamily: "CairoBold",fontSize: 18,);
  TextStyle subtitle = TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontFamily: "Cairo");

  AppointmentCrud _appointmentCrud = new AppointmentCrud();
  final patient  = db.collection("patientrecord").where("doctor" ,isEqualTo: userUid.uid).where("status",isEqualTo: "pending").snapshots();

  @override
  void initState(){

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Stack(
                  children: [
                    Container(
                      width: size.width,
                      height: 270,
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset("assets/images/appointments-1.jpg",fit: BoxFit.fitWidth,height: 220,width:size.width,),

                            ],
                          ),
                          Positioned(
                            top: 10,
                            child: IconButton(
                              icon: Icon(Icons.navigate_before,color: Colors.black,),
                              iconSize: 40,
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: size.height/5,
                      child: Container(
                          width: size.width,
                          height: size.height,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 20.0, // soften the shadow
                                spreadRadius: 20.0, //extend the shadow
                                offset: Offset(
                                  15.0, // Move to right 10  horizontally
                                  15.0, // Move to bottom 10 Vertically
                                ),
                              )
                            ],
                          ),
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                child: StreamBuilder(
                                  stream: patient,
                                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                                    if(snapshot.hasData){
                                      return Container(
                                        width: size.width,
                                        height: 510,
                                        color: Colors.white,
                                        child: ListView.builder(
                                          itemCount: snapshot.data.docs.length,
                                          itemBuilder: (BuildContext context,int index) {
                                            final data={
                                              "name": snapshot.data.docs[index]["name"],
                                              "id":snapshot.data.docs[index]["id"],
                                              "status":"completed",
                                              "img": snapshot.data.docs[index]["img"],
                                              "date":snapshot.data.docs[index]["date"],
                                              "contact":snapshot.data.docs[index]["contact"]
                                            };
                                            final missed={
                                              "name": snapshot.data.docs[index]["name"],
                                              "id":snapshot.data.docs[index]["id"],
                                              "status":"missed",
                                              "img": snapshot.data.docs[index]["img"],
                                              "date":snapshot.data.docs[index]["date"],
                                              "contact":snapshot.data.docs[index]["contact"]
                                            };
                                            DateTime myDateTime = (snapshot.data.docs[index]['date']).toDate();
                                            var date = DateFormat.yMMMd().add_Hms().format(myDateTime);
                                            return  Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: size.width-20,
                                                height: size.height/5,
                                                decoration: BoxDecoration(
                                                  color: Color.fromRGBO(102, 102, 255, 0.9),
                                                ),
                                                child: Column(
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 15),
                                                              child: Image.network(snapshot.data.docs[index]['img'],fit: BoxFit.contain,height:60,),
                                                            ),
                                                            flex: 1,
                                                          ),
                                                          Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 20,right: 20),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(snapshot.data.docs[index]["name"],style: name,overflow:TextOverflow.ellipsis,softWrap: true,),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(snapshot.data.docs[index]["id"],style: subtitle,softWrap: true,),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text("Date: ${date.substring(0,12)}",style: subtitle,softWrap: true,),
                                                                      Text("Time: ${date.substring(13)}",style: subtitle,softWrap: true,),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            flex: 4,
                                                          ),
                                                        ],
                                                      ),
                                                      flex: 3,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            IconButton(
                                                                color: Colors.blue,
                                                                icon: Icon(Icons.phone),
                                                                iconSize: 24,
                                                              onPressed:()async{
                                                                var url = "tel:+91${snapshot.data.docs[index]["contact"]}";
                                                                if (await canLaunch(url)) {
                                                                  await launch(url);
                                                                } else {
                                                                  throw 'Could not launch $url';
                                                                }
                                                              },
                                                            ),
                                                            InkWell(
                                                              onTap:() async {
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (content) =>AlertDialog(
                                                                      content: Text("Oops! Your patient has missed your appointment",style: TextStyle(fontFamily: "Cairo",fontSize: 18),),
                                                                      actions: [
                                                                        FlatButton(
                                                                            child: Text("Cancel"),
                                                                            onPressed: () async {
                                                                              Navigator.pop(context);
                                                                            }
                                                                        ),
                                                                        FlatButton(
                                                                            child: Text("Missed",style: TextStyle(fontFamily: "CairoBold",color: Colors.red,fontWeight: FontWeight.bold),),
                                                                            onPressed: () async {
                                                                              await _appointmentCrud.addMissed(missed);
                                                                              await db.collection("patientrecord").doc(snapshot.data.docs[index].id).update({"status":"waiting"});
                                                                              Navigator.pop(context);
                                                                            }
                                                                        ),
                                                                      ],
                                                                    )
                                                                );
                                                              },
                                                              child: Container(
                                                                width:120,
                                                                height: 28,
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(color: Colors.red,width: 1.2)
                                                                ),
                                                                child: Center(child: Text("Missed",style: TextStyle(color: Colors.red,fontFamily: "CairoBold"),)),
                                                              ),
                                                            ),
                                                            InkWell(
                                                              onTap:() async {
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (content) =>AlertDialog(
                                                                      content: Text("Good job Doctor! Cheers..",style: TextStyle(fontFamily: "Cairo",fontSize: 18),),
                                                                      actions: [
                                                                        FlatButton(
                                                                            child: Text("Cancel"),
                                                                            onPressed: () async {
                                                                              Navigator.pop(context);
                                                                            }
                                                                        ),
                                                                        FlatButton(
                                                                            child: Text("Consulted",style: TextStyle(fontFamily: "CairoBold",color: Colors.green,fontWeight: FontWeight.bold),),
                                                                            onPressed: () async {
                                                                              await _appointmentCrud.addCompleted(data);
                                                                              await db.collection("patientrecord").doc(snapshot.data.docs[index].id).update({"status":"waiting"});
                                                                              Navigator.pop(context);
                                                                            }
                                                                        ),
                                                                      ],
                                                                    )
                                                                );
                                                              },
                                                              child: Container(
                                                                width:120,
                                                                height: 28,
                                                                decoration: BoxDecoration(
                                                                    color: Colors.green,
                                                                    border: Border.all(color: Colors.green)
                                                                ),
                                                                child: Center(child: Text("Consulted",style: TextStyle(color: Colors.white,fontFamily: "CairoBold"),)),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      flex: 1,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                    else{
                                      return Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.deepPurple,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              )
                            ],
                          )
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




