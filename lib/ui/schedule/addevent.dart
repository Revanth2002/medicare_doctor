import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class AddEventPage extends StatefulWidget {
  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore _db = FirebaseFirestore.instance;


  TextStyle style = TextStyle(fontFamily: 'CairoBold', fontSize: 20.0,color: Colors.deepPurple);
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController();
    _description = TextEditingController();
    _eventDate = DateTime.now();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          width: size.width,
          height: size.height,
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Container(
                height: 80,
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.navigate_before,size: 40,color: Colors.black,),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30,top: 5),
                      child: Text("Add Event",style: TextStyle(color: Colors.deepPurple,fontSize: 26,fontWeight: FontWeight.bold,fontFamily: "CairoBold"),),
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  maxLength: 25,
                  controller: _title,
                  validator: (value) =>
                  (value.isEmpty) ? "Please Enter title" : null,
                  style: style.copyWith(color: Colors.black,fontFamily: "Cairo",fontSize: 18),
                  decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: style,
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurpleAccent,width: 1.5),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),

                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _description,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 100,
                  validator: (value) =>
                  (value.isEmpty) ? "Please Enter description" : null,
                  style: style.copyWith(color: Colors.black,fontFamily: "Cairo",fontSize: 18),
                  decoration: InputDecoration(
                      labelText: "description",
                      labelStyle: style,
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.deepPurpleAccent,width: 1.5),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                title: Text("Date (YYYY-MM-DD)",style: style,),
                subtitle: Text(
                    "${_eventDate.year} - ${_eventDate.month} - ${_eventDate.day}",style: style.copyWith(color: Colors.black,fontFamily: "Cairo",fontSize: 18),),
                onTap: () async {
                  DateTime picked = await showRoundedDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime(DateTime.now().year + 2),
                    initialDatePickerMode: DatePickerMode.day,
                    theme: ThemeData(primarySwatch: Colors.deepPurple),
                    borderRadius: 16,
                      customWeekDays: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
                      styleDatePicker: MaterialRoundedDatePickerStyle(
                        textStyleDayButton: TextStyle(fontSize: 35, color: Colors.white),
                        textStyleYearButton: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                        textStyleDayHeader: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        textStyleCurrentDayOnCalendar: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                        textStyleDayOnCalendar: TextStyle(color: Colors.white),
                        textStyleDayOnCalendarSelected: TextStyle( color: Colors.white, fontWeight: FontWeight.bold),
                        textStyleDayOnCalendarDisabled: TextStyle( color: Colors.white.withOpacity(0.1)),
                        textStyleMonthYearHeader: TextStyle(fontSize: 20,fontFamily: "CairoBold", color: Colors.white, fontWeight: FontWeight.bold),
                        sizeArrow: 20,
                        colorArrowNext: Colors.white,
                        colorArrowPrevious: Colors.white,
                        textStyleButtonAction: TextStyle(fontSize: 20, color: Colors.white),
                        textStyleButtonPositive: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        textStyleButtonNegative: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.5)),
                        decorationDateSelected: BoxDecoration(color: Colors.orange[600], shape: BoxShape.circle),
                        backgroundPicker: Colors.deepPurple[400],
                        backgroundActionBar: Colors.deepPurple[300],
                        backgroundHeaderMonth: Colors.deepPurple[300],
                       ),
                      styleYearPicker: MaterialRoundedYearPickerStyle(
                        textStyleYear: TextStyle(fontSize: 15, color: Colors.white),
                        textStyleYearSelected: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                        backgroundPicker: Colors.deepPurple[400],
                      )
                  );
                  if (picked != null) {
                    setState(() {
                      _eventDate = picked;
                    });
                  }
                },
              ),
              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.deepPurple,
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          processing = true;
                        });

                        final data = {
                          "title": _title.text,
                          "description": _description.text,
                          "event_date": _eventDate
                        };
                        final FirebaseAuth auth = FirebaseAuth.instance;
                        final User user = auth.currentUser;
                        final String uid = user.uid.toString();
                         await _db.collection("users").doc(user.uid).collection("events").doc().set(data);
                        print(uid);
                        Navigator.pop(context);
                      }else{
                        setState(() {
                          processing = false;

                        });
                      }
                    },
                    child: Text(
                      "Add",
                      style: style.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}