import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'RecieveOrder.dart';
import 'ManagerCheckout.dart';
import 'item.dart';
import 'tokenandstore.dart';

class sale extends StatefulWidget {
  final Map<dynamic,dynamic> cart;
  final List<item> l;
  sale(this.cart, this.l);
  @override
  _saleState createState() => _saleState();
}
class _saleState extends State<sale> {
  List<Weight> weightData;
  String selected="";
  var isDisable=true;
  Map<dynamic,dynamic> item=Map();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int l=widget.l.length;
    for(int i=0;i<l;i++){
      item[widget.l.elementAt(i).name]=widget.l.elementAt(i).cost;
    }
    weightData=List();
    widget.cart.forEach((k,v) {
      if(k=="total")
        weightData.insert(0, Weight("Total",v));
      else
      weightData.add(Weight(k,v));});
  }
  @override
  Widget build(BuildContext context) {
    print("heyeeee");
    print(new DateTime.now());
    return MaterialApp(
      title: "Sale",
      home: Scaffold(
        appBar:AppBar(
        iconTheme: IconThemeData(color: Colors.purple),
    backgroundColor: Colors.white,
    title:  Text("Sale",style: TextStyle(
    color: Colors.purple
    ),)),

    body:
        Column(
    children:<Widget>[
      Expanded(
      flex:6,
        child: Container(
           child:Scrollbar(
           child:ListView.builder(shrinkWrap:true,itemCount: weightData.length,itemBuilder: (BuildContext context,int index,){
           if(index!=0){
             return Container(
               color: Colors.purple[100],
             height: 60,
             child: Row(
               mainAxisAlignment: MainAxisAlignment.start,
               children: <Widget>[
                 Expanded(
                    child:Center( child:Text(weightData.elementAt(index).number.toString(),style: TextStyle(
                         color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold
                     ),))
                 ),Expanded(
                     child:Center(child:Text("X",style: TextStyle(
                       color: Colors.purple,fontWeight: FontWeight.bold
                     ),))
                 ),
                 Expanded(
                     child:
                     Center(child:Text(weightData.elementAt(index).itemname,style: TextStyle(
                         fontSize: 20,color:Colors.white
                     ),))), Expanded(
                     child:
                     Center(child:Text(((item[weightData.elementAt(index).itemname] )* weightData.elementAt(index).number).toString() ,style: TextStyle(
                         fontSize: 20,color:Colors.white
                     ),)))


               ],
             ),
           );}

           return Container(
             height: 60,
             child:
Card(
  child:Container(
    color: Colors.purple[200],
               child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               mainAxisSize: MainAxisSize.min,
               children: <Widget>[
                 Center(child:Text("Items  :",style: TextStyle(
                     fontSize: 20,color:Colors.white,fontWeight: FontWeight.bold
                 ),)), Text((weightData.length-1).toString()+"  ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,
                   color: Colors.white
                   ,)
                 ),


                     Center(child:Text("Total  :",style: TextStyle(
                         fontSize: 20,color:Colors.white,fontWeight: FontWeight.bold
                     ),)), Text(weightData.elementAt(index).number.toString()+"  ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,
                         color: Colors.white
                     ,)
                 )

,
               ],
             ))),
           );

           })),


          ))
    ,
Expanded(
  flex:1,

  child:Container(
      color:Colors.purple[200],
  child:
  Center(
      child:Text("Select a payment method",style: TextStyle(
    fontWeight: FontWeight.bold,color: Colors.white,fontSize: 30
  ),))),
),
Expanded(
  flex: 2,
child:Container(
  child:Row(
    children: <Widget>[
     Expanded(child:
         AnimatedContainer(
           curve: Curves.bounceOut,duration: Duration(seconds: 1),
           decoration: BoxDecoration(
             color: selected=="cash" ? Colors.purple[200]:Colors.white ,
             borderRadius: BorderRadius.circular(selected=="cash" ? 5.0 : 0.0),
           ),
    child: GestureDetector(
       onTap: (){
         setState(() {
           selected="cash";
         });
       },
         child:Container(
       child:Center(child:Column(
         mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.attach_money,size: 70,color: selected!="cash" ?Colors.purple[200]:Colors.white,),SizedBox(height: 5,),Text("Cash",style: TextStyle(
          color:selected=="cash" ? Colors.white :Colors.purple[200]
        ),)
      ],
  )),

        decoration: BoxDecoration(
          border: Border.all(color: Colors.purple[100])
        ),
      )))),
      Expanded(child:
      AnimatedContainer(
          curve: Curves.bounceOut,duration: Duration(seconds: 1),
          decoration: BoxDecoration(
            color: selected=="UPI" ? Colors.purple[200]:Colors.white ,
            borderRadius: BorderRadius.circular(selected=="UPI" ? 5.0 : 0.0),
          ),
          child: GestureDetector(
              onTap: (){
                setState(() {
                  selected="UPI";
                });
              },
              child:Container(
                child:Center(child:Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.attach_money,size: 70,color: selected!="UPI" ?Colors.purple[200]:Colors.white,),SizedBox(height: 5,),Text("UPI",style: TextStyle(
                        color:selected=="UPI" ? Colors.white :Colors.purple[200]
                    ),)
                  ],
                )),

                decoration: BoxDecoration(
                    border: Border.all(color: Colors.purple[100])
                ),
              )))),
    Expanded(
        child:
    AnimatedContainer(
        curve: Curves.bounceOut,duration: Duration(seconds: 1),
        decoration: BoxDecoration(
          color: selected=="khata" ? Colors.purple[200]:Colors.white ,
          borderRadius: BorderRadius.circular(selected=="khata" ? 5.0 : 0.0),
        ),
        child: GestureDetector(
            onTap: (){
              setState(() {
                selected="khata";
              });
            },
            child:Container(
              child:Center(child:Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.attach_money,size: 70,color: selected!="khata" ?Colors.purple[200]:Colors.white,),SizedBox(height: 5,),Text("khata",style: TextStyle(
                      color:selected=="khata" ? Colors.white :Colors.purple[200]
                  ),)
                ],
              )),

              decoration: BoxDecoration(
                  border: Border.all(color: Colors.purple[100])
              ),
            ))))
    ],
  )
)),
   Expanded(
     flex : 1,
   child:FractionallySizedBox(
     widthFactor: 5/6,
   child:Padding(
     padding: EdgeInsets.all(10.0),
   child:RaisedButton(
     color: Colors.green[200],
     onPressed: selected=="" ? null :() async {
   if(selected=="khata")
     {
       Widget child=search();
       var type=true;
       var hint="search customers";
       var Focus=FocusNode();
       List<dynamic> li=new List();
       FirebaseDatabase fire=FirebaseDatabase.instance;
       DatabaseReference data=fire.reference().child("ordersforacadsales");
       data.limitToLast(5).onChildAdded.listen((onData){

        setState(() {
          li.add(onData.snapshot.value);
          print(onData.snapshot.value);
        });
       });
       showDialog(context: context,builder:(_)=>
AnimatedSwitcher(
  duration: Duration(seconds: 3),
child:overview(false,weightData.elementAt(0).number,widget.cart)
)
    );
    }
   else{
     showDialog(context: context,builder:(_)=>
         AnimatedSwitcher(
             duration: Duration(seconds: 3),
             child:overview(null,weightData.elementAt(0).number,widget.cart)
         )
     );
   }

}
     ,
     child:Text("Charge  : "+ weightData.elementAt(0).number.toString(),style: TextStyle(
       color: Colors.white,fontSize: 20,
       fontWeight: FontWeight.bold
     ), )
   )  )))
    ]))
         ,
      );
  }
}
class Weight {
  final String itemname;
  final int number;
  Weight(this.itemname, this.number);
}
class search extends StatefulWidget {
  static var a=_searchState.cart;
  @override
  _searchState createState() => _searchState();
}
class _searchState extends State<search> {
  var type = true;
  static Map<dynamic,dynamic> cart=new Map();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return IconButton(
        key: ValueKey(1),
        icon: Icon(Icons.search, color: Colors.purple,
        ));
  }
}
class canc extends StatefulWidget {
  @override
  _cancState createState() => _cancState();
}
class _cancState extends State<canc> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        key: ValueKey(2),
        icon: Icon(Icons.cancel, color: Colors.purple,
        ));
  }
}
class overview extends StatefulWidget {
  var addcust;
  var total;
  Map<dynamic,dynamic> cart;
  overview(this.addcust  , this.total, this.cart);

