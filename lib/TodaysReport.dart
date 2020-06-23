import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'showcomplete.dart';
import 'tokenandstore.dart';
class TodaysReport extends StatefulWidget {
  @override
  _TodaysReportState createState() => _TodaysReportState();
}

class _TodaysReportState extends State<TodaysReport> {
  List<DataRow> mostsold=List();
  List<DataRow> itemcount=List();
  var fut;
  var fut2;
  String totalrevenue="Loading...";
  String totalsales="Loading...";
  @override
  void initState(){
    mostsold.add(new DataRow(cells:[ DataCell(Text("hey")),DataCell(Text("hey"))]));
    // TODO: implement initState
    super.initState();
    FirebaseDatabase firebaseDatabase=FirebaseDatabase.instance;
    DatabaseReference databaseReference=firebaseDatabase.reference();
    fut=getdeets();
    fut2=getdeets2();
    getrevenue();
    gettotalsales();

    databaseReference.child(token.tokenname).child(token.storename).child("DailySales").child("DailyItemsSpent").limitToLast(5).onChildChanged.listen((event) {
      mostsold=List();
      Map<dynamic,dynamic> aa=event.snapshot.value;
      aa.forEach((key, value) {
        mostsold.add(new DataRow(
            cells: [
              DataCell(
                  Text(key.toString())
              ),
              DataCell(
                  Text(value.toString())
              )
            ]
        ));
        print(mostsold.toString());
      });
    });
    databaseReference.child(token.tokenname).child(token.storename).child("DailySales").child("DailyTotal").child("20200520").onChildChanged.listen((event) {
      setState(() {
        totalrevenue=event.snapshot.toString();
      });
    });
    databaseReference.child(token.tokenname).child(token.storename).child("DailySales").child("DailyTotalSales").child("20200520").onChildChanged.listen((event) {
      setState(() {
        totalsales=event.snapshot.toString();
      });
    });

    databaseReference.child(token.tokenname).child(token.storename).child("items").limitToLast(5).onChildChanged.listen((event) {
      itemcount=List();
      Map<dynamic,dynamic> aa=event.snapshot.value;
      aa.forEach((key, value) {
        itemcount.add(new DataRow(
            cells: [
              DataCell(
                  Text(value["name"])
              ),
              DataCell(
                  Text(value["stock"])
              )
            ]
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(mostsold);
    return Container(
    child:SingleChildScrollView(  child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:<Widget>[
SizedBox(height: 30,),
    Center(child:
    Text("Today's Revenue",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),)),
          SizedBox(height: 10,),
          Text(totalrevenue,style: TextStyle(fontSize: 90,color: Colors.purple),),
          SizedBox(height: 30,),
          Center(child:  Text("Today's sales",style: TextStyle(fontSize:20,fontWeight :  FontWeight.bold),)),
          SizedBox(height: 10,),
          Text(totalsales,style: TextStyle(fontSize: 60,color: Colors.purple),),
          SizedBox(height: 30,),
          Center(child:  Text("Today's Profit",style: TextStyle(fontSize:20,fontWeight :  FontWeight.bold),)),
          SizedBox(height: 10,),
          Text("123445",style: TextStyle(fontSize: 60,color: Colors.purple),),
          SizedBox(height: 30,),
          Center(child:  Text("Most Sold Today",style: TextStyle(fontSize:20,fontWeight :  FontWeight.bold),)),
        SizedBox(height: 20,),
      FractionallySizedBox(
        widthFactor: 5/6,
        child:
        DataTable(
          rows: mostsold,
          columns: [
            DataColumn(
                label: Text("Itemname"),
                numeric: false
            ),
            DataColumn(
                label: Text("number"),
                numeric: false
            )
          ],
        )),
          RaisedButton(
            child: Text("See all items"),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>showcomplete(mostsold)));
            },
          ),
          SizedBox(height: 20,),

          Center(child:  Text("Remaining stock",style: TextStyle(fontSize:20,fontWeight :  FontWeight.bold),)),
          SizedBox(height: 20,),
        FractionallySizedBox(
            widthFactor: 5/6,
            child:
            DataTable(
              rows: itemcount,
              columns: [
                DataColumn(
                    label: Text("Itemname"),
                    numeric: false
                ),
                DataColumn(
                    label: Text("number"),
                    numeric: false
                )
              ],
            )),
          RaisedButton(
            child: Text("See all items"),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>showcomplete(itemcount)));
            },
          )
        ])
    ));
  }
  getdeets(){
    FirebaseDatabase firebaseDatabase=FirebaseDatabase.instance;
    DatabaseReference databaseReference=firebaseDatabase.reference();
var fut=    databaseReference.child(token.tokenname).child(token.storename).child("DailySales").child("DailyItemsSpent").child("20200510").limitToLast(5).once();
fut.then((value) {
  setState(() {
  mostsold=List();
  Map<dynamic,dynamic> aa=value.value;
  aa.forEach((key, value) {
    mostsold.add(new DataRow(
        cells: [
          DataCell(
              Text(key.toString())
          ),
          DataCell(
              Text(value.toString())
          )
        ]
    ));
  });
  });
}).catchError((onError){
  print(onError);
    });
  }
  getdeets2(){
    FirebaseDatabase firebaseDatabase=FirebaseDatabase.instance;
    DatabaseReference databaseReference=firebaseDatabase.reference();
    var fut=    databaseReference.child(token.tokenname).child(token.storename).child("items").once();
    fut.then((value) {
      setState(() {
        itemcount=List();
        Map<dynamic,dynamic> aa=value.value;
        aa.forEach((key, value) {
          itemcount.add(new DataRow(
              cells: [
                DataCell(
                    Text(value["name"])
                ),
                DataCell(
                    Text(value["stock"])
                )
              ]
          ));
        });
      });
    }).catchError((onError){
      print(onError);
    });
  }

  void getrevenue() {
     FirebaseDatabase firebaseDatabase=FirebaseDatabase.instance;
     DatabaseReference databaseReference=firebaseDatabase.reference();
  var fut=databaseReference.child(token.tokenname).child(token.storename).child("DailySales").child("DailyTotal").child("20200510").once();
  fut.then((value) {
    setState(() {
      totalrevenue=value.value.toString();
    });
  });
  }

  void gettotalsales() {
    FirebaseDatabase firebaseDatabase=FirebaseDatabase.instance;
    DatabaseReference databaseReference=firebaseDatabase.reference();
    var fut=databaseReference.child(token.tokenname).child(token.storename).child("DailySales").child("DailyTotalSales").child("20200510").once();
    fut.then((value) {
      setState(() {
        totalsales=value.value.toString();
      });
    });
  }
}

class ItemsSpent {
  String name;
  int count;
  ItemsSpent(dynamic key,dynamic value){
    this.name=key;
    this.count=value;
  }
}
