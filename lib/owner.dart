import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class owner extends StatefulWidget {
  @override
  _ownerState createState() => _ownerState();
}

class _ownerState extends State<owner> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: "OwnerSide",
      home: content()
      );
  }
}
class content extends StatefulWidget {
  @override
  _contentState createState() => _contentState();
}

class _contentState extends State<content> {
  double size=0;
  @override
  Widget build(BuildContext context) {
    size=MediaQuery.of(context).size.height/4;
    return
      Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.line_weight,color: Colors.blue,),
          title:
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
          children:[
            Text(
              "Romp!",style: GoogleFonts.viga(
                color: Colors.blue
            ),
            ),
            Spacer(),
            Icon(Icons.person,color: Colors.green,)
,
            Text(
          "Owner",style: GoogleFonts.viga(
          color: Colors.green
          ),
          ),
          ]
          ) ,

          backgroundColor: Colors.white10.withOpacity(0.0),
          elevation: 0,
        ),
        body:Container(
      child:
      SingleChildScrollView(
      child:Column(
        children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex:1,
                  child: Container(
                      height:MediaQuery.of(context).size.height/5
                      ,child:Card(
                    color: Colors.blue,
                    child: Container(
                      child: Column(
                          children: [

                            Expanded(
                                flex: 3,
                                child:Icon(Icons.monetization_on,size: 50,color: Colors.white,)
                            ),
                            Expanded(
                                flex:1,
                                child:Text("Total Revenue today",textAlign: TextAlign.center,style: TextStyle(
                                    color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold
                                ),)),
                            Expanded(
                                flex:1,
                                child:Text("1000000000000",textAlign: TextAlign.center,style: TextStyle(
                                    color: Colors.white,fontSize: 14
                                ),))
                          ]
                      ),
                    ),
                    elevation: 10,
                  )
                  )),
              Expanded(
                  flex:1,
                  child: Container(
                      height:MediaQuery.of(context).size.height/5
                      ,child:Card(
                    color: Colors.blue,
                    child: Container(
                      child: Column(
                          children: [

                          Expanded(
                            flex: 3,
                        child:Icon(Icons.graphic_eq,size: 50,color: Colors.white,)
                          ),
                           Expanded(
                             flex:2,
                            child:Text("Get Today's Sales Ananlysis ",textAlign: TextAlign.center,style: TextStyle(
                                color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold
                            ),)),

                          ]
                      ),
                    ),
                    elevation: 10,
                  )
                  ))
                    ],
          ),
       Padding(
           padding: EdgeInsets.only(top: 10,bottom: 10,left: 5),
           child:   Align(
            alignment: Alignment.bottomLeft,
            child:Container(
              child: Text("Branches",style: TextStyle(
              color: Colors.blue,fontSize: 25,fontWeight: FontWeight.bold
          ),),
            ))),
          FutureBuilder(
future: getbranches(),
            builder: (BuildContext context,AsyncSnapshot<dynamic> snap){
if(snap.data!=null){
  DataSnapshot a=snap.data;
  List<String> branches=List();
  Map s=a.value;
  s.forEach((key, value) {
    branches.add(key);
  });
    return GridView.count(crossAxisCount: 3,shrinkWrap: true,physics: NeverScrollableScrollPhysics(),children: List.generate(branches.length , (index){
      return
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)
          ),
        child:Container(
        child:Center(
          child:Column(
      children: [
         Expanded(
           child:
           Center(
          child:Text(index<3 ? branches.elementAt(index): index.toString(),style: TextStyle(
            color: Colors.blue,
            fontSize: 15,fontWeight: FontWeight.bold
          ))),),
          ]),
        ))
      );
    }),);
}
return CircularProgressIndicator(
  backgroundColor: Colors.orange,
);
            }
            )
        ],
      )),
    ));
  }

  getbranches() async {
   FirebaseDatabase f= FirebaseDatabase.instance;
   DatabaseReference da=f.reference();
   var a=await  da.child("Y9Ie2BhyagRySzbqq3PjwTvMoIz2").child("branches").once();
   return a;
  }
}
