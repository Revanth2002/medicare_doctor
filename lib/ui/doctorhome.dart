import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:medicare/helper/doctorhome.dart';
import 'package:medicare/ui/aboutyou.dart';
import 'package:medicare/ui/appointments.dart';
import 'package:medicare/ui/patients.dart';
import 'package:medicare/ui/schedule.dart';

class DoctorHomePageMQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth>1280){
          return DoctorHomePageDesktop();
        }
        else if(constraints.maxWidth>840 && constraints.maxHeight<1280){
          return DoctorHomePageTablet();
        }
        else{
          return DoctorHomePageMobile();
        }
      },
    );
  }
}



class DoctorHomePageMobile extends StatefulWidget {
  @override
  _DoctorHomePageMobileState createState() => _DoctorHomePageMobileState();
}
class _DoctorHomePageMobileState extends State<DoctorHomePageMobile> {
  DoctorCarousel doctorCarousel = new DoctorCarousel();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;

    TextStyle title =  TextStyle(fontSize: 22,fontFamily:"Ubuntu",fontWeight: FontWeight.w500,color: Colors.deepPurple);
    TextStyle desc =  TextStyle(fontSize: 13,fontFamily:"Ubuntu",fontWeight: FontWeight.w500,color: Colors.grey);

    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: doctorCarousel.carouselFirebase() ,
                builder: (BuildContext context,snapshot){
                  if(snapshot.hasData){
                    return Container(
                      width: size.width,
                      height: size.height/3,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Color(0xFFC7B8F5),
                              Colors.pinkAccent
                            ]
                        ),
                      ),
                      child:  Swiper(
                        pagination: SwiperPagination(),
                          autoplay: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (BuildContext context,int index)  {
                            DocumentSnapshot sliderImage = snapshot.data[index];
                            return Image.network(sliderImage["url"],fit: BoxFit.fill,);
                          }
                      ),
                    );
                  }else{
                    return Center(
                      child: CircularProgressIndicator.adaptive(backgroundColor: Colors.deepPurple,),
                    );
                  }
                },
              ),
              SizedBox(height: 0,),
             Padding(
               padding: EdgeInsets.only(top: 0),
               child: Container(
                width: width,
                height: 500,
                 decoration: BoxDecoration(
                     color: Color.fromRGBO(245, 245, 245, 0.1),
                     borderRadius: BorderRadius.all(Radius.circular(15),
                     ),
                  ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(left: 20,top: 25),
                       child: Text("Daily Check",style: TextStyle(fontSize: 20,fontWeight:FontWeight.w700,color: Colors.black.withOpacity(0.7),),),
                     ),
                     GestureDetector(
                       onTap:(){
                         Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>PatientHomePageMobile()));
                       } ,
                       child: Padding(
                         padding: const EdgeInsets.only(left: 15,right:15,top: 16),
                         child: Container(
                           width: size.width-30,
                           height: 95,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8),
                          ),
                          ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                              Expanded(
                                child: Image.asset("assets/images/hospitalisation.png",width: 60,height: 60,),
                              ),
                               Expanded(
                                 flex: 2,
                                 child: Padding(
                                   padding: const EdgeInsets.only(top: 20,left: 10),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text("Patients",style: title),
                                       Padding(
                                         padding: const EdgeInsets.only(top: 7),
                                         child: Text("Review your patients",style: desc,),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: IconButton(
                                   icon: Icon(Icons.navigate_next,color: Colors.deepPurple),
                                   iconSize: 40,
                                   onPressed: (){
                                     Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>PatientHomePageMobile()));
                                   },
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     ),
                     GestureDetector(
                       onTap:(){
                         Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AppointmentHomePageMobile()));
                       } ,
                       child: Padding(
                         padding: const EdgeInsets.only(left: 15,right:15,top: 7),
                         child: Container(
                           width: size.width-30,
                           height: 95,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.all(Radius.circular(8),
                             ),
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Expanded(child: Image.asset("assets/images/task.png",width: 50,height: 50,)),
                               Expanded(
                                 flex: 2,
                                 child: Padding(
                                   padding: const EdgeInsets.only(top: 20,left: 10),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text("Appointments",style: title),
                                       Padding(
                                         padding: const EdgeInsets.only(top: 7),
                                         child: Text("Check your appointments",style: desc,),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: IconButton(
                                   icon: Icon(Icons.navigate_next,color: Colors.deepPurple),
                                   iconSize: 40,
                                   onPressed: (){
                                     Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AppointmentHomePageMobile()));
                                   },
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     ),
                     GestureDetector(
                       onTap:(){
                         Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ScheduleHomePageMobile()));
                       } ,
                       child: Padding(
                         padding: const EdgeInsets.only(left: 15,right:15,top: 7),
                         child: Container(
                           width: size.width-30,
                           height: 95,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.all(Radius.circular(8),
                             ),
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Expanded(child: Image.asset("assets/images/completed-task.png",width: 45,height: 45,)),
                               Expanded(
                                 flex: 2,
                                 child: Padding(
                                   padding: const EdgeInsets.only(left: 20,top: 23),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text("Schedule",style: title),
                                       Padding(
                                         padding: const EdgeInsets.only(top: 7),
                                         child: Text("Schedule a perfect day ",style: desc,),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: IconButton(
                                   icon: Icon(Icons.navigate_next,color: Colors.deepPurple),
                                   iconSize: 40,
                                   onPressed: (){
                                     Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>ScheduleHomePageMobile()));
                                   },
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     ),
                     GestureDetector(
                       onTap:(){
                         Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AboutYouHomePageMobile()));
                       } ,
                       child: Padding(
                         padding: const EdgeInsets.only(left: 15,right:15,top: 7),
                         child: Container(
                           width: size.width-30,
                           height: 95,
                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.all(Radius.circular(8),
                             ),
                           ),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               Expanded(child: Image.asset("assets/images/doctorvector.png",width: 45,height: 45,)),
                               Expanded(
                                 flex: 2,
                                 child: Padding(
                                   padding: const EdgeInsets.only(left: 20,top: 23),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Text("About you",style: title),
                                       Padding(
                                         padding: const EdgeInsets.only(top: 7),
                                         child: Text("Set your Details ",style: desc,),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: IconButton(
                                   icon: Icon(Icons.navigate_next,color: Colors.deepPurple),
                                   iconSize: 40,
                                   onPressed: (){
                                     Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>AboutYouHomePageMobile()));
                                   },
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     ),
                   ],
                 ),
             ),
             ),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorHomePageTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
class DoctorHomePageDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}





