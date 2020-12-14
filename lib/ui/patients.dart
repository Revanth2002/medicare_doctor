import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicare/ui/patientrecords/pastpatient.dart';
import 'package:medicare/ui/patientrecords/recentPatient.dart';



class PatientsHomeMQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth>1280){
          return PatientHomePageDesktop();
        }
        else if(constraints.maxWidth>840 && constraints.maxHeight<1280){
          return PatientHomePageTablet();
        }
        else{
          return PatientHomePageMobile();
        }
      },
    );
  }
}

class PatientHomePageDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PatientHomePageTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PatientHomePageMobile extends StatefulWidget {
  @override
  _PatientHomePageMobileState createState() => _PatientHomePageMobileState();
}

class _PatientHomePageMobileState extends State<PatientHomePageMobile> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    RecentPatientMobile(),
    PastPatientMobile()
  ];

  GlobalKey _bottomNavigationKey = GlobalKey();

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        color: Colors.deepPurple,
        backgroundColor: Colors.white,
        buttonBackgroundColor: Colors.deepPurple,
        index: _currentIndex,
        height: 50,
        items: <Widget>[
          Icon(Icons.assignment,size: 20,color: Colors.white,),
          Icon(Icons.history,size: 20,color: Colors.white,),
        ],
        animationCurve: Curves.bounceInOut,
        animationDuration: Duration(milliseconds: 200),
        onTap: onTabTapped,
      ),
      body: _children[_currentIndex],
    );
  }
}
