import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dailyrep.dart';
import 'tokenandstore.dart';
class TodaysOrders extends StatefulWidget {
  @override
  _TodaysOrdersState createState() => _TodaysOrdersState();
}
class _TodaysOrdersState extends State<TodaysOrders> {
  List<details> deta;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deta=List();
    FirebaseDatabase firebaseDatabase=FirebaseDatabase.instance;
    DatabaseReference databaseReference=firebaseDatabase.reference();
    databaseReference.child(token.tokenname).child(token.storename).child("DailySales").limitToLast(10).onChildAdded.listen((event) {
      setState(() {
        deta.add(new details(event.snapshot.value,event.snapshot.value["Day"].toString(),event.snapshot.value["DailyTotal"].toString(),event.snapshot.value["Dat"].toString(),event.snapshot.value["Month"].toString()));
      });
    });

    }

  @override
  Widget build(BuildContext context) {
    return
        MaterialApp(
          title: "DailySales",
          home: Scaffold(
            body: Container(
              child:ListView.builder(itemCount:deta.length <10 ? deta.length : 10,itemBuilder:  (BuildContext context,int index,){
                return

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>TodaysRepor( deta.elementAt(index).complete)));
                    },
                    child:Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)
                ),
                  child:Container(
                    height: 80,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:<Widget> [
                       Column(
                         mainAxisSize: MainAxisSize.max,
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           Text(deta.elementAt(index).day,style: TextStyle(
                               fontSize:20,fontWeight: FontWeight.bold,color: Colors.purple
                           ),)
                           ,

                           Text(deta.elementAt(index).date+" "+deta.elementAt(index).month+" 2020",style: TextStyle(
                               fontSize:15,fontWeight: FontWeight.bold , color: Colors.grey
                           ),)],
                       )
                        ,
                        Padding(
                          padding: EdgeInsets.only(top:5.0,bottom: 5.0),
                        child:Container(
                          width: 2.0,
                          color: Colors.grey,
                        )),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Sales",style: TextStyle(
                                fontSize:15,fontWeight: FontWeight.bold,color: Colors.purple
                            ),)
                            ,

                            Text(deta.elementAt(index).total,style: TextStyle(
                                fontSize:20,fontWeight: FontWeight.bold , color: Colors.greenAccent
                            ),)],
                        )
                      ],
                    )
                  ),
                ));
    }
            )),
            appBar: AppBar(title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
              Text("DailySales",style: TextStyle(
              color: Colors.purple
            )),
              Icon(Icons.calendar_today,color: Colors.purple,)
              ]),backgroundColor: Colors.white,),
          ),
        );

        }
}


class details {
  String day;
  String date;
  String year="2020";
  String month;
  String total;
  Map<dynamic,dynamic> complete;
  details(dynamic value,String day, String total, String date, String month){
    this.day=day;
    this.total=total;
    this.date=date;
    this.month=month;
    this.complete=value;
  }
}
