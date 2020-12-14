
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medicare/helper/auth_helper.dart';
import 'package:medicare/ui/register/register.dart';
import 'package:medicare/widgets.dart';

class LoginPageMQ extends StatefulWidget {
  @override
  _LoginPageMQState createState() => _LoginPageMQState();
}

class _LoginPageMQState extends State<LoginPageMQ> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      if(constraints.maxWidth > 1200){
        return LoginPageDesktop();
      }
      else if(constraints.maxWidth>800 && constraints.maxWidth <1200){
        return LoginPageTablet();
      }
      else{
        return LoginPageMobile();
      }
    });
  }
}


class LoginPageMobile extends StatefulWidget {
  @override
  State createState() => LoginPageMobileState();
}

class LoginPageMobileState extends State<LoginPageMobile> {
  TextEditingController _emailController, _pwController;
  FocusNode _emailFocus, _pwFocus;
  TextEditingController resetPassword = new TextEditingController();
  TextStyle style = TextStyle(color: Colors.deepPurple,fontSize: 16);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // Initially password is obscure
  bool _obscureText = true;
  String _password;
  String _email;

  bool isValidEmail() {
    if ((_email == null) || (_email.length == 0)) {
      return true;
    }
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
  }

  bool isValidPassword() {
    if ((_password == null) || (_password.length == 0)) {
      return true;
    }
    return (_password.length > 2);
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _validate() {
    setState(() {
      _email = _emailController.text;
      _password = _pwController.text;
    });
  }

  Future<void> performLogin() async {
    if (_emailController.text.isEmpty ||
        _pwController.text.isEmpty) {
      print("Email and password cannot be empty");
      return;
    }

    try {
     final user = await AuthHelper.signInWithEmail(
          email: _emailController.text,
          password: _pwController.text);
     if ( user != null) {
       print("Login successfull");
     }


    } on Exception catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: Colors.black.withOpacity(1),
              child: AlertDialog(
                title: Text("Login Error"),
                content: Text("The Username/Password is incorrect. Please try again."),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
            );
          });
    }

  }

  @override
  void initState() {
    _emailController = TextEditingController();
    _pwController = TextEditingController();
    _emailFocus = FocusNode();
    _pwFocus = FocusNode();
    super.initState();
  }

  resetLink(){
   return showDialog(
     context: context,
     builder: (BuildContext context){
       return AlertDialog(
         title: Text("Reset Password",style: title.copyWith(fontSize: 20,color: Colors.deepPurple),),
         content: Container(
           height: 250,
           child: Column(
             children: [
               Text("Enter your email address and a reset link will be sent to your mail",style: title.copyWith(color: Colors.deepPurpleAccent),),
               TextField(
                 controller: resetPassword,
                 style: style,
                 keyboardType: TextInputType.text,
                 decoration: InputDecoration(hintText: "Email"),
               ),
             ],
           ),
         ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel',style: dialog.copyWith(color: Colors.grey[700]),),
            ),
            FlatButton(
              onPressed: () {
                print(resetPassword);
                resetConfirm(context);
              },
              child: Text('Reset',style: dialog.copyWith(color: Colors.deepPurple),),
            ),
          ],
       );
     }
   );
  }

  Future<void> resetConfirm(BuildContext context) async{
  try{
    if(resetPassword.text.length == 0 || !resetPassword.text.contains("@")){
      Fluttertoast.showToast(msg: "Enter a valid email");
      return ;
    }
    await FirebaseAuth.instance.sendPasswordResetEmail(email: resetPassword.text);
    Fluttertoast.showToast(msg: "Reset Password link has been sent your email",backgroundColor: Colors.black,
      textColor: Colors.white,);
    Navigator.pop(context);
  }catch(e){
    print(e);
    Fluttertoast.showToast(
      msg: "User does not exists!Check your email",backgroundColor: Colors.black,
      textColor: Colors.white,
    );
    Navigator.pop(context);
  }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 0, top: 30),
                child: Image.asset(
                  "assets/images/logo2.jpeg",
                  width: 90,
                  height: 90,
                ),
              ),
              Container(
                  padding: EdgeInsets.only(
                    left: 0,
                  ),
                  child: Image.asset(
                    "assets/images/doctor.png",
                    width: 270,
                    height: 270,
                  )),
              SizedBox(
                height: 10,
              ),
              Text("Doctor Hub",style: TextStyle(fontSize:23,fontFamily: "CairoBold",foreground: Paint()..shader = LinearGradient(
                colors: <Color>[Color(0xff8921aa), Color(0xff8921aa)],
              ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  child: TextField(
                    focusNode: _emailFocus,
                    controller: _emailController,
                    obscureText: false,
                    keyboardType:
                        TextInputType.emailAddress, //show email keyboard
                    textInputAction: TextInputAction.next,
                    onSubmitted: (input) {
                      _emailFocus.unfocus();
                      _email = input;
                      FocusScope.of(context).requestFocus(_pwFocus);
                    },
                    onTap: _validate,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: new BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            new BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: new BorderRadius.circular(25.7),
                      ),
                      hintText: 'Email',
                      focusColor: Colors.deepPurpleAccent,
                      hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                      prefixIcon: Icon(
                        Icons.mail,
                        color: Colors.deepPurpleAccent,
                      ),
                      errorText:
                          isValidEmail() ? null : "Invalid Email Address",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  child: TextField(
                    focusNode: _pwFocus,
                    controller: _pwController,
                    obscureText: _obscureText,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (input) {
                      _pwFocus.unfocus();
                      _password = input;
                      performLogin();
                    },
                    onTap: _validate,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            new BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: new BorderRadius.circular(25.7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            new BorderSide(color: Colors.deepPurpleAccent),
                        borderRadius: new BorderRadius.circular(25.7),
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.deepPurpleAccent,
                      ),
                      errorText:
                          isValidPassword() ? null : "Password too short.",
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.deepPurpleAccent,
                        ),
                        onPressed: _toggle,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                  onTap: (){
                    resetLink();
                  },
                  child: Padding(
                  padding: EdgeInsets.fromLTRB(220, 0, 10, 0),
                  child: Text("Forgot Password?",style: TextStyle(color: Colors.grey[700],fontSize: 15,fontFamily: "CairoBold"),),
              )),
              GestureDetector(
                onTap: () {
                  performLogin();
                },
                child: Container(
                  margin: EdgeInsets.only(left:0,top: 10),
                  child: FlatButton(
                    height: 45,
                    minWidth: 220,
                    color: const Color(0xf0899bf2),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20.0,color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    onPressed: performLogin,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left:0,top: 10),
                child: FlatButton(
                  splashColor: Colors.deepPurple,
                  height: 45,
                  minWidth: 220,
                  color: Colors.white,
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 20.0,color:  Color(0xf0899bf2)),
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color:Color(0xf0899bf2),width: 2),
                      borderRadius: BorderRadius.circular(25)),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>RegisterMQ()));
                  },
                ),
              ),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPageTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Tablet constraint"),
    );
  }
}

class LoginPageDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Desktop Constraint"),
    );
  }
}
