import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medicare/helper/auth_helper.dart';
import 'package:medicare/services/firebase_services.dart';
import 'package:medicare/ui/register/RegisteredMessage.dart';
import 'package:medicare/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicare/ui/login.dart';

class RegisterMQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1280) {
          return RegisterDesktop();
        } else if (constraints.maxWidth > 840 && constraints.maxHeight < 1280) {
          return RegisterTablet();
        } else {
          return RegisterMobile();
        }
      },
    );
  }
}

class RegisterDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class RegisterTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class RegisterMobile extends StatefulWidget {
  @override
  _RegisterMobileState createState() => _RegisterMobileState();
}

class _RegisterMobileState extends State<RegisterMobile> {
  TextStyle hintStyle = TextStyle(color: Color(0xf0899bf2),fontSize: 16);
  TextStyle style = TextStyle(color: Colors.deepPurple,fontSize: 16);

  TextEditingController name = new TextEditingController();
  TextEditingController contact = new TextEditingController();
  TextEditingController hospital = new TextEditingController();
  TextEditingController qualification = new TextEditingController();
  TextEditingController experience = new TextEditingController();
  TextEditingController specialist = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController confirmPassword = new TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool fileQualificationNull = true;
  File fileQualification;
  String fileNameQualification ='';
  bool fileMedicalNull = true;
  File fileMedical;
  String fileNameMedical ='';
  File _imageFile;
  String fileImage = '';
  bool _isRegistering = false;
 
