import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medicare/services/firebase_services.dart';
import 'package:intl/intl.dart';
import 'package:medicare/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
class CompletedAppointments extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth>1280){
          return CompletedAppointmentsDesktop();
        }
        else if(constraints.maxWidth>840 && constraints.maxHeight<1280){
          return CompletedAppointmentsTablet();
        }
        else{
          return CompletedAppointmentsMobile();
        }
      },
    );
  }
}

class CompletedAppointmentsDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
class CompletedAppointmentsTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class CompletedAppointmentsMobile extends StatefulWidget {
  @override
  _CompletedAppointmentsMobileState createState() => _CompletedAppointmentsMobileState();
}

class _CompletedAppointmentsMobileState extends State<CompletedAppointmentsMobile> {
  bool appointmentStatus;

  @override
  void initState(){
    appointmentStatus = false;
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
                              Image.asset("assets/images/completed.jpg",fit: BoxFit.fitWidth,height: 220,width:size.width,),

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
                                  stream: FirebaseFirestore.instance.collection("users").doc(userUid.uid).collection("completed").orderBy('date',descending: true).snapshots(),
                                  builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
                                    if(snapshot.hasData){
                                      return Container(
                                        width: size.width,
                                        height: 510,
                                        color: Colors.white,
                                        child: ListView.builder(
                                          itemCount: snapshot.data.docs.length,
                                          itemBuilder: (BuildContext context,int index) {
                                            DateTime myDateTime = (snapshot.data.docs[index]['date']).toDate();
                                            var date = DateFormat.yMMMd().add_jm().format(myDateTime);
                                            return  Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: size.width-20,
                                                height: size.height/5,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(color: Color.fromRGBO(0, 215, 0, 0.9))
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
                                                                  Text(snapshot.data.docs[index]["name"],style: nameAppointments,overflow:TextOverflow.ellipsis,softWrap: true,),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text(snapshot.data.docs[index]["id"],style: subtitleAppointments,softWrap: true,),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Text("Date: ${date.substring(0,12)}",style: subtitleAppointments,softWrap: true,),
                                                                      Text("Time: ${date.substring(13)}",style: subtitleAppointments,softWrap: true,),
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
                                                    Divider(thickness: 1,endIndent: 15,indent: 15,),
                                                    Expanded(
                                                      child: Container(
                                                        color: Colors.white,
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            IconButton(
                                                              padding: EdgeInsets.only(bottom: 10),
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
                                                            Container(
                                                              width:120,
                                                              height: 28,
                                                              decoration: BoxDecoration(
                                                                  color: Colors.green,
                                                                  border: Border.all(color: Colors.green)
                                                              ),
                                                              child: Center(child: Text("Consulted",style: TextStyle(color: Colors.white,fontFamily: "CairoBold"),)),
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
                                    }else{
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
                    )
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