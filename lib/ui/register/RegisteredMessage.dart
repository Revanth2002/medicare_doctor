import 'package:flutter/material.dart';
import 'package:medicare/ui/login.dart';
import 'package:medicare/widgets.dart';

class RegisteredMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1280) {
          return MessageDesktop();
        } else if (constraints.maxWidth > 840 && constraints.maxHeight < 1280) {
          return MessageTablet();
        } else {
          return MessageMobile();
        }
      },
    );
  }
}

class MessageDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MessageTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



class MessageMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.withOpacity(0.2),
      body: SafeArea(
        child: Center(
          child: AlertDialog(
          title: Text('Thank You!!',style: title.copyWith(color: Colors.deepPurple),),
            content: Text("Thanks for registering.Your Account will be active once our team verifies your portfolio and gives approval.We will get back to you within next 48hours",style: title.copyWith(color: Colors.deepPurple[200]),),
            actions: [
            FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginPageMQ()));
            },
            child: Text('Close',style: dialog.copyWith(color: Colors.grey[700]),),
          ),
        ],
      ),
        )
      ),
    );
  }
}