  validate() async {
    try{
      if(formKey.currentState.validate()){
        print("validated");
        if(fileNameMedical != "" && fileNameQualification != "" && _imageFile != null){
          print("Ready to Register");
          setState(() {
            _isRegistering = true;
          });

          //REGISTER
            final user = await AuthHelper.signUpWithEmail(
                email: email.text,
                password: password.text);
            print("signup successful");
            final registerUid = user.uid;
            print(user.uid);

          //ADD TO USER(DOCTOR)
          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          int buildNumber = int.parse(packageInfo.buildNumber);
          Map<String, dynamic>userData = {
            'last_login':user.metadata.lastSignInTime.millisecondsSinceEpoch,
            'created_at' : user.metadata.creationTime.millisecondsSinceEpoch,
            'role':"doctor",
            'email': email.text,
            "status":"waiting",
            "build_number":buildNumber
          };
          await db.collection("users").doc(registerUid).set(userData);

          //ADD TO REQUESTS DOCTOR
          var data = {
            "name": name.text,
            "contact": contact.text,
            "experience": experience.text,
            "hospital": hospital.text,
            "mail": email.text,
            "qualification":qualification.text,
            "specialist":specialist.text,
          };
          await db.collection("requestdoctor").doc(registerUid).set(data);

          //UPLOAD FILES TO STORGAE
          StorageReference firebaseStorageRefImage = FirebaseStorage.instance.ref().child('docprofile/$registerUid/$registerUid');
          StorageUploadTask uploadProfile = firebaseStorageRefImage.putFile(_imageFile);
          StorageTaskSnapshot taskSnapshot = await uploadProfile.onComplete;
          taskSnapshot.ref.getDownloadURL().then(
                (img) async {
              print(img);
              await db.collection("requestdoctor").doc(registerUid).collection("files").doc().set({'img':img});
            },
          );
          //Qualification file
          StorageReference firebaseStorageRefQualify = FirebaseStorage.instance.ref().child('docprofile/$registerUid/$fileNameQualification');
          StorageUploadTask uploadQualification = firebaseStorageRefQualify.putFile(fileQualification);
          StorageTaskSnapshot qualificationSnapshot = await uploadQualification.onComplete;
          qualificationSnapshot.ref.getDownloadURL().then(
                (qualify) async {
              print(qualify);
              await db.collection("requestdoctor").doc(registerUid).collection("files").doc().set({'qualification_file':qualify});
            },
          );
          //Medical License
          StorageReference firebaseStorageRefLicense = FirebaseStorage.instance.ref().child('docprofile/$registerUid/$fileNameMedical');
          StorageUploadTask uploadLicense = firebaseStorageRefLicense.putFile(fileMedical);
          StorageTaskSnapshot licenseSnapshot = await uploadLicense.onComplete;
          licenseSnapshot.ref.getDownloadURL().then(
                (license) async {
              print(license);
              await db.collection("requestdoctor").doc(registerUid).collection("files").doc().set({'medical_license':license});
            },
          );

          //DISPLAY MESSAGE
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> RegisteredMessage()));
          setState(() {
            _isRegistering =false;
          });
        }
        else{
          if(fileNameMedical == ""){
            return showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('Missing'),
                    content: Text("Attach your Medical License",style: title,),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Back',style: dialog.copyWith(color: Colors.grey[700]),),
                      ),
                    ],
                  );
                }
            );
          }
          if(fileNameQualification == ""){
            return showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('Missing'),
                    content: Text("Attach your Qualification",style: title,),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Back',style: dialog.copyWith(color: Colors.grey[700]),),
                      ),
                    ],
                  );
                }
            );}
          if(_imageFile == null){
            print("Image is null");
            return showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text('Missing'),
                    content: Text("Upload your Picture",style: title,),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Back',style: dialog.copyWith(color: Colors.grey[700]),),
                      ),
                    ],
                  );
                }
            );
          }
        }
      }else{
        print("Not Validated");
      }
    }catch(e){
      print(e);
    }
  }


  void _toggle() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirm() {
    setState(() {
      _obscureConfirm = !_obscureConfirm;
    });
  }

  Future selectImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
      fileImage = path.basename(image.path);
    });
  }

  Future fileQualificationPicker(BuildContext context) async{
    try{
      fileQualification = await FilePicker.getFile(type: FileType.custom,allowedExtensions: ['pdf']);
      setState(() {
        fileNameQualification = path.basename(fileQualification.path);
        fileQualificationNull = false;
      });
      print(fileNameQualification);
    }on PlatformException catch(e){
      showDialog(
          context: context,
          builder: (BuildContext context){
            print(e);
            return AlertDialog(
              title: Text("Error"),
              content: Text("Please Select an pdf file"),
              actions: [
                FlatButton(
                  child: Text("Close"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
      );
    }

  }

  Future fileMedicalPicker(BuildContext context) async{
    try{
      fileMedical = await FilePicker.getFile(type: FileType.custom,allowedExtensions: ['pdf']);
      setState(() {
        fileNameMedical = path.basename(fileMedical.path);
        fileMedicalNull = false;
      });
      print(fileNameMedical);
    }on PlatformException catch(e){
      showDialog(
          context: context,
          builder: (BuildContext context){
            print(e);
            return AlertDialog(
              title: Text("Error"),
              content: Text("Please Select an pdf file"),
              actions: [
                FlatButton(
                  child: Text("Close"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 25),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Register", style: TextStyle(foreground: Paint()..shader = LinearGradient(
                          colors: <Color>[Color(0xff8921aa), Color(0xff8921aa)],
                    ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)), fontWeight: FontWeight.bold,fontFamily:"CairoBold", fontSize: 23),),
                          InkWell(
                              onTap: (){
                                Navigator.of(context).pushReplacement(CupertinoPageRoute(builder: (context)=>LoginPageMQ()));
                              },
                              child: Text("Login", style: TextStyle(color: Colors.grey[700],fontWeight: FontWeight.bold, fontSize: 20,fontFamily:"CairoBold"),)),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Container(
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(196, 135, 198, .3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ]
                        ),
                       child: Column(
                        children: <Widget>[
                          SizedBox(height: 5,),

                          _imageFile == null ? InkWell(
                           onTap: selectImage,
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Color(0xf0899bf2))
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset("assets/images/doctoricon.png",fit: BoxFit.cover,)),
                            ),
                          )
                              :InkWell(
                            onTap: selectImage,
                                child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white
                            ),
                            child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.file(_imageFile,fit: BoxFit.cover,)),
                          ),
                              ),
                          SizedBox(height: 10,),
                          Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(
                                  color: Colors.grey[200]
                              ))
                          ),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            maxLines: null,
                            controller: name,
                            textInputAction: TextInputAction.next,
                            style: style,
                            validator: (value){
                              if(value.isEmpty){
                                return "Enter your name";
                              }else{
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Name",
                                hintStyle: hintStyle,
                            ),
                          ),
                        ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    color: Colors.grey[200]
                                ))
                            ),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: contact,
                              style: style,
                              validator: (value){
                                if(value.isEmpty){
                                  return "Enter your mobile no";
                                }if(value.length==10){
                                  return null;
                                }else{
                                  return "Enter a valid mobile number";
                                }
                              },
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Mobile No",
                                hintStyle: hintStyle,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    color: Colors.grey[200]
                                ))
                            ),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              maxLines: null,
                              controller: hospital,
                              style: style,
                              validator: (value){
                                if(value.isEmpty){
                                  return "Enter your Hospital/Clinic name";
                                }else{
                                  return null;
                                }
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Hospital Name",
                                hintStyle: hintStyle,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    color: Colors.grey[200]
                                ))
                            ),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: qualification,
                              style: style,
                              validator: (value){
                                if(value.isEmpty){
                                  return "Enter your qualification";
                                }else{
                                  return null;
                                }
                              },
                              textInputAction: TextInputAction.next,
                              maxLines: null,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Qualification",
                                hintStyle: hintStyle,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(
                                    color: Colors.grey[200]
                                ))
                            ),
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: experience,
                              style: style,
                              validator: (value){
                                if(value.isEmpty){
                                  return "Enter your years of experience/Fresher";
                                }else{
                                  return null;
                                }
                              },
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Experience in years",
                                hintStyle: hintStyle,
                              ),
                            ),
                          ),
                          Container(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                            maxLines: null,
                            controller: specialist,
                            style: style,
                            validator: (value){
                              if(value.isEmpty){
                                return "Enter your specialisation";
                              }else{
                                return null;
                              }
                            },
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Specialist",
                                hintStyle: hintStyle
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                      SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(196, 135, 198, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ]
                        ),
                        child: Column(
                          children: <Widget>[
                            fileQualificationNull ? Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Qualification Certificate (*pdf)",style: hintStyle,),
                                        InkWell(
                                            onTap: (){
                                              fileQualificationPicker(context);
                                              setState(() {
                                                fileQualificationNull = true;
                                              });
                                            },
                                            child: Icon(Icons.attach_file_sharp,color: Colors.grey[700],)),
                                      ],
                                    ),
                                    Text("*Attach as a single pdf ,if you have more than one certificate",style: hintStyle.copyWith(fontSize: 12),),
                                  ],
                                )
                            )
                                : Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            flex:3,
                                            child: Text(fileNameQualification,style: hintStyle,overflow: TextOverflow.ellipsis,)),
                                        InkWell(
                                            onTap: (){
                                              fileQualificationPicker(context);
                                              setState(() {
                                                fileQualificationNull = true;
                                              });
                                            },
                                            child: Icon(Icons.attach_file_sharp,color: Colors.grey[700],)),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                            Divider(color: Colors.grey,),
                            fileMedicalNull ? Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Medical License (*pdf)",style: hintStyle,),
                                        InkWell(
                                            onTap: (){
                                              fileMedicalPicker(context);
                                              setState(() {
                                                fileMedicalNull = true;
                                              });
                                            },
                                            child: Icon(Icons.attach_file_sharp,color: Colors.grey[700],)),
                                      ],
                                    ),
                                  ],
                                )
                            )
                                : Container(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                            flex:3,
                                            child: Text(fileNameMedical,style: hintStyle,overflow: TextOverflow.ellipsis,)),
                                        InkWell(
                                            onTap: (){
                                              fileQualificationPicker(context);
                                              setState(() {
                                                fileMedicalNull = true;
                                              });
                                            },
                                            child: Icon(Icons.attach_file_sharp,color: Colors.grey[700],)),
                                      ],
                                    ),
                                  ],
                                )
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10,),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(196, 135, 198, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ]
                        ),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 5,),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]
                                  ))
                              ),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: email,
                                style: style,
                                validator: (value){
                                  Pattern pattern =
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                                  RegExp regex = new RegExp(pattern);
                                  if (!regex.hasMatch(value) || value == null)
                                    return 'Enter a valid email address';
                                  else
                                    return null;
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: hintStyle,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]
                                  ))
                              ),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: password,
                                style: style,
                                validator: (value){
                                  if(value.isEmpty){
                                    return "Enter an password";
                                  }if(value.length<=6){
                                    return "Your password must be greater than 6 characters";
                                  }else{
                                    return null;
                                  }
                                },
                                obscureText: _obscurePassword,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: hintStyle,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onPressed: _toggle,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(
                                      color: Colors.grey[200]
                                  ))
                              ),
                              child: TextFormField(
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                                controller: confirmPassword,
                                style: style,
                                obscureText: _obscureConfirm,
                                validator: (value){
                                  if(value.isEmpty){
                                    return "Confirm your password";
                                  }if(password.text != confirmPassword.text){
                                    return "Passwords don't match";
                                  }else{
                                    return null;
                                  }
                                },
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Confirm Password",
                                  hintStyle: hintStyle,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onPressed: _toggleConfirm,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      _isRegistering ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.deepPurple,
                          ),
                        )
                      )
                          :Container(
                        margin: EdgeInsets.symmetric(horizontal: 50),
                        child: FlatButton(
                          onPressed: (){
                            validate();
                          },
                          splashColor: Colors.deepPurple,
                          height: 45,
                          minWidth: 220,
                          color:Color(0xf0899bf2),
                          child: Text(
                            "Register",
                            style: TextStyle(fontSize: 20.0,color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                      ),
                      SizedBox(height: 30,)

                ],
              ),
        ),
        ]
    ),
            ),
          ),
    ),
      ),
    );
  }
}