  @override
  _overviewState createState() => _overviewState();
}
class _overviewState extends State<overview> {
  Widget child=search();
  var type=true;
  int total;
  final Map<dynamic,dynamic> ordering=Map();
  var sale=false;
  var hint="search customers";
  int alert=null;
  var Focus=FocusNode();
  List<Map<dynamic,dynamic>> li=new List();
  FirebaseDatabase fire;
  List<String> ids=new List();
  DatabaseReference data;
  FirebaseDatabase f=FirebaseDatabase.instance;
  DatabaseReference da;
  var addcust=false;
  var concust=TextEditingController();
  var conpho=TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    total=widget.total;
    addcust=widget.addcust;
    da=f.reference().child(token.tokenname).child(token.storename).child("credits");
    fire=FirebaseDatabase.instance;
    data=fire.reference().child(token.tokenname).child(token.storename).child("credits");
    data.onChildAdded.listen((onData){
      setState(() {
        setState(() {
          li.add(onData.snapshot.value);
          ids.add(onData.snapshot.key);
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if(sale){
    Future.delayed(Duration(milliseconds: 500),
            (){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => manager()),
                (Route<dynamic> route) => false,
          );
        }
    );}
    if(addcust==null || sale){
      return
        GestureDetector(
child:AnimatedSwitcher(
  duration: Duration(milliseconds: 500),
         switchOutCurve: Curves.bounceIn,
         switchInCurve: Curves.bounceOut,
         transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
        },
        child: sale ?  FractionallySizedBox(
            key: ValueKey(1),
            widthFactor: 1/2,
            heightFactor: 1/2,
            child:
            GestureDetector(

                onTap: (){

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => manager()),
                        (Route<dynamic> route) => false,
                  );
                },

                child:AnimatedContainer(

                  key: ValueKey(1),

                  child: Center(
                      child:AnimatedContainer(
                          width: 90,
                          height: 90,
                          duration: Duration(seconds: 4),
                          curve: Curves.bounceOut,
                          child:Icon(
                            Icons.check,color: Colors.white,size:90,
                          ))
                  ),
                  duration: Duration(seconds: 4),
                  curve: Curves.bounceOut,
                  decoration: BoxDecoration(
                      color:sale ? Colors.purple[200] : Colors.white,
                      shape:    BoxShape.circle
                  ),
                )
            ) ): AlertDialog(
          title: Text("Confirm"),content: Text(alert==null ? "Tap yes to confirm the purchase" : "Tap yes to charge " +li.elementAt(alert)["Name"]+ " "+total.toString()+" rupees"),

          actions: <Widget>[
            Builder(
                builder : (context)=>FlatButton(
                  child:Text("Yes"),
                  onPressed: (){
if(alert!=null){
da.child(ids.elementAt(alert)).child("due").once().then((onValue){
    da.child(ids.elementAt(alert)).child("due").set( onValue.value==null ? total : onValue.value+total).then((onValue){
        DateFormat format = new DateFormat("HH:mm:ss");
        DateTime time = format.parse("3:02:32 PM");
        var now = new DateTime.now();
        var formatter = new DateFormat('MMMM');
        String month = formatter.format(now);
        DateTime date = new DateTime(now.year, now.month, now.day);
        String dates=date.year.toString() + date.month.toString() + date.day.toString();
        FirebaseDatabase order=  FirebaseDatabase.instance;
        DatabaseReference daa = order.reference().child(token.tokenname).child(token.storename).child("orders");
        ordering["items"]=widget.cart;
        ordering["method"]="manual";
        print(new DateTime.now().toString());
        ordering["status"]="New Order";
        ordering["time"]=now.toString();
        ordering["date"]=dates;
        ordering["year"]=date.year.toString();
        ordering["month"]=month;
        ordering["weekday"]=date.weekday;
        ordering["day"]=date.day.toString();
        daa.push().set(ordering).then((value) {
setState(() {
  print("Did Bro");
  sale=true;
});
      }).catchError((onError){
print(onError);
        });
    }).catchError((onError){
      //show snackbar
      print(onError);
    });

}
);
}

                  },
    )
    )
            ])));
    }

    if(!addcust){
    return  Container(
        key: ValueKey(1),
        child:FractionallySizedBox(
            heightFactor: 3/4,
            child:Card(
                child:Container(
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(left:10.0,top:5.0),
                                  child:AnimatedSwitcher(
                                      duration: Duration(milliseconds: 250),
                                      transitionBuilder: (Widget child, Animation<double> animation) {
                                        return ScaleTransition(child: child, scale: animation);
                                      },
                                      child:GestureDetector(
                                        child: child,
                                        onTap:()=> setState(() {
                                          if(type) {
                                            type=false;
                                            child = canc();
                                            Focus.requestFocus();
                                            hint="Search Product";
                                          }
                                          else{
                                            type=true;
                                            child=search();
                                            Focus.unfocus();
                                            hint="";
                                          }
                                        }),
                                      )
                                  )
                              ),
                              Expanded(
                                  child: TextField(
                                    focusNode: Focus,
                                    cursorColor: Colors.purple,
                                    style: TextStyle(
                                      height: 1.5,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: hint,
                                        isDense: false,
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none
                                    ),
                                  ))]),

                        SizedBox(
                            height: 300,
                            width: 300,
                            child:ListView.builder(shrinkWrap:true,itemCount:li.length,itemBuilder:  (BuildContext context,int index,){
                              return
                                GestureDetector(
                                  onTap: (){
setState(() {
  alert=index;
  addcust=null;
});
                                  },
                                child:Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1.0,color: Colors.black12)
                                ),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(li.elementAt(index)["Name"],style: TextStyle(
                                      fontWeight: FontWeight.bold,fontSize: 20
                                    ),),
                                    Text((li.elementAt(index))["due"].toString(),style: TextStyle(
                                      fontSize: 20
                                    ),)
                                  ],
                                )
                                ) );

                            })

                        ),
                        Padding(
                          padding: EdgeInsets.all(30),
                        child:SizedBox(
                          width:200,
height: 50,
                        child:RaisedButton(
                          onPressed: (){
setState(() {
  addcust=true;
});
                          },
                          color: Colors.purple[200],
                          child: Text("Add Customer",style: TextStyle(
                            color: Colors.white
                          ),),
                        )))

                      ],
                    )
                )
            )
        )
    );}

    else{
      return
      FractionallySizedBox(
          key: ValueKey(1),
widthFactor: 3/4,
          heightFactor: 1/2,
        child:Card(
    child:Container(
         child:Column(
           mainAxisSize: MainAxisSize.min,
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: <Widget>[
             FractionallySizedBox(
               widthFactor: 3/4,
             child:TextField(controller: concust,
              decoration: InputDecoration(
                hintText: "Name Of The Customer"
              ),
             )),
             FractionallySizedBox(
               widthFactor: 3/4,
             child:TextField(
               controller: conpho,
               decoration: InputDecoration(
                   hintText: "Phone Number"
               ),
             )),

            RaisedButton(
              onPressed: (){
                print("triggered");
                da.push().set( <String,String>{
                "Name": concust.text,
                  "PhoneNumber":conpho.text
                }).then((onValue){
                  setState(() {
                    addcust=false;
                  });
                }).catchError((onError){
print(onError.toString()+"hey");
                });
              },
              color: Colors.purple[200],
              child: Text("Add Customer",style: TextStyle(
                  color: Colors.white
              ),),
            )
              ],
         )
    ) )
      );
    }
  }
}
class creditdetails {
  String name;
  String phonenumber;
  int due=0;
  String getname(){
    return name;
  }
  creditdetails(this.name,this.phonenumber);
}