import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicare/models/patientRecords.dart';
import 'package:medicare/ui/patientrecords/indetailpatient.dart';


const kBackgroundColor = Color(0xFFF8F8F8);
const kActiveIconColor = Color(0xFFE68342);
const kTextColor = Color(0xFF222B45);
const kBlueLightColor = Color(0xFFC7B8F5);
const kBlueColor = Color(0xFF817DC0);
const kShadowColor = Color(0xFFE6E6E6);
var kTitleTextColor = Color(0xff1E1C61);

//Curve widget
class HomeCurve extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Colors.deepPurple;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
        size.width, size.height / 2, size.width, size.height * 0.5);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class MyClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path = Path();
    path.lineTo(0, size.height-80);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height-80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return false;
  }
}

class Carroussel extends StatefulWidget {
  @override
  _CarrousselState createState() => new _CarrousselState();
}
class _CarrousselState extends State<Carroussel> {
  PageController controller;
  int currentpage = 0;

  @override
  initState() {
    super.initState();
    controller = new PageController(
      initialPage: currentpage,
      keepPage: false,
      viewportFraction: 0.5,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Container(
          child: new PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentpage = value;
                });
              },
              controller: controller,
              itemBuilder: (context, index) => builder(index)),
        ),
      ),
    );
  }

  builder(int index) {
    return new AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double value = 1.0;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return new Center(
          child: new SizedBox(
            height: Curves.easeOut.transform(value) * 300,
            width: Curves.easeOut.transform(value) * 250,
            child: child,
          ),
        );
      },
      child: new Container(
        margin: const EdgeInsets.all(8.0),
        color: index % 2 == 0 ? Colors.blue : Colors.red,
      ),
    );
  }
}

Widget buildPatientCard(BuildContext context, DocumentSnapshot document) {

  TextStyle title = TextStyle(color: Colors.black,fontFamily: "CairoBold",fontSize: 18);
  TextStyle subtitle = TextStyle(color: Colors.grey,fontFamily: "CairoBold",fontSize: 16);
  final patient = PatientRecords.fromSnapshot(document);

  return new Container(
    child: Card(
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(CupertinoPageRoute(builder: (context)=>DetailPatientMobile(patientDetails: patient)));
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Row(
                  children: [
                    Image.network(patient.img,fit: BoxFit.fill,width: 50,height: 50,),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              patient.name,
                              maxLines: 2,
                              maxFontSize: 17,
                              style: title,overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              patient.id,
                              style: subtitle,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.navigate_next,color: Colors.deepPurple,size: 35,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

TextStyle title = TextStyle(fontSize: 18,fontFamily: "CairoBold",fontWeight: FontWeight.w500);
TextStyle desc =  TextStyle(fontSize: 16,fontFamily: "CairoBold",fontWeight: FontWeight.w500,color: Colors.black.withOpacity(0.5));
TextStyle dialog = TextStyle(fontFamily: "CairoBold");
TextStyle titleAboutYou = TextStyle(fontSize: 20,fontFamily: "CairoBold",color: Colors.grey[700]);
TextStyle nameAppointments = TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontFamily: "CairoBold",fontSize: 17);
TextStyle statusAppointments = TextStyle(color: Colors.pinkAccent,fontWeight: FontWeight.bold,fontFamily: "CairoBold",fontSize: 18,);
TextStyle subtitleAppointments = TextStyle(color: Colors.grey[700],fontWeight: FontWeight.w700,fontFamily: "CairoBold");
TextStyle titleMissedAppoint = TextStyle(color: Colors.deepPurple,fontSize: 18,fontFamily: "CairoBold",fontWeight: FontWeight.bold);
TextStyle descMissedAppoint = TextStyle(color: Colors.deepPurple[900],fontSize: 15,fontFamily: "CairoBold",fontWeight: FontWeight.bold);
