import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicare/models/patientRecords.dart';
import 'package:medicare/services/firebase_services.dart';
import 'package:medicare/widgets.dart';


class PastPatient extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1280) {
          return PastPatientDesktop();
        } else if (constraints.maxWidth > 840 && constraints.maxHeight < 1280) {
          return PastPatientTablet();
        } else {
          return PastPatientMobile();
        }
      },
    );
  }
}

class PastPatientDesktop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PastPatientTablet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PastPatientMobile extends StatefulWidget {
  @override
  _PastPatientMobileState createState() => _PastPatientMobileState();
}

class _PastPatientMobileState extends State<PastPatientMobile> {
  final patientRetrieve  = db.collection("patientrecord")
      .where("doctor",isEqualTo: userUid.uid)
      .snapshots();

  TextEditingController _searchController = new TextEditingController();

  Future resultsLoaded;
  List _allResults= [];
  List _resultList =[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose(){
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();

  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    resultsLoaded = getPatientDetails();
  }

  _onSearchChanged(){
    searchResultList();
  }

  searchResultList(){
    var  showResults = [];
    if(_searchController.text!=""){
      for(var patientSnapshot in _allResults){
        var name = PatientRecords.fromSnapshot(patientSnapshot).name.toLowerCase();
        if(name.contains(_searchController.text.toLowerCase())){
          showResults.add(patientSnapshot);
          print(showResults);
        }
      }
    }else{
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultList = showResults;
    });
  }

  getPatientDetails()async{
    var data  = await db.collection("patientrecord")
        .where("doctor",isEqualTo: userUid.uid)
        .orderBy("date",descending: true)
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
    return "complete";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.navigate_before,
                      color: Colors.black,
                    ),
                    iconSize: 40,
                    onPressed: () {
                      print(userUid.uid);
                      Navigator.pop(context);
                    },
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 20, 0),
                      child: Container(
                        height: 50,
                        child: TextField(
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          cursorColor: Colors.grey,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 20, top: 10),
                            fillColor: Colors.grey.withOpacity(0.1),
                            filled: true,
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.grey),
                              borderRadius: new BorderRadius.circular(5),
                            ),
                            hintText: "Search by Patient",
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                            suffixIcon: Icon(
                              Icons.search,
                              size: 25,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Your Patients",
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontFamily: "CairoBold",
                          fontSize: 20),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
              Expanded(
                child: StreamBuilder(
                    stream: patientRetrieve,
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                            itemCount: _resultList.length,
                            itemBuilder: (BuildContext context,int index)=>
                                buildPatientCard(context,_resultList[index])
                        );
                      }else{
                        return Center(
                            child: CircularProgressIndicator(backgroundColor: Colors.pinkAccent,)
                        );
                      }
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}