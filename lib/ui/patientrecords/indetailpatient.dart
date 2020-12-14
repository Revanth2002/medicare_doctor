import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:medicare/widgets.dart';
import 'package:path/path.dart' as path;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicare/models/patientRecords.dart';
import 'package:intl/intl.dart';
import 'package:medicare/services/firebase_services.dart';
import 'package:url_launcher/url_launcher.dart';


class DetailPatientMQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth>1280){
          return DetailPatientDesktop();
        }
        else if(constraints.maxWidth>840 && constraints.maxHeight<1280){
          return DetailPatientTablet();
        }
        else{
          return DetailPatientMobile();
        }
      },
    );
  }
}

class DetailPatientDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DetailPatientTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DetailPatientMobile extends StatefulWidget {
  final PatientRecords patientDetails;
  DetailPatientMobile({ this.patientDetails});

  @override
  _DetailPatientMobileState createState() => _DetailPatientMobileState();
}

class _DetailPatientMobileState extends State<DetailPatientMobile> {

  TextEditingController problem = new TextEditingController();
  TextEditingController treatment = new TextEditingController();

  String fileType = '';
  File file;
  String fileName ='';
  String operationText = '';
  bool isUploaded = true;
  String result = '';

  update(){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Edit Records'),
            content: Container(
              height: 180,
              child: Column(
                children: [
                  ListTile(
                    title: Text("Aliments",style: title,),
                    onTap: (){
                      updateData(widget.patientDetails.docRef,"Aliments",problem,"problem");
                    },
                  ),
                  ListTile(
                    onTap: (){
                      updateData(widget.patientDetails.docRef,"Medications",treatment,"treatment");
                    },
                    title: Text("Medications",style: title,),
                  ),
                  ListTile(
                    onTap: () async {
                      uploadFiles(widget.patientDetails.docRef);
                    },
                    title: Text("Files",style: title,),
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel',style: dialog.copyWith(color: Colors.grey[700])),
              ),
            ],
          );
        }
    );
  }

  Future filePicker(BuildContext context) async{
  try{
    if(fileType == 'pdf'){
      file = await FilePicker.getFile(type: FileType.custom,allowedExtensions: ['pdf']);
      setState(() {
        fileName = path.basename(file.path);
      });
      print("Pdf uploade");
    }
    if(fileType == 'image'){
      file = await FilePicker.getFile(type: FileType.image);
      setState(() {
        fileName = path.basename(file.path);
      });
      print("Image uploade");
    }
    if(fileType == 'video'){
      file = await FilePicker.getFile(type: FileType.video);
      setState(() {
        fileName = path.basename(file.path);
      });
      print("Video uploade");
    }
    if(fileType == 'other'){
      file = await FilePicker.getFile(type: FileType.any);
      setState(() {
        fileName = path.basename(file.path);
      });
      print("Other uploade");
    }
  }on PlatformException catch(e){
    showDialog(
      context: context,
      builder: (BuildContext context){
        print(e);
        return AlertDialog(
          title: Text("Error"),
          content: Text("Unsupported type.Please select another file"),
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

  uploadFiles(docId){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Edit Files Record'),
            content: Container(
              height: 240,
              child: Column(
                children: [
                ListTile(
                  title: Text("Pdf",style: title,),
                  leading: Icon(Icons.picture_as_pdf,color: Colors.grey[700],),
                  onTap: (){
                    setState(() {
                      fileType = 'pdf';
                    });
                    filePicker(context);
                  },
                ),
                  ListTile(
                    title: Text("Images",style: title,),
                    leading: Icon(Icons.image,color: Colors.grey[700]),
                    onTap: (){
                      setState(() {
                        fileType = 'image';
                      });
                      filePicker(context);
                    },
                  ),
                  ListTile(
                    title: Text("Video",style: title,),
                    leading: Icon(Icons.video_call,color: Colors.grey[700]),
                    onTap: (){
                      setState(() {
                        fileType = 'video';
                      });
                      filePicker(context);
                    },
                  ),
                  ListTile(
                    title: Text("Files",style: title,),
                    leading: Icon(Icons.attach_file_sharp,color: Colors.grey[700]),
                    onTap: (){
                      setState(() {
                        fileType = 'other';
                      });
                      filePicker(context);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back',style: dialog.copyWith(color: Colors.grey[700]),),
              ),
              FlatButton(
                onPressed: () async {
                  if(file!=null) {
                   _uploadData();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }else{
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save',style: dialog.copyWith(color: Colors.deepPurple),),
              ),
            ],
          );

        }
    );
  }

  updateData(docId,String name,TextEditingController _textEditingController,String word){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Edit $name Record'),
            content: Container(
              height: 190,
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width-40,
                    child: TextField(
                      controller: _textEditingController,
                      expands: true,
                      maxLines: null,
                      style:title,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: name,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back',style: dialog.copyWith(color: Colors.grey[700]),),
              ),
              FlatButton(
                onPressed: () async {
                  print(widget.patientDetails.docRef);
                  if(_textEditingController.text.length!=0){
                    await FirebaseFirestore.instance.collection("patientrecord").doc(docId).update(
                        {word:_textEditingController.text});
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }else{
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save',style: dialog.copyWith(color: Colors.deepPurple),),
              ),
            ],
          );
        }
    );
  }

  _uploadData()async{
  final p1= widget.patientDetails.id;
  final ref = widget.patientDetails.docRef;
  var random = new Random();
  String randomName ='';
  for(var i=0;i<10;i++){
    randomName += random.nextInt(20).toString();
  }
  print(randomName);
  print(random.nextInt(15));
  StorageReference storageReference = FirebaseStorage.instance.ref().child("patient/$p1/files/$fileName");
  final StorageUploadTask uploadTask = storageReference.putFile(file);
  final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
  final String url = await downloadUrl.ref.getDownloadURL();
  final data = {'file':url,'name':fileName,'type': fileType};
  await db.collection("patientrecord").doc(ref).collection("files").doc().set(data);
}

  _patientFilesView() async{
    final fileSnapshot = db.collection("patientrecord").doc(widget.patientDetails.docRef).collection("files").snapshots();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Patient Files'),
            content: Container(
              width: 350.0,
              height: 250,
              child: StreamBuilder(
                stream: fileSnapshot,
                builder: (context, AsyncSnapshot<QuerySnapshot>snapshot) {
                  if(snapshot.hasData){
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (BuildContext context, int i) {
                        return ListTile(
                          onTap: () async {
                            print(snapshot.data.docs[i]['file']);
                              var url = snapshot.data.docs[i]['file'];
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                          selectedTileColor: Colors.grey,
                          title: Text("${snapshot.data.docs[i]['name']}",style: TextStyle(color: Colors.grey[600],fontFamily: "CairoBold",fontSize: 15),),
                        );
                      },
                    );
                  }
                  if(snapshot.hasData == null){
                    return Center(
                        child: Text("No files Uploaded")
                    );
                  }
                  return Center(
                      child: CircularProgressIndicator(backgroundColor: Colors.pinkAccent,)
                  );
                }
              ),
            ),
            actions: [
              FlatButton(
                splashColor: Colors.grey,
                child: Text("Close",style: title.copyWith(color: Colors.grey[700]),),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    DateTime myDateTime = (widget.patientDetails.date).toDate();
    var date = DateFormat.yMMMd().add_Hm().format(myDateTime);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  fit: StackFit.passthrough,
                  children: [
                    Positioned(
                      top: 0,
                      left: -15,
                      child: IconButton(
                        icon: Icon(Icons.navigate_before,color: Colors.black,),
                        iconSize: 40,
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Container(
                              height: 160,
                              width: 110,
                              //color: Colors.red,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: Image.network("${widget.patientDetails.img}", height: 160,width:100,fit: BoxFit.fitHeight,))),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 50),
                          width: 200,
                          height: 250,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AutoSizeText(
                                '${widget.patientDetails.name}' ,softWrap: true,
                                style: TextStyle(fontSize: 26,fontFamily: "Cairo"),
                                maxLines: 2,
                              ),
                              SizedBox(height: 5,),
                              AutoSizeText(
                                "${widget.patientDetails.id}",
                                style: TextStyle(fontSize: 19, color: Colors.grey),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () async {
                                      var url = "mailto:${widget.patientDetails.mail}";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 16),
                                      child: Container(
                                          height: 45,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(255, 77, 106, 0.3), borderRadius: BorderRadius.circular(15)),
                                          child:Icon(Icons.email,color: Colors.red,)
                                        //"${widget.patientDetails.mail}"
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      var url = "tel:+91${widget.patientDetails.contact}";
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(right: 16),
                                      child: Container(
                                          height: 45,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(25, 140, 255, 0.3), borderRadius: BorderRadius.circular(15)),
                                          child:Icon(Icons.call,color: Colors.blueAccent,)
                                        //"${widget.patientDetails.contact}"
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(color: Colors.grey,),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Patient Records",
                  style: TextStyle(fontFamily:"Cairo",fontWeight: FontWeight.w600,fontSize: 21,color: Colors.black.withOpacity(0.7)),
                ),
                StreamBuilder(
                    stream: db.collection("patientrecord").where("id",isEqualTo: widget.patientDetails.id).snapshots(),
                    builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot) {
                      if(snapshot.hasData){
                        return Container(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget> [
                                  Text("Name",style: title,),
                                  SizedBox(width: 48,),
                                  Container(
                                    width:size.width-155,
                                    child: AutoSizeText(snapshot.data.docs[0]['name'], style: desc,maxLines: 2,softWrap: true,maxFontSize: 16,minFontSize: 16,),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget> [
                                  Text("Age",style: title,),
                                  SizedBox(width: 64,),
                                  Container(
                                    color: Colors.transparent,
                                    width: 250,
                                    height: 40,
                                    child: Text(snapshot.data.docs[0]['age'],style: desc,),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget> [
                                  Text("Gender",style: title,),
                                  SizedBox(width: 38,),
                                  Container(
                                    color: Colors.transparent,
                                    width: 250,
                                    height: 40,
                                    child: Text(snapshot.data.docs[0]['gender'],style: desc,),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget> [
                                  Text("Visit Date",softWrap:true,style:TextStyle(fontSize: 17,fontFamily: "CairoBold",fontWeight: FontWeight.w500),),
                                  SizedBox(width: 10,),
                                  Container(
                                    padding: EdgeInsets.only(left: 12),
                                    color: Colors.transparent,
                                    width: 220,
                                    height: 40,
                                    child: Text("${date.substring(0,12)}",style: desc,),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget> [
                                  Text("Visit Time",softWrap:true,style:TextStyle(fontSize: 17,fontFamily: "CairoBold",fontWeight: FontWeight.w500),),
                                  SizedBox(width: 10,),
                                  Container(
                                    padding: EdgeInsets.only(left: 12),
                                    color: Colors.transparent,
                                    width: 220,
                                    height: 40,
                                    child: Text("${date.substring(13)}",style: desc,),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget> [
                                  Text("Address",style: title,),
                                  SizedBox(width: 30,),
                                  Container(
                                    width:size.width-155,
                                    child: AutoSizeText(snapshot.data.docs[0]['address'], style: desc,maxLines: 5,softWrap: true,maxFontSize: 16,minFontSize: 16,),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget> [
                                  Text("Aliments",style: title,),
                                  SizedBox(width: 30,),
                                  Container(
                                    width:size.width-155,
                                    child: AutoSizeText(snapshot.data.docs[0]['problem'], style: desc,maxLines: 10,softWrap: true,maxFontSize: 16,minFontSize: 16,),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget> [
                                  Text("Medication",style: title,),
                                  SizedBox(width: 13,),
                                  Container(
                                    width:size.width-155,
                                    child: AutoSizeText(snapshot.data.docs[0]['treatment'], style: desc,maxLines: 10,softWrap: true,maxFontSize: 16,minFontSize: 16,),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                splashColor: Colors.deepPurple,
                                onTap: _patientFilesView,
                                child: Container(
                                  width: size.width-10,
                                  height: 50,
                                  child: Card(
                                    child: Center(child: Text("Patient Files",style: TextStyle(fontSize: 18,fontFamily: "CairoBold",color: Colors.grey[700]),)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(color: Colors.grey),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        );
                      }else{
                        return Center(
                            child: CircularProgressIndicator(backgroundColor: Colors.pinkAccent,)
                        );
                      }
                    }
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: update,
                        child: Container(
                          margin: EdgeInsets.only(right: 16),
                          child: Container(
                              height: 45,
                              width: 155,
                              decoration: BoxDecoration(
                                  border:Border.all(
                                      color:  Colors.pink,
                                      width: 2
                                  ) ,
                                  borderRadius: BorderRadius.circular(15)),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.edit,color: Colors.pink,),
                                  Text("Update",style: TextStyle(color: Colors.pink,fontWeight: FontWeight.w600),)
                                ],
                              )
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){

                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 16),
                          child: Container(
                              height: 45,
                              width: 155,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(166, 77, 255, 0.3), borderRadius: BorderRadius.circular(15)),
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.chat,color: Colors.deepPurple,),
                                  Text("Chat",style: TextStyle(color: Colors.deepPurple,fontWeight: FontWeight.w600),)
                                ],
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
              ],
            ),

          ),
        ),
      ),
    );
  }

}
