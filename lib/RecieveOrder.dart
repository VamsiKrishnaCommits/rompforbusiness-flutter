import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'tokenandstore.dart';

class RecieveOrder extends StatefulWidget {
  @override
  _RecieveOrderState createState() => _RecieveOrderState();
}
class _RecieveOrderState extends State<RecieveOrder> {
  FirebaseDatabase firebaseDatabase;
  DatabaseReference databaseReference;
  String status;
  String button1;
  String button2;
  int count = 0;
  String select;
  List<order> selected=new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<order> a;
    a = new List();
    count=0;
    select="All";
    button1="Accept";
    button2="Reject";
    firebaseDatabase = FirebaseDatabase.instance;
    databaseReference = firebaseDatabase.reference();
    databaseReference
        .child(token.tokenname).child(token.storename).child("orders")
        .onChildAdded
        .listen((onData) {
        print("state changed");
        if(onData.snapshot.value["status"]!="Delivered") {
          a.insert(0, new order(onData.snapshot, onData.snapshot.key));
          count++;
if(select=="All")
  selected=a;
        }
        setState(() {

        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:Stack(
        children: <Widget>[
Padding(padding: EdgeInsets.only(top:30),
        child:  ListView.builder(itemBuilder: (BuildContext context, int index) {
          print(selected.elementAt(index).total.toString());
            return car(selected.elementAt(index));
          },itemCount: count,
          )),
          SingleChildScrollView(
              scrollDirection:Axis.horizontal,
              child:Row(
                children:[
    GestureDetector(
    onTap: (){
        count=0;
      List<order> a;
      a = new List();
      select="All";
      button1="Accept";
      button2="Reject";
      firebaseDatabase = FirebaseDatabase.instance;
      databaseReference = firebaseDatabase.reference();
      databaseReference
          .child(token.tokenname).child(token.storename).child("orders")
          .onChildAdded
          .listen((onData) {
        setState(() {
          if(onData.snapshot.value["status"]!="Delivered") {
            a.insert(0, new order(onData.snapshot, onData.snapshot.key));
            count++;
            if(select=="All")
              selected=a;
          }
        });
      });
    }
          ,    child:    Container(
    child:Padding(
padding:EdgeInsets.all(10.0),
              child:Text("All Orders",style: TextStyle(
                fontSize: 20.0
              ),)
    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0,color: Colors.grey)
                    ),
                  ))
    ,
                  GestureDetector(
                      onTap: (){
                        select="Accepted";
                        List<order> a;
                        a=List();
                        count=0;
                        firebaseDatabase = FirebaseDatabase.instance;
                        databaseReference = firebaseDatabase.reference();
                        databaseReference
                            .child(token.tokenname).child(token.storename).child("orders")
                            .onChildAdded
                            .listen((onData) {
                          setState(() {
                            if(onData.snapshot.value["status"]=="Accepted") {
                              a.insert(0, new order(
                                  onData.snapshot, onData.snapshot.key));
                              count++;
                            }
                            selected=a;
                          });
                        });
                      },
                      child:Container(
                    child:Padding(
                        padding:EdgeInsets.all(10.0),
                        child:Text("Accepted",style: TextStyle(
                            fontSize: 20.0
                        ),)
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(width: 1.0,color: Colors.grey)
                    ),
                  )),
                  GestureDetector(
onTap:(){
  List<order> a;
  select="On The Way";
    a=List();
      count=0;
    firebaseDatabase = FirebaseDatabase.instance;
    databaseReference = firebaseDatabase.reference();
    databaseReference
        .child(token.tokenname).child(token.storename).child("orders")
        .onChildAdded
        .listen((onData) {
    setState(() {
    if(onData.snapshot.value["status"]=="On The Way") {
    a.insert(0, new order(
    onData.snapshot, onData.snapshot.key));
    count++;
    }
    });
    });
    selected=a;
    },
                      child:Container(
                    child:Padding(
                        padding:EdgeInsets.all(10.0),
                        child:Text("On the way",style: TextStyle(
                            fontSize: 20.0
                        ),)
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(width: 1.0,color: Colors.grey)
                    ),
                  )),
                  GestureDetector(
                      onTap: (){
                          count=0;
                        select="Delivered";
                        List<order> a;
                        a=List();
                        firebaseDatabase = FirebaseDatabase.instance;
                        databaseReference = firebaseDatabase.reference();
                        databaseReference
                            .child(token.tokenname).child(token.storename).child("orders")
                            .onChildAdded
                            .listen((onData) {
                          setState(() {
                            if(onData.snapshot.value["status"]=="Delivered") {
                              count++;
                              a.insert(0, new order(
                                  onData.snapshot, onData.snapshot.key));
                            }
                            selected=a;
                          });
                        });
                      },
                      child:Container(
                    child:Padding(
                        padding:EdgeInsets.all(10.0),
                        child:Text("Delivered",style: TextStyle(
                            fontSize: 20.0
                        ),)
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(width: 1.0,color: Colors.grey)
                    ),
                  )),
                  GestureDetector(
                     onTap: (){
                       List<order> a;
                       select="Rejected";
                       a=List();
                        count=0;
                       firebaseDatabase = FirebaseDatabase.instance;
                       databaseReference = firebaseDatabase.reference();
                       databaseReference
                           .child(token.tokenname).child(token.storename).child("orders")
                           .onChildAdded
                           .listen((onData) {
                         setState(() {
                           if(onData.snapshot.value["status"]=="Rejected") {
                             print("hey");
                             a.insert(0, new order(
                                 onData.snapshot, onData.snapshot.key));
                             count++;
                           }
                           print(count);
                         });
                       });
                       selected=a;
                     },

                      child:Container(
                    child:Padding(
                        padding:EdgeInsets.all(10.0),
                        child:Text("Rejected",style: TextStyle(
                            fontSize: 20.0
                        ),)
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(width: 1.0,color: Colors.grey)
                    ),
                  ))],
              )),
        ],
      )
    );
  }
}

class order{
  String Address;
  String phonenumber;
  String modeOfPay;
  String name="Vamsi";
  String id;
  String token;
  int total;
  String time;
  String status;
  List<DataRow> items=List();
  order(DataSnapshot snapshot, String key){
    Map<dynamic,dynamic> val=snapshot.value;
    id=key;
    total=val["items"]["total"];
    Map<dynamic,dynamic> item=val["items"];
item.remove("total");
    item.forEach((key, value) {
      items.add(new DataRow(
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
    status=val["status"];
    Address=val["address"];
    phonenumber=val["phone"];
    modeOfPay=val["method"];
    token=val["tok"];
    time=val["time"];
  }
}
class car extends StatefulWidget {
  order o;
  car(order elementAt){
o=elementAt;
  }
  @override
  _carState createState() => _carState();
}
class _carState extends State<car> {
 String button1;
 String button2;
 var width;
 var visibility=true;
FirebaseDatabase firebaseDatabase=FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    order o=widget.o;
    databaseReference=firebaseDatabase.reference().child(token.tokenname).child(token.storename).child("orders").child(o.id).child("status");
  }
  @override
  Widget build(BuildContext context) {
    order o=widget.o;
    if(o.status=="New Order"){
      button1="Accept";
      button2="Reject";
      width=100.0;
    }
    else if(o.status=="Accepted") {
      button1="Delivered";
      button2="On The Way";
      width=150.0;
    }
    else if(o.status=="On The Way"){
      button1="Delivered";
      print("hey");
      width=170.0;
      button2="";
      visibility=false;
    }
    else{
      button1="Delivered";
      print("hey");
      width=170.0;
      button2="";
      visibility=false;
    }
    return Padding(
        padding: EdgeInsets.all(5.0),
        child: Container(
          child:SizedBox(
              height: 300,
              width: double.infinity,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(
                        child :Row(
                            children:<Widget>[
                              Flexible(
                                  flex: 2,
                                  child:Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            'OrderDetails',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily: 'Segoe UI',
                                              fontSize: 25,
                                              color: Colors.purple,
                                            ),
                                          ),
                                          Container(height: 1,color: Colors.grey,),
                                          RichText(
                                            text: TextSpan(
                                              style: DefaultTextStyle.of(context).style,
                                              children: <TextSpan>[
                                                TextSpan(text: 'OrderID: ', style: TextStyle(
                                                    color:Colors.purple,fontSize : 15.0,fontWeight: FontWeight.bold)),
                                                TextSpan(text: o.id.substring(0,5)),
                                              ],
                                            ),
                                          )
                                          ,
                                          RichText(
                                            text: TextSpan(
                                              style: DefaultTextStyle.of(context).style,
                                              children: <TextSpan>[
                                                TextSpan(text: 'Total: ', style: TextStyle(
                                                    color:Colors.purple,fontSize : 15.0,fontWeight: FontWeight.bold)),
                                                TextSpan(text: o.total.toString()),
                                              ],
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              style: DefaultTextStyle.of(context).style,
                                              children: <TextSpan>[
                                                TextSpan(text: 'Payment : ', style: TextStyle(
                                                    color:Colors.purple,fontSize : 15.0,fontWeight: FontWeight.bold)),
                                                TextSpan(text: o.modeOfPay),
                                              ],
                                            ),
                                          ), RichText(
                                            text: TextSpan(
                                              style: DefaultTextStyle.of(context).style,
                                              children: <TextSpan>[
                                                TextSpan(text: 'Status : ', style: TextStyle(
                                                    color:Colors.purple,fontSize : 15.0,fontWeight: FontWeight.bold)),
                                                TextSpan(text: o.status),
                                              ],
                                            ),
                                          ) ,   ],
                                      )))
                              ,
                              Container(width: 1,color: Colors.grey,),
                              Flexible(
                                  flex: 1,
                                  child:Align(
                                      alignment: Alignment.topCenter,
                                      child:  Column(
                                        mainAxisSize: MainAxisSize.max
                                        ,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
RaisedButton(
  child: Text("View Items",style:TextStyle(color: Colors.white),),
  color: Colors.purple[200],
  onPressed: (){
    showDialog(
    context: context,
    builder: (BuildContext context){
    return

      FractionallySizedBox(
    widthFactor: 3/4,
    heightFactor: 3/4,
    child:Container(
      child:Material(
   child: DataTable(
    rows: o.items,
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

      ))))
        ;
  },
);}),

                                          Text("Name",style: TextStyle(
                                            fontWeight: FontWeight.bold
                                                ,
                                            fontSize: 20
                                          ),),
                                          Text("Phone Number",style: TextStyle(
                                          ),),
                                          Text("Address"),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Icon(Icons.call),
                                              Container(width: 1,color: Colors.grey,),

                                              Icon(Icons.message)
                                            ],
                                          )

                                  ])
                              )
                    )
                            ]
                        )),

