import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicare/ui/appointmentInside/missedAppointments.dart';
import 'package:medicare/ui/appointmentInside/recentappointments.dart';

import 'appointmentInside/completedappointments.dart';


class AppointmentHomeMQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth>1280){
          return AppointmentHomePageDesktop();
        }
        else if(constraints.maxWidth>840 && constraints.maxHeight<1280){
          return AppointmentHomePageTablet();
        }
        else{
          return AppointmentHomePageMobile();
        }
      },
    );
  }
}

class AppointmentHomePageDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AppointmentHomePageTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AppointmentHomePageMobile extends StatefulWidget {
  @override
  _AppointmentHomePageMobileState createState() => _AppointmentHomePageMobileState();
}

class _AppointmentHomePageMobileState extends State<AppointmentHomePageMobile> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    RecentMobile(),
    CompletedAppointmentsMobile(),
    MissedAppointmentMobile()
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
          Icon(Icons.check,size: 20,color: Colors.white,),
          Icon(Icons.clear,size: 20,color: Colors.white,),
        ],
        animationCurve: Curves.bounceInOut,
        animationDuration: Duration(milliseconds: 200),
        onTap: onTabTapped,
      ),
      body: _children[_currentIndex],
    );
  }
}


