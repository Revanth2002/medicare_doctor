import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicare/helper/auth_helper.dart';
import 'package:medicare/services/firebase_services.dart';
import 'package:medicare/widgets.dart';



class AboutYouHomePageMQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth>1200){
          return AboutYouHomePageDesktop();
        }
        else if(constraints.maxWidth>800 && constraints.maxHeight<1200){
          return AboutYouHomePageTablet();
        }
        else{
          return AboutYouHomePageMobile();
        }
      },
    );
  }
}

class AboutYouHomePageDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AboutYouHomePageTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class AboutYouHomePageMobile extends StatefulWidget {
  @override
  _AboutYouHomePageMobileState createState() => _AboutYouHomePageMobileState();
}

class _AboutYouHomePageMobileState extends State<AboutYouHomePageMobile> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _hospitalController = TextEditingController();
  TextEditingController _qualificationController = TextEditingController();
  TextEditingController _yearController = TextEditingController();
  TextEditingController _specialistController = TextEditingController();

  File _imageFile;
  final picker = ImagePicker();


  update(BuildContext context,docId,String word,String text,TextEditingController textEditingController,int length,TextInputType keyboardType){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Doctor $text'),
            content: Container(
              height: 80,
              child: Column(
                children: [
                  TextField(
                    maxLength: length,
                    keyboardType: keyboardType,
                    controller: textEditingController,
                    decoration: InputDecoration(hintText: text),
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
                onPressed: () async {
                    if(textEditingController.text.length!=0){
                      await FirebaseFirestore.instance.collection("users").doc(userUid.uid).collection("profile").doc(docId).update(
                          {word:textEditingController.text});
                      Navigator.pop(context);
                    }else{
                      Navigator.pop(context);
                    }
                },
                child: Text('Submit',style: dialog.copyWith(color: Colors.deepPurple),),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.navigate_before,color: Colors.black,size: 40,),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            color: Colors.grey,
            iconSize: 28,
              onPressed:() async {
                showDialog(
                    context: context,
                    builder: (content) =>AlertDialog(
                      content: Text("Are you sure, you want to Logout",style: TextStyle(fontFamily: "Cairo",fontSize: 18),),
                      actions: [
                        FlatButton(
                            child: Text("Cancel"),
                            onPressed: () async {
                              Navigator.pop(context);
                            }
                        ),
                        FlatButton(
                            child: Text("LogOut",style: TextStyle(fontFamily: "CairoBold",color: Colors.deepPurple[600],fontWeight: FontWeight.bold),),
                            onPressed: () async {
                              AuthHelper.logOut();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                        ),
                      ],
                    )
                );
              }
          )
        ],
        title: Text("Profile",style: TextStyle(fontFamily:'Ubuntu',color: Colors.black,fontSize: 23),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
              width: size.width,
              height: size.height,
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                        Expanded(
                          flex:1,
                          child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: StreamBuilder(
                                  stream: db.collection("users").doc(userUid.uid).collection("profile").where("img",isNotEqualTo: "").snapshots(),
                                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                                 if(!snapshot.hasData) return CircularProgressIndicator(backgroundColor: Colors.deepPurple,);
                                 return ListView.builder(
                                   itemCount: snapshot.data.docs.length,
                                   itemBuilder: (BuildContext context,int index){
                                     return Column(
                                       children: [
                                         Container(
                                           height: 100,
                                           width: 100,
                                           decoration: BoxDecoration(
                                               shape: BoxShape.circle,
                                               color: Colors.white
                                           ),
                                           child: ClipRRect(
                                               borderRadius: BorderRadius.circular(50),
                                               child: Image.network(snapshot.data.docs[index]["img"],fit: BoxFit.cover,)),
                                         ),
                                         InkWell(
                                             splashColor: Colors.deepPurple,
                                             borderRadius: BorderRadius.circular(40),
                                             onTap: () async {
                                               try{
                                                 final pickedFile = await picker.getImage(source: ImageSource.gallery);
                                                 setState(() {
                                                   _imageFile = File(pickedFile.path);
                                                 });
                                                 final user = userUid.uid;
                                                 StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('docprofile/$user/$user');
                                                 StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
                                                 StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
                                                 print(taskSnapshot);
                                                 taskSnapshot.ref.getDownloadURL().then(
                                                       (value) async {
                                                     print(value);
                                                     await db.collection("users").doc(userUid.uid).collection("profile").doc(snapshot.data.docs[index].id).update(
                                                         {"img": value}
                                                     );
                                                   },
                                                 );
                                               }catch(e){
                                                 print(e);
                                               }
                                             },
                                             child: Icon(Icons.edit,color: Colors.grey,))
                                       ],
                                     );
                                   },
                                 );
                                }
                              ),
                            ),
                        ),
                  Expanded(
                    flex:4,
                    child: StreamBuilder(
                        stream: db.collection("users").doc(userUid.uid).collection("profile").where("docIdNo",isNotEqualTo: "").snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                          if(snapshot.hasData){
                            return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (BuildContext context,int index){
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    ListTile(
                                      trailing: InkWell(
                                          splashColor: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(40),
                                          onTap:(){
                                            update(context,snapshot.data.docs[index].id,"name","Name",_nameController,100,TextInputType.text);
                                          },
                                          child: Icon(Icons.edit,color: Colors.grey,)),
                                      title:Text(
                                          snapshot.data.docs[index]["name"],softWrap: true,
                                          style: titleAboutYou
                                      ),
                                    ),
                                    ListTile(
                                      title:Text(
                                         "ID#${snapshot.data.docs[index]["docIdNo"]}",softWrap: true,
                                          style: titleAboutYou
                                      ),
                                    ),
                                    Divider(color: Colors.grey,thickness: 0.6,),
                                    ListTile(
                                      trailing: InkWell(
                                          splashColor: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(40),
                                          onTap: (){
                                            return showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Edit Doctor Contact no'),
                                                    content: Container(
                                                      height: 80,
                                                      child: Column(
                                                        children: [
                                                          TextField(
                                                            maxLength: 10,
                                                            keyboardType: TextInputType.number,
                                                            controller: _mobileController,
                                                            decoration: InputDecoration(hintText: "Contact No"),
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
                                                        onPressed: () async {
                                                          if(_mobileController.text.length == 10){
                                                            var docId = snapshot.data.docs[index].id;
                                                            await FirebaseFirestore.instance.collection("users").doc(userUid.uid).collection("profile").doc(docId).update(
                                                                {"contact":_mobileController.text}
                                                            );
                                                            Navigator.pop(context);
                                                          }else{
                                                            print("10number");
                                                          }
                                                        },
                                                        child: Text('Submit',style: dialog.copyWith(color: Colors.deepPurple),),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Icon(Icons.edit,color: Colors.grey,)),
                                      title:Text(
                                        snapshot.data.docs[index]['contact'].toString(),softWrap: true,
                                        style: titleAboutYou,
                                      ),
                                    ),
                                    Divider(color: Colors.grey,thickness: 0.6,),
                                    ListTile(
                                      title:Text(
                                        snapshot.data.docs[index]["mail"],softWrap: true,
                                        style: titleAboutYou,
                                      ),
                                    ),
                                    Divider(color: Colors.grey,thickness: 0.6,),
                                    ListTile(
                                      trailing: InkWell(
                                          splashColor: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(40),
                                          onTap: (){
                                            update(context,snapshot.data.docs[index].id,"hospital","Hospital name",_hospitalController,200,TextInputType.text);
                                          },
                                          child: Icon(Icons.edit,color: Colors.grey,)),
                                      title:Text(
                                        snapshot.data.docs[index]["hospital"],softWrap: true,overflow: TextOverflow.ellipsis,
                                        style: titleAboutYou,
                                      ),
                                    ),
                                    Divider(color: Colors.grey,thickness: 0.6,),
                                    ListTile(
                                      trailing: InkWell(
                                          splashColor: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(40),
                                          onTap: (){
                                            update(context,snapshot.data.docs[index].id,"qualification","Qualification",_qualificationController,100,TextInputType.text);

                                          },
                                          child: Icon(Icons.edit,color: Colors.grey,)),
                                      title:Text(
                                        snapshot.data.docs[index]["qualification"],softWrap: true,overflow: TextOverflow.ellipsis,
                                        style: titleAboutYou,
                                      ),
                                    ),
                                    Divider(color: Colors.grey,thickness: 0.6,),
                                    ListTile(
                                      trailing: InkWell(
                                          splashColor: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(40),
                                          onTap: (){
                                            update(context,snapshot.data.docs[index].id,"experience","Experience years",_yearController,2,TextInputType.number);
                                          },
                                          child: Icon(Icons.edit,color: Colors.grey,)),
                                      title:Text(
                                        snapshot.data.docs[index]["experience"].toString(),softWrap: true,overflow: TextOverflow.ellipsis,
                                        style: titleAboutYou,
                                      ),
                                    ),
                                    Divider(color: Colors.grey,thickness: 0.6,),
                                    ListTile(
                                      trailing: InkWell(
                                          splashColor: Colors.deepPurple,
                                          borderRadius: BorderRadius.circular(40),
                                          onTap: (){
                                            update(context,snapshot.data.docs[index].id,"specialist","Specialisation",_specialistController,50,TextInputType.text);
                                          },
                                          child: Icon(Icons.edit,color: Colors.grey,)),
                                      title:Text(
                                        snapshot.data.docs[index]["specialist"],softWrap: true,overflow: TextOverflow.ellipsis,
                                        style: titleAboutYou,
                                      ),
                                    ),
                                    Divider(color: Colors.grey,thickness: 0.6,),
                                    SizedBox(height: 120,)
                                  ],
                                );
                              },
                            );
                          }else{
                            return Center(
                              child: CircularProgressIndicator.adaptive(backgroundColor: Colors.deepPurple,),
                            );
                          }
                        }
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}






