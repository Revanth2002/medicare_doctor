import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'file:///D:/flutter_projects/medicare/lib/helper/scheduleevents.dart';
import 'package:medicare/services/firebase_services.dart';
import 'package:medicare/ui/schedule/addevent.dart';
import 'package:intl/intl.dart';


class ScheduleHomePageMQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth>1200){
          return ScheduleHomePageDesktop();
        }
        else if(constraints.maxWidth>800 && constraints.maxHeight<1200){
          return ScheduleHomePageTablet();
        }
        else{
          return ScheduleHomePageMobile();
        }
      },
    );
  }
}

class ScheduleHomePageDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ScheduleHomePageTablet extends StatefulWidget {
  @override
  _ScheduleHomePageTabletState createState() => _ScheduleHomePageTabletState();
}

class _ScheduleHomePageTabletState extends State<ScheduleHomePageTablet> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ScheduleHomePageMobile extends StatefulWidget {
  @override
  _ScheduleHomePageMobileState createState() => _ScheduleHomePageMobileState();
}

typedef DeleteCallback = Function(String id);
class _ScheduleHomePageMobileState extends State<ScheduleHomePageMobile> {
    TextStyle title = TextStyle(color: Colors.deepPurple,fontSize: 18,fontFamily: "CairoBold",fontWeight: FontWeight.bold);
    TextStyle desc = TextStyle(color: Colors.deepPurple[900],fontSize: 15,fontFamily: "CairoBold",fontWeight: FontWeight.bold);

    EventCrud eventCrud = new EventCrud();
 @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body:  SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(
                fit: StackFit.passthrough,
                children: [
                  Container(
                    width: size.width,
                    height: 180,
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset("assets/images/notepad.PNG",fit: BoxFit.fitWidth,height: 180,width:size.width,),
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

                ],
              ),
              Container(
                width: size.width,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 15, // soften the shadow
                      spreadRadius: 0, //extend the shadow
                      offset: Offset(
                        0, // Move to right 10  horizontally
                        0, // Move to bottom 10 Vertically
                      ),
                    )
                  ],
                ),
                child: ListTile(
                  title: Text("Events",style: TextStyle(fontSize: 25,fontFamily:"CairoBold",fontWeight: FontWeight.bold,color: Color.fromRGBO(17, 0, 102,0.8),),),
                  trailing:GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddEventPage()));
                      },
                      child: Icon(Icons.add,size: 32, color: Color.fromRGBO(17, 0, 102,0.8),)) ,

                ) ,
              ),
              _getTasks(),
              SizedBox(height: 5,)
            ],
          ),
        ),
      ),
    );
  }

  Widget _getTasks() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").doc(userUid.uid).collection("events").orderBy('event_date',descending: true).snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
          if(snapshot.hasData){
            return Container(
              width: size.width,
              height: 480,
              color: Colors.white,
              child: ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context,int index) {
                  DateTime myDateTime = (snapshot.data.docs[index]['event_date']).toDate();
                  var date = DateFormat.yMMMd().add_jm().format(myDateTime);
                  return  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onLongPress: ()async{
                        showDialog(
                            context: context,
                            builder: (content) =>AlertDialog(
                              content: Text("Do you want to delete this event",style: TextStyle(fontFamily: "Cairo",fontSize: 18),),
                              actions: [
                                FlatButton(
                                    child: Text("Cancel"),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    }
                                ),
                                FlatButton(
                                    child: Text("Delete",style: TextStyle(fontFamily: "CairoBold",color: Colors.red,fontWeight: FontWeight.bold),),
                                    onPressed: () async {
                                      eventCrud.deleteData(snapshot.data.docs[index].id);
                                      Navigator.pop(context);
                                    }
                                ),
                              ],
                            )
                        );
                      },
                      child: Container(
                          width: size.width,
                          height: 90,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            border:Border(
                              left: BorderSide(
                                  color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                  width: 3
                              ),
                            ),
                            //borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: -7,
                                  blurRadius: 10,
                                  offset: Offset(0,0)
                              )
                            ],
                          ),
                        child: Column(
                            children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              Expanded(flex: 1,
                                child: Text(snapshot.data.docs[index]['title'],style: title,overflow: TextOverflow.ellipsis,)),
                                Text(date.substring(0,12),style: desc,),

                            ],
                            ),
                            Container(
                            width: size.width,
                            height: 50,
                            child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(snapshot.data.docs[index]['description'],style: TextStyle(color:Colors.deepPurple[400],fontSize: 16),),
                            ),
                            ),
                            ],
                        ),
                  ),
                    ),
                  );
                },
              ),
            );
          }else{
            return Text("No events");
          }
        },
      ),
    );
  }


}