                    Container(height: 1,color: Colors.grey,),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                         AnimatedContainer(
                           width: width,
                          curve: Curves.bounceOut,
                          duration: Duration(seconds: 1),
                          child: RaisedButton(
                            onPressed: (){

                                if(o.status=="New Order"){
                                  databaseReference.set("Accepted").then((onValue){setState(() {
                                  });
                                  }).catchError((onError){
                                  });
                                  o.status = "Accepted";
                                  button1="Delivered";
                                  button2="On The Way";
                                  width=150.0;
                                }
                                else if(o.status=="Accepted" || o.status=="On The Way"){
                                  databaseReference.set("Delivered").then((onValue){
                                    setState(() {
                                      o.status="Delivered";
                                    });
                                  }).catchError((onError){
                                  });
                                }
                            },
                            color: Colors.green,
                            child: Text(button1,style: TextStyle(
                                color: Colors.white
                            ),),

                           )),

                     AnimatedContainer(
                       duration: Duration(seconds: 1),
                       width:width,
                         child:Visibility(
                            visible: visibility,
                          child: RaisedButton(
                            onPressed: (){
                              setState(() {
if(o.status=="New Order") {
  o.status = "Rejected";
  databaseReference.set("Rejected").then((onValue){

  }).catchError((onError){

  });
}
else{
  o.status="On The Way";
  databaseReference.set("On The Way").then((onValue){

  }).catchError((onError){

  });
  visibility=false;
  width=170.0;
}});
                            },
                            color: Colors.red,
                            child: Text(button2,style:TextStyle(
                                color:Colors.white
                            )),

                          )))]
                    )]))
          ,
          decoration: BoxDecoration(
            color: const Color(0xffffffff),
            borderRadius: BorderRadius.circular(15),
            boxShadow:[BoxShadow(offset: const Offset(0,3), blurRadius: 6,color: const Color(0xff000000).withOpacity(0.16),)],
          ),

        ) );
  }
}

