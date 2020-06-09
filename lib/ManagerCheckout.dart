import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'TodaysOrders.dart';
import 'RecieveOrder.dart';
import 'TodaysReport.dart';
import 'item.dart';

void main(){
  runApp(new manager());
}
class manager extends StatefulWidget {
  @override
  _managerState createState() => _managerState();
}
class _managerState extends State<manager> {
int selected=0;
static  List<Widget> Wids=<Widget>[
  new Pos(0),RecieveOrder(),Text("Hey")
];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: "CheckOut",
        home: Scaffold(
          resizeToAvoidBottomInset: true,
          resizeToAvoidBottomPadding: true,
          appBar:AppBar(
            iconTheme: IconThemeData(color: Colors.purple),
            backgroundColor: Colors.white,
            title:  Text("CheckOut",style: TextStyle(
              color: Colors.purple
            ),),
          ),
          drawer: Drawer(
            child:Column(
              children: [
                Flexible(
                  flex:1,
                  child:Container(
                    color: Colors.purple,
                  )
                ),
                Flexible(
                  flex: 4,
                    child:Container(
                      child:Column(
                        mainAxisSize: MainAxisSize.min,
                        children:<Widget>[
                      Builder(
                      builder : (context)=>  GestureDetector(
                            onTap: (){
                              Navigator.of(context).pop();
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>TodaysOrders()));
                            },
                          child:Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey,width: 1.0)
                          ),
                          child:Text("Daily Sales",style: TextStyle(fontSize: 25),),
                        )))
                    ]
                      ),
                      color: Colors.white,
                    )
                )
              ],
            )
          ),
          body: IndexedStack(
            index: selected,
            children: <Widget>[
              Pos(0),
              RecieveOrder(),
              TodaysReport()
            ],
          )
          ,
          bottomNavigationBar: BottomNavigationBar(
            items:<BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.print),
                  title:Text("Sale")
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.markunread_mailbox),
                title:Text("Orders")
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history),
                  title:Text("Sale History")
              )
            ]
          ,currentIndex: selected,
            onTap:(int val)=> setState(() {
              selected=val;
            }),
            selectedItemColor: Colors.purple,
          ),

        )) );
  }

  void item(int value) {
    print(value);
    setState(() {
      selected=value;
    });
  }
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
class Pos extends StatefulWidget {
  Pos(int i){
    v=i;
  }
int v;
  @override
  _PosState createState() => _PosState(v);
}
class _PosState extends State<Pos> {
  var icon;
  var hint = "";
  var navigator = false;
  var child;
  var type = true;
  String select;
  Map<dynamic, dynamic> cart = new Map();
  List <item> l;
  List<Widget> category = new List();
  List<String> catstr = new List();
  List<item> resultList;
  List<item> spare=new List();
  var con = TextEditingController();
  var Focus = FocusNode();
  var conpro = TextEditingController();
  var concost = TextEditingController();
  var constock = TextEditingController();
  var concat = TextEditingController();
  FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
  DatabaseReference databaseReference;
  int k;

  _PosState(int v) {
    k = v;
  }

  int count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    icon = Icons.search;
    child = search();
    catstr.add("All Items");
    count = 0;
    l = new List();
    select = "All Items";
    resultList = new List();
    databaseReference = firebaseDatabase.reference().child("StoreName");
    databaseReference
        .child("catagory")
        .onChildAdded
        .listen((event) {
      setState(() {
        catstr.add(event.snapshot.key);
      });
    });
    databaseReference
        .child("items")
        .onChildAdded
        .listen((onData) {
      setState(() {
        print(onData.snapshot.value.toString());
        l.add(new item(onData.snapshot));
        print(l.length.toString()+"i init");
        resultList.add(new item(onData.snapshot));
        print(l.length.toString()+"i init");
      });
      spare=l;
    });
  }
    @override
    Widget build(BuildContext context) {
      category=new List();
      int p = catstr.length;
      for (int i = 0; i < p; i++) {
        category.add(
            GestureDetector(
                onTap: () {
                  setState(() {
                    select = catstr.elementAt(i);
                  l=new List();
                  if(catstr.elementAt(i)=="All Items"){
                    l=spare;
                  }
                  else{
                    int len=spare.length;
                    for(int j=0;j<len;j++){
                      if(spare.elementAt(j).catagory==catstr.elementAt(i)){
                        l.add(spare.elementAt(j));
                      }
                    }
                  }
                  });
                },

                child: Container(
                  child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(catstr.elementAt(i), style: TextStyle(
                        fontSize: 20.0,
                        color: select == catstr.elementAt(i) ? Colors.black : Colors
                            .purple[200],

                      ),)
                  ),
                  decoration: BoxDecoration(
                      color: select == catstr.elementAt(i) ? Colors.purple[200] : Colors
                          .white,
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(width: 1.0, color: Colors.grey)
                  ),
                )));
      }
      if(MediaQuery.of(context).orientation == Orientation.portrait) {
        return Container(
            child: Column(
                children: <Widget>[
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: category,
                      )),
                  Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0),
                            child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 250),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return ScaleTransition(
                                      child: child, scale: animation);
                                },
                                child: GestureDetector(
                                  key: ValueKey(child),
                                  child: child,
                                  onTap: () =>
                                      setState(() {
                                        if (type) {
                                          type = false;
                                          child = canc();
                                          Focus.requestFocus();
                                          hint = "Search Product";
                                        }
                                        else {
                                          type = true;
                                          child = search();
                                          Focus.unfocus();
                                          hint = "";
                                          con.clear();
                                          if (select == "All Items") {
                                            l = spare;
                                          }
                                          else {
                                            int len = spare.length;
                                            for (int j = 0; j < len; j++) {
                                              if (spare
                                                  .elementAt(j)
                                                  .catagory == select) {
                                                l.add(spare.elementAt(j));
                                              }
                                            }
                                          }
                                        }
                                      }),
                                )
                            )
                        ),
                        Expanded(
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  l = getresult(text);
                                });
                              },
                              controller: con,
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
                            ))
                      ])
                  ,
                  Expanded(
                      child: Stack(
                          children: <Widget>[
                            Scrollbar(
                                child: GridView.count(
                                    shrinkWrap: true,
                                    crossAxisCount: MediaQuery
                                        .of(context)
                                        .orientation == Orientation.portrait
                                        ? 3
                                        : 6,
                                    children: List.generate(
                                        l.length + 1, (index) {
                                      if (index == l.length) {
                                        return Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: GestureDetector(
                                                onTap: () =>
                                                {
                                                  showDialog(
                                                    context: context,
                                                    builder: (
                                                        BuildContext context) {
                                                      var isswitched = true;
                                                      return
                                                        StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                              return FractionallySizedBox(
                                                                  widthFactor: 3 /
                                                                      4,
                                                                  heightFactor: 3 /
                                                                      4,
                                                                  child: Card(
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .spaceEvenly,
                                                                          mainAxisSize: MainAxisSize
                                                                              .min,
                                                                          children: <
                                                                              Widget>[
                                                                            const Text(
                                                                              'Add Product',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Trebuchet MS',
                                                                                fontSize: 29,
                                                                                color: Color(
                                                                                    0xff707070),
                                                                              ),

                                                                            ),
                                                                            FractionallySizedBox(
                                                                                widthFactor: 3 /
                                                                                    4,
                                                                                child: TextField(
                                                                                  keyboardType: TextInputType
                                                                                      .text,
                                                                                  controller: conpro,
                                                                                  decoration: InputDecoration(
                                                                                      hintText: "Product Name"
                                                                                  ),
                                                                                )),
                                                                            FractionallySizedBox(
                                                                                widthFactor: 3 /
                                                                                    4,
                                                                                child: TextField(
                                                                                  keyboardType: TextInputType
                                                                                      .number,
                                                                                  controller: concost,
                                                                                  decoration: InputDecoration(
                                                                                      hintText: "Price"
                                                                                  ),
                                                                                )),
                                                                            FractionallySizedBox(
                                                                                widthFactor: 3 /
                                                                                    4,
                                                                                child: TextField(
                                                                                  keyboardType: TextInputType
                                                                                      .number,
                                                                                  controller: constock,
                                                                                  decoration: InputDecoration(
                                                                                      hintText: "Stock"
                                                                                  ),
                                                                                ))
                                                                            ,
                                                                            FractionallySizedBox(
                                                                                widthFactor: 3 /
                                                                                    4,
                                                                                child: Padding(
                                                                                    padding: EdgeInsets
                                                                                        .only(
                                                                                        bottom: MediaQuery
                                                                                            .of(
                                                                                            context)
                                                                                            .viewInsets
                                                                                            .bottom),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType
                                                                                          .text,
                                                                                      controller: concat,
                                                                                      decoration: InputDecoration(
                                                                                          hintText: "Catagory"
                                                                                      ),
                                                                                    ))),
                                                                            FractionallySizedBox(
                                                                                widthFactor: 3 /
                                                                                    4,
                                                                                child: Row(
                                                                                  children: [
                                                                                    Flexible(
                                                                                        flex: 2,
                                                                                        child: Text(
                                                                                            "Manage stock for this product")
                                                                                    ),
                                                                                    Flexible(
                                                                                        flex: 1,
                                                                                        child: Switch(
                                                                                          value: isswitched,
                                                                                          onChanged: (
                                                                                              value) {
                                                                                            setState(() {
                                                                                              isswitched =
                                                                                                  value;
                                                                                            });
                                                                                          },
                                                                                          activeColor: Colors
                                                                                              .purple,
                                                                                        ))
                                                                                  ],
                                                                                )
                                                                            ),
                                                                            GestureDetector(
                                                                                onTap: () =>
                                                                                {
                                                                                  setState(() {
                                                                                    databaseReference
                                                                                        .child(
                                                                                        "catagory")
                                                                                        .child(
                                                                                        concat
                                                                                            .text)
                                                                                        .once()
                                                                                        .then((
                                                                                        value) async {
                                                                                      await databaseReference
                                                                                          .child(
                                                                                          "catagory")
                                                                                          .child(
                                                                                          concat
                                                                                              .text)
                                                                                          .set(
                                                                                          value
                                                                                              .value !=
                                                                                              null
                                                                                              ? value
                                                                                              .value +
                                                                                              1
                                                                                              : 1);
                                                                                    })
                                                                                        .then((
                                                                                        value) {
                                                                                      databaseReference
                                                                                          .child(
                                                                                          "items")
                                                                                          .push()
                                                                                          .set(
                                                                                          <
                                                                                              String,
                                                                                              dynamic>{
                                                                                            "name": conpro
                                                                                                .text,
                                                                                            "cost": concost
                                                                                                .text,
                                                                                            "stock": constock
                                                                                                .text,
                                                                                            "catagory": concat
                                                                                                .text,
                                                                                            "managestock": isswitched
                                                                                                .toString(),
                                                                                            "available": true
                                                                                          })
                                                                                          .catchError((
                                                                                          onError) {
                                                                                        print(
                                                                                            onError
                                                                                                .toString());
                                                                                      })
                                                                                          .then((
                                                                                          value) {
                                                                                        conpro
                                                                                            .clear();
                                                                                        concost
                                                                                            .clear();
                                                                                        constock
                                                                                            .clear();
                                                                                        Navigator
                                                                                            .of(
                                                                                            context)
                                                                                            .pop(); // dismiss dialog
                                                                                      });
                                                                                    });
                                                                                  })
                                                                                },
                                                                                child: Container(
                                                                                  width: 114,
                                                                                  height: 48,
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color(
                                                                                        0xffc830be),
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                        9),
                                                                                  ),
                                                                                  child: const Center(
                                                                                      child: Text(
                                                                                        'Add ',

                                                                                        style: TextStyle(
                                                                                          fontSize: 20,

                                                                                          color: Color(
                                                                                              0xffffffff),


                                                                                        ),
                                                                                      )),
                                                                                ))
                                                                          ])
                                                                  ));
                                                            });
                                                    },
                                                  )
                                                },

                                                child: Card(
                                                  child: Container(
                                                    child: Center(
                                                      child: IconButton(
                                                        icon: Icon(Icons.add),
                                                        color: Colors.white,
                                                        iconSize: 50,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(5),
                                                        color: Colors
                                                            .purple[100]
                                                    ),
                                                  ),
                                                )
                                            ));
                                      }
                                      return
                                        GestureDetector(
                                            onLongPress: () {
                                              showDialog(
                                                context: context,
                                                builder: (
                                                    BuildContext context) {
                                                  var isswitched1 = (l
                                                      .elementAt(index)
                                                      .available) == "true"
                                                      ? true
                                                      : false;
                                                  var isswitched2 = (l
                                                      .elementAt(index)
                                                      .managestock) == "true"
                                                      ? true
                                                      : false;
                                                  var conpro = TextEditingController(
                                                      text: l
                                                          .elementAt(index)
                                                          .name);
                                                  var concost = TextEditingController(
                                                      text: l
                                                          .elementAt(index)
                                                          .cost
                                                          .toString());
                                                  var constock = TextEditingController(
                                                      text: l
                                                          .elementAt(index)
                                                          .stock
                                                          .toString());
                                                  var concat = TextEditingController(
                                                      text: l
                                                          .elementAt(index)
                                                          .catagory);
                                                  print(isswitched1);
                                                  print(isswitched2);
                                                  return
                                                    StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                          return FractionallySizedBox(
                                                              widthFactor: 5 /
                                                                  6,
                                                              heightFactor: 5 /
                                                                  6,
                                                              child: Card(
                                                                  child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .spaceEvenly,
                                                                      mainAxisSize: MainAxisSize
                                                                          .min,
                                                                      children: <
                                                                          Widget>[
                                                                        const Text(
                                                                          'Product Details',
                                                                          style: TextStyle(
                                                                            fontFamily: 'Trebuchet MS',
                                                                            fontSize: 24,
                                                                            color: Color(
                                                                                0xff707070),
                                                                          ),

                                                                        ),
                                                                        FractionallySizedBox(
                                                                            widthFactor: 3 /
                                                                                4,
                                                                            child:
                                                                            Column(
                                                                                mainAxisSize: MainAxisSize
                                                                                    .min,
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Product Name",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight
                                                                                            .bold,
                                                                                        color: Colors
                                                                                            .grey
                                                                                    ),),
                                                                                  TextField(
                                                                                    keyboardType: TextInputType
                                                                                        .text,
                                                                                    controller: conpro,
                                                                                    decoration: InputDecoration(
                                                                                        hintText: "Product Name"
                                                                                    ),
                                                                                  )
                                                                                ])),
                                                                        FractionallySizedBox(
                                                                            widthFactor: 3 /
                                                                                4,
                                                                            child:
                                                                            Column(
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,

                                                                                mainAxisSize: MainAxisSize
                                                                                    .min,
                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Price",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight
                                                                                            .bold,
                                                                                        color: Colors
                                                                                            .grey
                                                                                    ),),
                                                                                  TextField(
                                                                                    keyboardType: TextInputType
                                                                                        .number,
                                                                                    controller: concost,
                                                                                    decoration: InputDecoration(
                                                                                        hintText: "Price"
                                                                                    ),
                                                                                  )
                                                                                ])),
                                                                        FractionallySizedBox(
                                                                            widthFactor: 3 /
                                                                                4,
                                                                            child:
                                                                            Column(
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,

                                                                                mainAxisSize: MainAxisSize
                                                                                    .min,
                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Stock",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight
                                                                                            .bold,
                                                                                        color: Colors
                                                                                            .grey
                                                                                    ),),
                                                                                  TextField(
                                                                                    keyboardType: TextInputType
                                                                                        .number,
                                                                                    controller: constock,
                                                                                    decoration: InputDecoration(
                                                                                        hintText: "Stock"
                                                                                    ),
                                                                                  )
                                                                                ]))
                                                                        ,
                                                                        FractionallySizedBox(
                                                                            widthFactor: 3 /
                                                                                4,
                                                                            child:
                                                                            Column(
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,

                                                                                mainAxisSize: MainAxisSize
                                                                                    .min,
                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Catagory",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight
                                                                                            .bold,
                                                                                        color: Colors
                                                                                            .grey
                                                                                    ),),
                                                                                  Padding(
                                                                                      padding: EdgeInsets
                                                                                          .only(
                                                                                          bottom: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .viewInsets
                                                                                              .bottom),
                                                                                      child: TextField(
                                                                                        keyboardType: TextInputType
                                                                                            .text,
                                                                                        controller: concat,
                                                                                        decoration: InputDecoration(
                                                                                            hintText: "Catagory"
                                                                                        ),
                                                                                      ))
                                                                                ])
                                                                        ),
                                                                        FractionallySizedBox(
                                                                            widthFactor: 3 /
                                                                                4,
                                                                            child: Row(
                                                                              children: [
                                                                                Flexible(
                                                                                    flex: 2,
                                                                                    child: Text(
                                                                                        "Manage stock for this product")
                                                                                ),
                                                                                Flexible(
                                                                                    flex: 1,
                                                                                    child: Switch(
                                                                                      value: isswitched2,
                                                                                      onChanged: (
                                                                                          value) {
                                                                                        setState(() {
                                                                                          isswitched2 =
                                                                                              value;
                                                                                        });
                                                                                      },
                                                                                      activeColor: Colors
                                                                                          .purple,
                                                                                    ))
                                                                              ],
                                                                            )
                                                                        ),
                                                                        FractionallySizedBox(
                                                                            widthFactor: 3 /
                                                                                4,
                                                                            child: Row(

                                                                              children: [
                                                                                Flexible(
                                                                                    flex: 2,
                                                                                    child: Text(
                                                                                        "Available?")
                                                                                ),
                                                                                Flexible(
                                                                                    flex: 1,
                                                                                    child: Switch(
                                                                                      value: isswitched1,
                                                                                      onChanged: (
                                                                                          value) {
                                                                                        setState(() {
                                                                                          isswitched1 =
                                                                                              value;
                                                                                        });
                                                                                      },
                                                                                      activeColor: Colors
                                                                                          .purple,
                                                                                    ))
                                                                              ],
                                                                            )
                                                                        ),

                                                                        GestureDetector(
                                                                            onTap: () =>
                                                                            {
                                                                              setState(() {
                                                                                databaseReference
                                                                                    .child(
                                                                                    "catagory")
                                                                                    .child(
                                                                                    concat
                                                                                        .text)
                                                                                    .once()
                                                                                    .then((
                                                                                    value) async {
                                                                                  await databaseReference
                                                                                      .child(
                                                                                      "catagory")
                                                                                      .child(
                                                                                      concat
                                                                                          .text)
                                                                                      .set(
                                                                                      value
                                                                                          .value !=
                                                                                          null
                                                                                          ? value
                                                                                          .value +
                                                                                          1
                                                                                          : 1);
                                                                                })
                                                                                    .then((
                                                                                    value) {
                                                                                  databaseReference
                                                                                      .child(
                                                                                      "items")
                                                                                      .child(
                                                                                      l
                                                                                          .elementAt(
                                                                                          index)
                                                                                          .key)
                                                                                      .set(
                                                                                      <
                                                                                          String,
                                                                                          dynamic>{
                                                                                        "name": conpro
                                                                                            .text,
                                                                                        "cost": concost
                                                                                            .text,
                                                                                        "stock": constock
                                                                                            .text,
                                                                                        "catagory": concat
                                                                                            .text,
                                                                                        "managestock": isswitched2
                                                                                            .toString(),
                                                                                        "available": isswitched1
                                                                                            .toString()
                                                                                      })
                                                                                      .catchError((
                                                                                      onError) {
                                                                                    print(
                                                                                        onError
                                                                                            .toString());
                                                                                  })
                                                                                      .then((
                                                                                      value) {
                                                                                    l
                                                                                        .elementAt(
                                                                                        index)
                                                                                        .name =
                                                                                        conpro
                                                                                            .text;
                                                                                    l
                                                                                        .elementAt(
                                                                                        index)
                                                                                        .cost =
                                                                                        int
                                                                                            .parse(
                                                                                            concost
                                                                                                .text);
                                                                                    l
                                                                                        .elementAt(
                                                                                        index)
                                                                                        .stock =
                                                                                        int
                                                                                            .parse(
                                                                                            constock
                                                                                                .text);
                                                                                    l
                                                                                        .elementAt(
                                                                                        index)
                                                                                        .catagory =
                                                                                        concat
                                                                                            .text;

                                                                                    conpro
                                                                                        .clear();
                                                                                    concost
                                                                                        .clear();
                                                                                    constock
                                                                                        .clear();
                                                                                    Navigator
                                                                                        .of(
                                                                                        context)
                                                                                        .pop();
                                                                                    setState(() {

                                                                                    }); // dismiss dialog
                                                                                  });
                                                                                });
                                                                              })
                                                                            },
                                                                            child: Container(
                                                                              width: 114,
                                                                              height: 48,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(
                                                                                    0xffc830be),
                                                                                borderRadius: BorderRadius
                                                                                    .circular(
                                                                                    9),
                                                                              ),
                                                                              child: const Center(
                                                                                  child: Text(
                                                                                    'Save',
                                                                                    style: TextStyle(
                                                                                      fontSize: 20,

                                                                                      color: Color(
                                                                                          0xffffffff),


                                                                                    ),
                                                                                  )),
                                                                            ))
                                                                      ])
                                                              ));
                                                        });
                                                },
                                              );
                                            },

                                            child: Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(5)
                                                  ),
                                                  child: Card(
                                                    child:
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .circular(5),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .purple[400],
                                                                width: 2.0)
                                                        )
                                                        , child: Column(
                                                      children: <Widget>[
                                                        Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              child:
                                                              Center(
                                                                  child: Text(l
                                                                      .elementAt(
                                                                      index)
                                                                      .name,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight
                                                                            .normal),))
                                                              ,
                                                              color: Colors
                                                                  .white30,
                                                            )),
                                                        Expanded(
                                                            flex: 3,
                                                            child: Container(
                                                                child: Text(
                                                                  l
                                                                      .elementAt(
                                                                      index)
                                                                      .cost
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                  ),
                                                                )
                                                            )), Expanded(
                                                            flex: 5,
                                                            child: Container(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                      child: GestureDetector(
                                                                          onTap: () {
                                                                            setState(() {
                                                                              if (cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] >
                                                                                  0)
                                                                                cart["total"] =
                                                                                (cart["total"] ==
                                                                                    null ||
                                                                                    cart["total"] ==
                                                                                        0)
                                                                                    ? 0
                                                                                    : cart["total"] -
                                                                                    l
                                                                                        .elementAt(
                                                                                        index)
                                                                                        .cost;
                                                                              cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] =
                                                                              (cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] ==
                                                                                  null ||
                                                                                  cart[l
                                                                                      .elementAt(
                                                                                      index)
                                                                                      .name] ==
                                                                                      0)
                                                                                  ? 0
                                                                                  : cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] -
                                                                                  1;

                                                                              if (cart["total"] >
                                                                                  0) {
                                                                                navigator =
                                                                                true;
                                                                              }
                                                                              else {
                                                                                navigator =
                                                                                false;
                                                                              }
                                                                              if (cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] ==
                                                                                  0) {
                                                                                cart
                                                                                    .remove(
                                                                                    l
                                                                                        .elementAt(
                                                                                        index)
                                                                                        .name);
                                                                              }
                                                                            });
                                                                          },
                                                                          child: Center(
                                                                              child: Icon(
                                                                                  Icons
                                                                                      .remove,
                                                                                  color: Colors
                                                                                      .white
                                                                              )))),
                                                                  Visibility(
                                                                      visible: !(cart[l
                                                                          .elementAt(
                                                                          index)
                                                                          .name] ==
                                                                          0 ||
                                                                          cart[l
                                                                              .elementAt(
                                                                              index)
                                                                              .name] ==
                                                                              null),
                                                                      child: Expanded(
                                                                        child: Center(
                                                                            child: Text(
                                                                              cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] !=
                                                                                  null
                                                                                  ? cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name]
                                                                                  .toString()
                                                                                  : "0",
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .white
                                                                              ),))
                                                                        ,
                                                                      )
                                                                  ),


                                                                  Expanded(
                                                                      child: GestureDetector(
                                                                          onTap: () {
                                                                            setState(() {
                                                                              cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] =
                                                                              (cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] !=
                                                                                  null)
                                                                                  ? cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] +
                                                                                  1
                                                                                  : 1;
                                                                              cart["total"] =
                                                                              (cart["total"] !=
                                                                                  null)
                                                                                  ? cart["total"] +
                                                                                  l
                                                                                      .elementAt(
                                                                                      index)
                                                                                      .cost
                                                                                  : l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .cost;
                                                                              print(
                                                                                  cart["total"]);
                                                                              if (cart["total"] >
                                                                                  0) {
                                                                                navigator =
                                                                                true;
                                                                              }
                                                                              else {
                                                                                navigator =
                                                                                false;
                                                                              }
                                                                            });
                                                                          },
                                                                          child: Center(
                                                                              child: Icon(
                                                                                  Icons
                                                                                      .add,
                                                                                  color: Colors
                                                                                      .white
                                                                              ))))
                                                                ],
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .purple[400],
                                                                  border: Border
                                                                      .all(
                                                                      color: Colors
                                                                          .purple[400],
                                                                      width: 2.0),
                                                                  borderRadius: BorderRadius
                                                                      .circular(
                                                                      2)
                                                              ),
                                                            ))
                                                      ],
                                                    )),
                                                  ),
                                                )));
                                    }
                                    )
                                )),

                            Align(
                                alignment: Alignment.bottomCenter,
                                child:
                                GestureDetector(
                                    onTap: () {
                                      List<Weight> weightData;
                                      String selected = "";
                                      var isDisable = true;
                                      Map<dynamic, dynamic> item = Map();
                                      int a = spare.length;
                                      for (int i = 0; i < a; i++) {
                                        item[spare
                                            .elementAt(i)
                                            .name] = spare
                                            .elementAt(i)
                                            .cost;
                                      }
                                      weightData = List();
                                      cart.forEach((k, v) {
                                        print(k + (v.toString()));
                                        if (k != "total")
                                          weightData.add(Weight(k, v));
                                      });
                                      showBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) =>
                                             StatefulBuilder(
                                             builder: (BuildContext context, StateSetter setState /*You can rename this!*/) {

    return  Container(
                                        child: Center(
                                                    child: Card(
                                                      color: const Color(
                                                          0xFF0E3311).withOpacity(
                                                          0)
                                                      ,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(20.0)
                                                      ),
                                                      child:
                                                      Column(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .center,
                                                          children: <Widget>[
                                                           Expanded(
                                                             flex : 2,
                                                            child:GestureDetector(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                      context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                Visibility(
                                                                    visible: navigator,
                                                                    child:
                                                                    Padding(
                                                                        padding: EdgeInsets
                                                                            .only(
                                                                            bottom: 20),

                                                                        child:
                                                                        Container(
                                                                          child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment
                                                                                  .spaceEvenly,
                                                                              children: <
                                                                                  Widget>[
                                                                                Text(
                                                                                  "Items : " +
                                                                                      (cart
                                                                                          .length -
                                                                                          1)
                                                                                          .toString(),
                                                                                  style: TextStyle(
                                                                                      fontSize: 25.0,
                                                                                      fontWeight: FontWeight
                                                                                          .bold,
                                                                                      color: Colors
                                                                                          .white
                                                                                  ),),
                                                                                Text(
                                                                                    "Total: " +
                                                                                        cart["total"]
                                                                                            .toString(),
                                                                                    style: TextStyle(
                                                                                        fontSize: 25.0,
                                                                                        fontWeight: FontWeight
                                                                                            .bold,
                                                                                        color: Colors
                                                                                            .white
                                                                                    )),
                                                                                Icon(
                                                                                  (Icons
                                                                                      .navigate_next),
                                                                                  color: Colors
                                                                                      .purple,
                                                                                  size: 40,
                                                                                )
                                                                              ]
                                                                          ),

                                                                          decoration: BoxDecoration(
                                                                            color: Colors
                                                                                .purple[200],
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                10),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                offset: const Offset(
                                                                                    10,
                                                                                    3),
                                                                                blurRadius: 6,
                                                                                color: const Color(
                                                                                    0xff000000)
                                                                                    .withOpacity(
                                                                                    0.16),)
                                                                            ],
                                                                          ),

                                                                        )))))

                                                            ,
                                                            Expanded(
                                                                flex: 6,
                                                                child: Container(
                                                                  child: Scrollbar(
                                                                      child: ListView
                                                                          .builder(
                                                                          itemCount: weightData
                                                                              .length,
                                                                          itemBuilder: (
                                                                              BuildContext context,
                                                                              int index,) {
                                                                            return Container(
                                                                              color: Colors
                                                                                  .purple[100],
                                                                              height: 60,
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                    .start,
                                                                                children: <
                                                                                    Widget>[
                                                                                  Expanded(
                                                                                      child: Center(
                                                                                          child: Text(
                                                                                            weightData
                                                                                                .elementAt(
                                                                                                index)
                                                                                                .number
                                                                                                .toString(),
                                                                                            style: TextStyle(
                                                                                                color: Colors
                                                                                                    .white,
                                                                                                fontSize: 20,
                                                                                                fontWeight: FontWeight
                                                                                                    .bold
                                                                                            ),))
                                                                                  ),
                                                                                  Expanded(
                                                                                      child: Center(
                                                                                          child: Text(
                                                                                            "X",
                                                                                            style: TextStyle(
                                                                                                color: Colors
                                                                                                    .purple,
                                                                                                fontWeight: FontWeight
                                                                                                    .bold
                                                                                            ),))
                                                                                  ),
                                                                                  Expanded(
                                                                                      child:
                                                                                      Center(
                                                                                          child: Text(
                                                                                            weightData
                                                                                                .elementAt(
                                                                                                index)
                                                                                                .itemname,
                                                                                            style: TextStyle(
                                                                                                fontSize: 20,
                                                                                                color: Colors
                                                                                                    .white
                                                                                            ),))),
                                                                                  Expanded(
                                                                                      child:
                                                                                      Center(
                                                                                          child: Text(
                                                                                            ((item[weightData
                                                                                                .elementAt(
                                                                                                index)
                                                                                                .itemname]) *
                                                                                                weightData
                                                                                                    .elementAt(
                                                                                                    index)
                                                                                                    .number)
                                                                                                .toString(),
                                                                                            style: TextStyle(
                                                                                                fontSize: 20,
                                                                                                color: Colors
                                                                                                    .white
                                                                                            ),)))
                                                                                ],
                                                                              ),
                                                                            );
                                                                          })),


                                                                ))
                                                            ,
                                                            Expanded(
                                                              flex: 1,

                                                              child: Container(
                                                                  color: Colors
                                                                      .purple[200],
                                                                  child:
                                                                  Center(
                                                                      child: Text(
                                                                        "Select a payment method",
                                                                        style: TextStyle(
                                                                            fontWeight: FontWeight
                                                                                .bold,
                                                                            color: Colors
                                                                                .white,
                                                                        ),))),
                                                            ),
                                                        Expanded(
                                                                flex: 3,
                                                                child: Container(
                                                                    child: Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Expanded(
                                                                            child:
                                                                            AnimatedContainer(
                                                                                curve: Curves
                                                                                    .bounceOut,
                                                                                duration: Duration(
                                                                                    seconds: 1),
                                                                                decoration: BoxDecoration(
                                                                                  color: selected ==
                                                                                      "cash"
                                                                                      ? Colors
                                                                                      .purple[200]
                                                                                      : Colors
                                                                                      .white,
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      selected ==
                                                                                          "cash"
                                                                                          ? 5.0
                                                                                          : 0.0),
                                                                                ),
                                                                                child: GestureDetector(
                                                                                    onTap: () {
                                                                                     setState(() {
                                                                                        print("YOLO");
                                                                                        selected =
                                                                                        "cash";
                                                                                      });
                                                                                    },
                                                                                    child: Container(
                                                                                      child: Center(
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize
                                                                                                .min,
                                                                                            children: <
                                                                                                Widget>[
                                                                                             Expanded(
                                                                                               flex:3,
                                                                                          child:Icon(
                                                                                                Icons
                                                                                                    .attach_money,                                                                                             color: selected !=
                                                                                                    "cash"
                                                                                                    ? Colors
                                                                                                    .purple[200]
                                                                                                    : Colors
                                                                                                    .white,)),
                                                                                             Expanded(
                                                                                               flex:1,
                                                                                               child:Text(
                                                                                                "Cash",
                                                                                                style: TextStyle(
                                                                                                    color: selected ==
                                                                                                        "cash"
                                                                                                        ? Colors
                                                                                                        .white
                                                                                                        : Colors
                                                                                                        .purple[200]
                                                                                                ),))
                                                                                            ],
                                                                                          )),

                                                                                      decoration: BoxDecoration(
                                                                                          border: Border
                                                                                              .all(
                                                                                              color: Colors
                                                                                                  .purple[100])
                                                                                      ),
                                                                                    )))),
                                                                        Expanded(
                                                                            child:
                                                                            AnimatedContainer(
                                                                                curve: Curves
                                                                                    .bounceOut,
                                                                                duration: Duration(
                                                                                    seconds: 1),
                                                                                decoration: BoxDecoration(
                                                                                  color: selected ==
                                                                                      "UPI"
                                                                                      ? Colors
                                                                                      .purple[200]
                                                                                      : Colors
                                                                                      .white,
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      selected ==
                                                                                          "UPI"
                                                                                          ? 5.0
                                                                                          : 0.0),
                                                                                ),
                                                                                child: GestureDetector(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        selected =
                                                                                        "UPI";
                                                                                      });
                                                                                    },
                                                                                    child: Container(
                                                                                      child: Center(
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize
                                                                                                .min,
                                                                                            children: <
                                                                                                Widget>[

                                                                                             Expanded(
                                                                                               flex : 3,
                                                                                          child:Icon(
                                                                                                Icons
                                                                                                    .attach_money,
                                                                                                color: selected !=
                                                                                                    "UPI"
                                                                                                    ? Colors
                                                                                                    .purple[200]
                                                                                                    : Colors
                                                                                                    .white,)),

                                                                                             Expanded(
                                                                                               flex:1,
                                                                                               child:Text(
                                                                                                "UPI",
                                                                                                style: TextStyle(
                                                                                                    color: selected ==
                                                                                                        "UPI"
                                                                                                        ? Colors
                                                                                                        .white
                                                                                                        : Colors
                                                                                                        .purple[200]
                                                                                                ),))
                                                                                            ],
                                                                                          )),

                                                                                      decoration: BoxDecoration(
                                                                                          border: Border
                                                                                              .all(
                                                                                              color: Colors
                                                                                                  .purple[100])
                                                                                      ),
                                                                                    )))),
                                                                        Expanded(
                                                                            child:
                                                                            AnimatedContainer(
                                                                                curve: Curves
                                                                                    .bounceOut,
                                                                                duration: Duration(
                                                                                    seconds: 1),
                                                                                decoration: BoxDecoration(
                                                                                  color: selected ==
                                                                                      "khata"
                                                                                      ? Colors
                                                                                      .purple[200]
                                                                                      : Colors
                                                                                      .white,
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      selected ==
                                                                                          "khata"
                                                                                          ? 5.0
                                                                                          : 0.0),
                                                                                ),
                                                                                child: GestureDetector(
                                                                                    onTap: () {
                                                                                      setState(() {
                                                                                        selected =
                                                                                        "khata";
                                                                                      });
                                                                                    },
                                                                                    child: Container(
                                                                                      child: Center(
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize
                                                                                                .min,
                                                                                            children: <
                                                                                                Widget>[
                                                                                              Expanded(
                                                                                          flex:3,
                                                                                              child:Icon(
                                                                                                Icons
                                                                                                    .attach_money,
                                                                                                color: selected !=
                                                                                                    "khata"
                                                                                                    ? Colors
                                                                                                    .purple[200]
                                                                                                    : Colors
                                                                                                    .white,)),

                                                                                              Expanded(
                                                                                                flex:1,
                                                                                                child:Text(
                                                                                                "khata",
                                                                                                style: TextStyle(
                                                                                                    color: selected ==
                                                                                                        "khata"
                                                                                                        ? Colors
                                                                                                        .white
                                                                                                        : Colors
                                                                                                        .purple[200]
                                                                                                ),))
                                                                                            ],
                                                                                          )),

                                                                                      decoration: BoxDecoration(
                                                                                          border: Border
                                                                                              .all(
                                                                                              color: Colors
                                                                                                  .purple[100])
                                                                                      ),
                                                                                    ))))
                                                                      ],
                                                                    )
                                                                )),
                                                            Expanded(
                                                                flex: 2,
                                                                child: FractionallySizedBox(
                                                                    widthFactor:1,
                                                                    child: Padding(
                                                                        padding: EdgeInsets
                                                                            .all(
                                                                            10.0),
                                                                        child: RaisedButton(
                                                                            color: Colors
                                                                                .green[200],
                                                                            onPressed: selected ==
                                                                                ""
                                                                                ? null
                                                                                : () async {
                                                                              if (selected ==
                                                                                  "khata") {
                                                                                Widget child = search();
                                                                                var type = true;
                                                                                var hint = "search customers";
                                                                                var Focus = FocusNode();
                                                                                List<
                                                                                    dynamic> li = new List();
                                                                                FirebaseDatabase fire = FirebaseDatabase
                                                                                    .instance;
                                                                                DatabaseReference data = fire
                                                                                    .reference()
                                                                                    .child(
                                                                                    "ordersforacadsales");
                                                                                data
                                                                                    .limitToLast(
                                                                                    5)
                                                                                    .onChildAdded
                                                                                    .listen((
                                                                                    onData) {
                                                                                  setState(() {
                                                                                    li
                                                                                        .add(
                                                                                        onData
                                                                                            .snapshot
                                                                                            .value);
                                                                                    print(
                                                                                        onData
                                                                                            .snapshot
                                                                                            .value);
                                                                                  });
                                                                                });
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (
                                                                                        _) =>
                                                                                        AnimatedSwitcher(
                                                                                            duration: Duration(
                                                                                                seconds: 3),
                                                                                            child: overview(
                                                                                                false,
                                                                                                weightData
                                                                                                    .elementAt(
                                                                                                    0)
                                                                                                    .number,
                                                                                                cart)
                                                                                        )
                                                                                );
                                                                              }
                                                                              else {
                                                                                showDialog(
                                                                                    context: context,
                                                                                    builder: (
                                                                                        _) =>
                                                                                        AnimatedSwitcher(
                                                                                            duration: Duration(
                                                                                                seconds: 3),
                                                                                            child: overview(
                                                                                                null,
                                                                                                weightData
                                                                                                    .elementAt(
                                                                                                    0)
                                                                                                    .number,
                                                                                                cart)
                                                                                        )
                                                                                );
                                                                              }
                                                                            }
                                                                            ,
                                                                            child: Text(
                                                                              "Charge  : " +
                                                                                  weightData
                                                                                      .elementAt(
                                                                                      0)
                                                                                      .number
                                                                                      .toString(),
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .white,
                                                                                  fontWeight: FontWeight
                                                                                      .bold
                                                                              ),)
                                                                        ))))

                                                          ]),


                                                    )));},
                                      ));
                                    },
                                    child:
                                    Visibility(
                                        visible: navigator,
                                        child:
                                        Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 20),

                                            child: Container(
                                              child: Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: <Widget>[
                                                    Text("Items : " +
                                                        (cart.length - 1)
                                                            .toString(),
                                                      style: TextStyle(
                                                          fontSize: 25.0,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color: Colors.white
                                                      ),),
                                                    Text("Total: " +
                                                        cart["total"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 25.0,
                                                            fontWeight: FontWeight
                                                                .bold,
                                                            color: Colors.white
                                                        )),
                                                    Icon(
                                                      (Icons.navigate_next),
                                                      color: Colors.purple,
                                                      size: 40,
                                                    )
                                                  ]
                                              ),
                                              width: 343,
                                              height: 58,
                                              decoration: BoxDecoration(
                                                color: Colors.purple[200],
                                                borderRadius: BorderRadius
                                                    .circular(10),
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: const Offset(10, 3),
                                                    blurRadius: 6,
                                                    color: const Color(
                                                        0xff000000)
                                                        .withOpacity(0.16),)
                                                ],
                                              ),

                                            )))))


                          ])
                  )
                ])


        );
      }
      else{
        print("orinetation changed");
        List<Weight> weightData;
        String selected = "";
        var isDisable = true;
        Map<dynamic, dynamic> item = Map();
        int a = spare.length;
        for (int i = 0; i < a; i++) {
          item[spare
              .elementAt(i)
              .name] = spare
              .elementAt(i)
              .cost;
        }
        weightData = List();
        cart.forEach((k, v) {
          print(k + (v.toString()));
          if (k != "total")
            weightData.add(Weight(k, v));
        });
        return Container(

           child:Row(
            children:<Widget>[
           Flexible(
             flex: 3,
            child:Column(
                children: <Widget>[
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: category,
                      )),
                  Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 5.0),
                            child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 250),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return ScaleTransition(
                                      child: child, scale: animation);
                                },
                                child: GestureDetector(
                                  key: ValueKey(child),
                                  child: child,
                                  onTap: () =>
                                      setState(() {
                                        if (type) {
                                          type = false;
                                          child = canc();
                                          Focus.requestFocus();
                                          hint = "Search Product";
                                        }
                                        else {
                                          type = true;
                                          child = search();
                                          Focus.unfocus();
                                          hint = "";
                                          con.clear();
                                          if (select == "All Items") {
                                            l = spare;
                                          }
                                          else {
                                            int len = spare.length;
                                            for (int j = 0; j < len; j++) {
                                              if (spare
                                                  .elementAt(j)
                                                  .catagory == select) {
                                                l.add(spare.elementAt(j));
                                              }
                                            }
                                          }
                                        }
                                      }),
                                )
                            )
                        ),
                        Expanded(
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  l = getresult(text);
                                });
                              },
                              controller: con,
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
                            ))
                      ])
                  ,
                  Expanded(
                      child: Stack(
                          children: <Widget>[
                            Scrollbar(
                                child: GridView.count(
                                    shrinkWrap: true,
                                    crossAxisCount: MediaQuery
                                        .of(context)
                                        .orientation == Orientation.portrait
                                        ? 3
                                        : 6,
                                    children: List.generate(
                                        l.length + 1, (index) {
                                      if (index == l.length) {
                                        return Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: GestureDetector(
                                                onTap: () =>
                                                {
                                                  showDialog(
                                                    context: context,
                                                    builder: (
                                                        BuildContext context) {
                                                      var isswitched = true;
                                                      return
                                                        StatefulBuilder(
                                                            builder: (context,
                                                                setState) {
                                                              return FractionallySizedBox(
                                                                  widthFactor: 3 /
                                                                      4,
                                                                  heightFactor: 3 /
                                                                      4,
                                                                  child: Card(
                                                                      child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment
                                                                              .spaceEvenly,
                                                                          mainAxisSize: MainAxisSize
                                                                              .min,
                                                                          children: <
                                                                              Widget>[
                                                                            const Text(
                                                                              'Add Product',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Trebuchet MS',
                                                                                fontSize: 29,
                                                                                color: Color(
                                                                                    0xff707070),
                                                                              ),

                                                                            ),
                                                                            FractionallySizedBox(
                                                                                widthFactor: 3 /
                                                                                    4,
                                                                                child: TextField(
                                                                                  keyboardType: TextInputType
                                                                                      .text,
                                                                                  controller: conpro,
                                                                                  decoration: InputDecoration(
                                                                                      hintText: "Product Name"
                                                                                  ),
                                                                                )),
                                                                            FractionallySizedBox(
                                                                                widthFactor: 3 /
                                                                                    4,
                                                                                child: TextField(
                                                                                  keyboardType: TextInputType
                                                                                      .number,
                                                                                  controller: concost,
                                                                                  decoration: InputDecoration(
                                                                                      hintText: "Price"
                                                                                  ),
                                                                                )),
                                                                            FractionallySizedBox(
                                                                                widthFactor: 3 /
                                                                                    4,
                                                                                child: TextField(
                                                                                  keyboardType: TextInputType
                                                                                      .number,
                                                                                  controller: constock,
                                                                                  decoration: InputDecoration(
                                                                                      hintText: "Stock"
                                                                                  ),
                                                                                ))
                                                                            ,
                                                                            FractionallySizedBox(
                                                                                widthFactor: 3 /
                                                                                    4,
                                                                                child: Padding(
                                                                                    padding: EdgeInsets
                                                                                        .only(
                                                                                        bottom: MediaQuery
                                                                                            .of(
                                                                                            context)
                                                                                            .viewInsets
                                                                                            .bottom),
                                                                                    child: TextField(
                                                                                      keyboardType: TextInputType
                                                                                          .text,
                                                                                      controller: concat,
                                                                                      decoration: InputDecoration(
                                                                                          hintText: "Catagory"
                                                                                      ),
                                                                                    ))),
                                                                            FractionallySizedBox(
                                                                                widthFactor: 3 /
                                                                                    4,
                                                                                child: Row(
                                                                                  children: [
                                                                                    Flexible(
                                                                                        flex: 2,
                                                                                        child: Text(
                                                                                            "Manage stock for this product")
                                                                                    ),
                                                                                    Flexible(
                                                                                        flex: 1,
                                                                                        child: Switch(
                                                                                          value: isswitched,
                                                                                          onChanged: (
                                                                                              value) {
                                                                                            setState(() {
                                                                                              isswitched =
                                                                                                  value;
                                                                                            });
                                                                                          },
                                                                                          activeColor: Colors
                                                                                              .purple,
                                                                                        ))
                                                                                  ],
                                                                                )
                                                                            ),
                                                                            GestureDetector(
                                                                                onTap: () =>
                                                                                {
                                                                                  setState(() {
                                                                                    databaseReference
                                                                                        .child(
                                                                                        "catagory")
                                                                                        .child(
                                                                                        concat
                                                                                            .text)
                                                                                        .once()
                                                                                        .then((
                                                                                        value) async {
                                                                                      await databaseReference
                                                                                          .child(
                                                                                          "catagory")
                                                                                          .child(
                                                                                          concat
                                                                                              .text)
                                                                                          .set(
                                                                                          value
                                                                                              .value !=
                                                                                              null
                                                                                              ? value
                                                                                              .value +
                                                                                              1
                                                                                              : 1);
                                                                                    })
                                                                                        .then((
                                                                                        value) {
                                                                                      databaseReference
                                                                                          .child(
                                                                                          "items")
                                                                                          .push()
                                                                                          .set(
                                                                                          <
                                                                                              String,
                                                                                              dynamic>{
                                                                                            "name": conpro
                                                                                                .text,
                                                                                            "cost": concost
                                                                                                .text,
                                                                                            "stock": constock
                                                                                                .text,
                                                                                            "catagory": concat
                                                                                                .text,
                                                                                            "managestock": isswitched
                                                                                                .toString(),
                                                                                            "available": true
                                                                                          })
                                                                                          .catchError((
                                                                                          onError) {
                                                                                        print(
                                                                                            onError
                                                                                                .toString());
                                                                                      })
                                                                                          .then((
                                                                                          value) {
                                                                                        conpro
                                                                                            .clear();
                                                                                        concost
                                                                                            .clear();
                                                                                        constock
                                                                                            .clear();
                                                                                        Navigator
                                                                                            .of(
                                                                                            context)
                                                                                            .pop(); // dismiss dialog
                                                                                      });
                                                                                    });
                                                                                  })
                                                                                },
                                                                                child: Container(
                                                                                  width: 114,
                                                                                  height: 48,
                                                                                  decoration: BoxDecoration(
                                                                                    color: const Color(
                                                                                        0xffc830be),
                                                                                    borderRadius: BorderRadius
                                                                                        .circular(
                                                                                        9),
                                                                                  ),
                                                                                  child: const Center(
                                                                                      child: Text(
                                                                                        'Add ',

                                                                                        style: TextStyle(
                                                                                          fontSize: 20,

                                                                                          color: Color(
                                                                                              0xffffffff),


                                                                                        ),
                                                                                      )),
                                                                                ))
                                                                          ])
                                                                  ));
                                                            });
                                                    },
                                                  )
                                                },

                                                child: Card(
                                                  child: Container(
                                                    child: Center(
                                                      child: IconButton(
                                                        icon: Icon(Icons.add),
                                                        color: Colors.white,
                                                        iconSize: 50,
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius
                                                            .circular(5),
                                                        color: Colors
                                                            .purple[100]
                                                    ),
                                                  ),
                                                )
                                            ));
                                      }
                                      return
                                        GestureDetector(
                                            onLongPress: () {
                                              showDialog(
                                                context: context,
                                                builder: (
                                                    BuildContext context) {
                                                  var isswitched1 = (l
                                                      .elementAt(index)
                                                      .available) == "true"
                                                      ? true
                                                      : false;
                                                  var isswitched2 = (l
                                                      .elementAt(index)
                                                      .managestock) == "true"
                                                      ? true
                                                      : false;
                                                  var conpro = TextEditingController(
                                                      text: l
                                                          .elementAt(index)
                                                          .name);
                                                  var concost = TextEditingController(
                                                      text: l
                                                          .elementAt(index)
                                                          .cost
                                                          .toString());
                                                  var constock = TextEditingController(
                                                      text: l
                                                          .elementAt(index)
                                                          .stock
                                                          .toString());
                                                  var concat = TextEditingController(
                                                      text: l
                                                          .elementAt(index)
                                                          .catagory);
                                                  print(isswitched1);
                                                  print(isswitched2);
                                                  return
                                                    StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                          return FractionallySizedBox(
                                                              widthFactor: 5 /
                                                                  6,
                                                              heightFactor: 5 /
                                                                  6,
                                                              child: Card(
                                                                  child: Column(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .spaceEvenly,
                                                                      mainAxisSize: MainAxisSize
                                                                          .min,
                                                                      children: <
                                                                          Widget>[
                                                                        const Text(
                                                                          'Product Details',
                                                                          style: TextStyle(
                                                                            fontFamily: 'Trebuchet MS',
                                                                            fontSize: 24,
                                                                            color: Color(
                                                                                0xff707070),
                                                                          ),

                                                                        ),
                                                                        FractionallySizedBox(
                                                                            widthFactor: 3 /
                                                                                4,
                                                                            child:
                                                                            Column(
                                                                                mainAxisSize: MainAxisSize
                                                                                    .min,
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Product Name",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight
                                                                                            .bold,
                                                                                        color: Colors
                                                                                            .grey
                                                                                    ),),
                                                                                  TextField(
                                                                                    keyboardType: TextInputType
                                                                                        .text,
                                                                                    controller: conpro,
                                                                                    decoration: InputDecoration(
                                                                                        hintText: "Product Name"
                                                                                    ),
                                                                                  )
                                                                                ])),
                                                                        FractionallySizedBox(
                                                                            widthFactor: 3 /
                                                                                4,
                                                                            child:
                                                                            Column(
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,

                                                                                mainAxisSize: MainAxisSize
                                                                                    .min,
                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Price",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight
                                                                                            .bold,
                                                                                        color: Colors
                                                                                            .grey
                                                                                    ),),
                                                                                  TextField(
                                                                                    keyboardType: TextInputType
                                                                                        .number,
                                                                                    controller: concost,
                                                                                    decoration: InputDecoration(
                                                                                        hintText: "Price"
                                                                                    ),
                                                                                  )
                                                                                ])),
                                                                        FractionallySizedBox(
                                                                            widthFactor: 3 /
                                                                                4,
                                                                            child:
                                                                            Column(
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,

                                                                                mainAxisSize: MainAxisSize
                                                                                    .min,
                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Stock",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight
                                                                                            .bold,
                                                                                        color: Colors
                                                                                            .grey
                                                                                    ),),
                                                                                  TextField(
                                                                                    keyboardType: TextInputType
                                                                                        .number,
                                                                                    controller: constock,
                                                                                    decoration: InputDecoration(
                                                                                        hintText: "Stock"
                                                                                    ),
                                                                                  )
                                                                                ]))
                                                                        ,
                                                                        FractionallySizedBox(
                                                                            widthFactor: 3 /
                                                                                4,
                                                                            child:
                                                                            Column(
                                                                                crossAxisAlignment: CrossAxisAlignment
                                                                                    .start,

                                                                                mainAxisSize: MainAxisSize
                                                                                    .min,
                                                                                mainAxisAlignment: MainAxisAlignment
                                                                                    .start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Catagory",
                                                                                    style: TextStyle(
                                                                                        fontWeight: FontWeight
                                                                                            .bold,
                                                                                        color: Colors
                                                                                            .grey
                                                                                    ),),
                                                                                  Padding(
                                                                                      padding: EdgeInsets
                                                                                          .only(
                                                                                          bottom: MediaQuery
                                                                                              .of(
                                                                                              context)
                                                                                              .viewInsets
                                                                                              .bottom),
                                                                                      child: TextField(
                                                                                        keyboardType: TextInputType
                                                                                            .text,
                                                                                        controller: concat,
                                                                                        decoration: InputDecoration(
                                                                                            hintText: "Catagory"
                                                                                        ),
                                                                                      ))
                                                                                ])
                                                                        ),
                                                                        FractionallySizedBox(
                                                                            widthFactor: 3 /
                                                                                4,
                                                                            child: Row(
                                                                              children: [
                                                                                Flexible(
                                                                                    flex: 2,
                                                                                    child: Text(
                                                                                        "Manage stock for this product")
                                                                                ),
                                                                                Flexible(
                                                                                    flex: 1,
                                                                                    child: Switch(
                                                                                      value: isswitched2,
                                                                                      onChanged: (
                                                                                          value) {
                                                                                        setState(() {
                                                                                          isswitched2 =
                                                                                              value;
                                                                                        });
                                                                                      },
                                                                                      activeColor: Colors
                                                                                          .purple,
                                                                                    ))
                                                                              ],
                                                                            )
                                                                        ),
                                                                        FractionallySizedBox(
                                                                            widthFactor: 3 /
                                                                                4,
                                                                            child: Row(

                                                                              children: [
                                                                                Flexible(
                                                                                    flex: 2,
                                                                                    child: Text(
                                                                                        "Available?")
                                                                                ),
                                                                                Flexible(
                                                                                    flex: 1,
                                                                                    child: Switch(
                                                                                      value: isswitched1,
                                                                                      onChanged: (
                                                                                          value) {
                                                                                        setState(() {
                                                                                          isswitched1 =
                                                                                              value;
                                                                                        });
                                                                                      },
                                                                                      activeColor: Colors
                                                                                          .purple,
                                                                                    ))
                                                                              ],
                                                                            )
                                                                        ),

                                                                        GestureDetector(
                                                                            onTap: () =>
                                                                            {
                                                                              setState(() {
                                                                                databaseReference
                                                                                    .child(
                                                                                    "catagory")
                                                                                    .child(
                                                                                    concat
                                                                                        .text)
                                                                                    .once()
                                                                                    .then((
                                                                                    value) async {
                                                                                  await databaseReference
                                                                                      .child(
                                                                                      "catagory")
                                                                                      .child(
                                                                                      concat
                                                                                          .text)
                                                                                      .set(
                                                                                      value
                                                                                          .value !=
                                                                                          null
                                                                                          ? value
                                                                                          .value +
                                                                                          1
                                                                                          : 1);
                                                                                })
                                                                                    .then((
                                                                                    value) {
                                                                                  databaseReference
                                                                                      .child(
                                                                                      "items")
                                                                                      .child(
                                                                                      l
                                                                                          .elementAt(
                                                                                          index)
                                                                                          .key)
                                                                                      .set(
                                                                                      <
                                                                                          String,
                                                                                          dynamic>{
                                                                                        "name": conpro
                                                                                            .text,
                                                                                        "cost": concost
                                                                                            .text,
                                                                                        "stock": constock
                                                                                            .text,
                                                                                        "catagory": concat
                                                                                            .text,
                                                                                        "managestock": isswitched2
                                                                                            .toString(),
                                                                                        "available": isswitched1
                                                                                            .toString()
                                                                                      })
                                                                                      .catchError((
                                                                                      onError) {
                                                                                    print(
                                                                                        onError
                                                                                            .toString());
                                                                                  })
                                                                                      .then((
                                                                                      value) {
                                                                                    l
                                                                                        .elementAt(
                                                                                        index)
                                                                                        .name =
                                                                                        conpro
                                                                                            .text;
                                                                                    l
                                                                                        .elementAt(
                                                                                        index)
                                                                                        .cost =
                                                                                        int
                                                                                            .parse(
                                                                                            concost
                                                                                                .text);
                                                                                    l
                                                                                        .elementAt(
                                                                                        index)
                                                                                        .stock =
                                                                                        int
                                                                                            .parse(
                                                                                            constock
                                                                                                .text);
                                                                                    l
                                                                                        .elementAt(
                                                                                        index)
                                                                                        .catagory =
                                                                                        concat
                                                                                            .text;

                                                                                    conpro
                                                                                        .clear();
                                                                                    concost
                                                                                        .clear();
                                                                                    constock
                                                                                        .clear();
                                                                                    Navigator
                                                                                        .of(
                                                                                        context)
                                                                                        .pop();
                                                                                    setState(() {

                                                                                    }); // dismiss dialog
                                                                                  });
                                                                                });
                                                                              })
                                                                            },
                                                                            child: Container(
                                                                              width: 114,
                                                                              height: 48,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(
                                                                                    0xffc830be),
                                                                                borderRadius: BorderRadius
                                                                                    .circular(
                                                                                    9),
                                                                              ),
                                                                              child: const Center(
                                                                                  child: Text(
                                                                                    'Save',
                                                                                    style: TextStyle(
                                                                                      fontSize: 20,

                                                                                      color: Color(
                                                                                          0xffffffff),


                                                                                    ),
                                                                                  )),
                                                                            ))
                                                                      ])
                                                              ));
                                                        });
                                                },
                                              );
                                            },

                                            child: Padding(
                                                padding: EdgeInsets.all(2.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius
                                                          .circular(5)
                                                  ),
                                                  child: Card(
                                                    child:
                                                    Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius
                                                                .circular(5),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .purple[400],
                                                                width: 2.0)
                                                        )
                                                        , child: Column(
                                                      children: <Widget>[
                                                        Expanded(
                                                            flex: 4,
                                                            child: Container(
                                                              child:
                                                              Center(
                                                                  child: Text(l
                                                                      .elementAt(
                                                                      index)
                                                                      .name,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight
                                                                            .normal),))
                                                              ,
                                                              color: Colors
                                                                  .white30,
                                                            )),
                                                        Expanded(
                                                            flex: 3,
                                                            child: Container(
                                                                child: Text(
                                                                  l
                                                                      .elementAt(
                                                                      index)
                                                                      .cost
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey
                                                                  ),
                                                                )
                                                            )), Expanded(
                                                            flex: 5,
                                                            child: Container(
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                      child: GestureDetector(
                                                                          onTap: () {
                                                                            setState(() {
                                                                              if (cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] >
                                                                                  0)
                                                                                cart["total"] =
                                                                                (cart["total"] ==
                                                                                    null ||
                                                                                    cart["total"] ==
                                                                                        0)
                                                                                    ? 0
                                                                                    : cart["total"] -
                                                                                    l
                                                                                        .elementAt(
                                                                                        index)
                                                                                        .cost;
                                                                              cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] =
                                                                              (cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] ==
                                                                                  null ||
                                                                                  cart[l
                                                                                      .elementAt(
                                                                                      index)
                                                                                      .name] ==
                                                                                      0)
                                                                                  ? 0
                                                                                  : cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] -
                                                                                  1;

                                                                              if (cart["total"] >
                                                                                  0) {
                                                                                navigator =
                                                                                true;
                                                                              }
                                                                              else {
                                                                                navigator =
                                                                                false;
                                                                              }
                                                                              if (cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] ==
                                                                                  0) {
                                                                                cart
                                                                                    .remove(
                                                                                    l
                                                                                        .elementAt(
                                                                                        index)
                                                                                        .name);
                                                                              }
                                                                            });
                                                                          },
                                                                          child: Center(
                                                                              child: Icon(
                                                                                  Icons
                                                                                      .remove,
                                                                                  color: Colors
                                                                                      .white
                                                                              )))),
                                                                  Visibility(
                                                                      visible: !(cart[l
                                                                          .elementAt(
                                                                          index)
                                                                          .name] ==
                                                                          0 ||
                                                                          cart[l
                                                                              .elementAt(
                                                                              index)
                                                                              .name] ==
                                                                              null),
                                                                      child: Expanded(
                                                                        child: Center(
                                                                            child: Text(
                                                                              cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] !=
                                                                                  null
                                                                                  ? cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name]
                                                                                  .toString()
                                                                                  : "0",
                                                                              style: TextStyle(
                                                                                  color: Colors
                                                                                      .white
                                                                              ),))
                                                                        ,
                                                                      )
                                                                  ),
                                                                  Expanded(
                                                                      child: GestureDetector(
                                                                          onTap: () {
                                                                            setState(() {
                                                                              cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] =
                                                                              (cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] !=
                                                                                  null)
                                                                                  ? cart[l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .name] +
                                                                                  1
                                                                                  : 1;
                                                                              cart["total"] =
                                                                              (cart["total"] !=
                                                                                  null)
                                                                                  ? cart["total"] +
                                                                                  l
                                                                                      .elementAt(
                                                                                      index)
                                                                                      .cost
                                                                                  : l
                                                                                  .elementAt(
                                                                                  index)
                                                                                  .cost;
                                                                              print(
                                                                                  cart["total"]);
                                                                              if (cart["total"] >
                                                                                  0) {
                                                                                navigator =
                                                                                true;
                                                                              }
                                                                              else {
                                                                                navigator =
                                                                                false;
                                                                              }
                                                                            });
                                                                          },
                                                                          child: Center(
                                                                              child: Icon(
                                                                                  Icons
                                                                                      .add,
                                                                                  color: Colors
                                                                                      .white
                                                                              ))))
                                                                ],
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .purple[400],
                                                                  border: Border
                                                                      .all(
                                                                      color: Colors
                                                                          .purple[400],
                                                                      width: 2.0),
                                                                  borderRadius: BorderRadius
                                                                      .circular(
                                                                      2)
                                                              ),
                                                            ))
                                                      ],
                                                    )),
                                                  ),
                                                )));
                                    }
                                    )
                                ))

                          ])
                  )
                ])),
            Flexible(
              flex: 1,
              child:   StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return  Container(
                      child: Center(
                          child: Card(
                            color: const Color(
                                0xFF0E3311).withOpacity(
                                0)
                            ,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius
                                    .circular(20.0)
                            ),
                            child:
                            Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .center,
                                children: <Widget>[
                                  Expanded(
                                      flex : 3,
                                      child:GestureDetector(
                                          onTap: () {
                                            Navigator.of(
                                                context)
                                                .pop();
                                          },
                                          child:
                                          Visibility(
                                              visible: navigator,
                                                  child:
                                                  Container(
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceAround,
                                                        children: <
                                                            Widget>[
                                                          Text(
                                                            "Items : " +
                                                                (cart
                                                                    .length -
                                                                    1)
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .white
                                                            ),),
                                                          Text(
                                                              "Total: " +
                                                                  cart["total"]
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontWeight: FontWeight
                                                                      .bold,
                                                                  color: Colors
                                                                      .white
                                                              ))
                                                        ]
                                                    ),

                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .purple[200],
                                                      borderRadius: BorderRadius
                                                          .circular(
                                                          10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          offset: const Offset(
                                                              10,
                                                              3),
                                                          blurRadius: 6,
                                                          color: const Color(
                                                              0xff000000)
                                                              .withOpacity(
                                                              0.16),)
                                                      ],
                                                    ),

                                                  ))))

                                  ,
                                  Expanded(
                                      flex: 6,
                                      child: Container(
                                        child: Scrollbar(
                                            child: ListView
                                                .builder(
                                                itemCount: weightData
                                                    .length,
                                                itemBuilder: (
                                                    BuildContext context,
                                                    int index,) {
                                                  return Container(
                                                    color: Colors
                                                        .purple[100],
                                                    height: 50,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      children: <
                                                          Widget>[
                                                        Expanded(
                                                            child: Center(
                                                                child: Text(
                                                                  weightData
                                                                      .elementAt(
                                                                      index)
                                                                      .number
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight: FontWeight
                                                                          .bold
                                                                  ),))
                                                        ),
                                                        Expanded(
                                                            child: Center(
                                                                child: Text(
                                                                  "X",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .purple,
                                                                      fontWeight: FontWeight
                                                                          .bold
                                                                  ),))
                                                        ),
                                                        Expanded(
                                                            child:
                                                            Center(
                                                                child: Text(
                                                                  weightData
                                                                      .elementAt(
                                                                      index)
                                                                      .itemname,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white
                                                                  ),))),
                                                        Expanded(
                                                            child:
                                                            Center(
                                                                child: Text(
                                                                  ((item[weightData
                                                                      .elementAt(
                                                                      index)
                                                                      .itemname]) *
                                                                      weightData
                                                                          .elementAt(
                                                                          index)
                                                                          .number)
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white
                                                                  ),)))
                                                      ],
                                                    ),
                                                  );
                                                })),


                                      ))
                                  ,
                                  Expanded(
                                    flex: 1,

                                    child: Container(
                                        color: Colors
                                            .purple[200],
                                        child:
                                        Center(
                                            child: Text(
                                              "Select payment ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold,
                                                  color: Colors
                                                      .white,
                                              ),))),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                          child: Row(
                                            children: <
                                                Widget>[
                                              Expanded(
                                                  child:
                                                  AnimatedContainer(
                                                      curve: Curves
                                                          .bounceOut,
                                                      duration: Duration(
                                                          seconds: 1),
                                                      decoration: BoxDecoration(
                                                        color: selected ==
                                                            "cash"
                                                            ? Colors
                                                            .purple[200]
                                                            : Colors
                                                            .white,
                                                        borderRadius: BorderRadius
                                                            .circular(
                                                            selected ==
                                                                "cash"
                                                                ? 5.0
                                                                : 0.0),
                                                      ),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              print("YOLO");
                                                              selected =
                                                              "cash";
                                                            });
                                                          },
                                                          child: Container(
                                                            child: Center(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize
                                                                      .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                        flex:3,
                                                                        child:Icon(
                                                                          Icons
                                                                              .attach_money,                                                                                             color: selected !=
                                                                            "cash"
                                                                            ? Colors
                                                                            .purple[200]
                                                                            : Colors
                                                                            .white,)),
                                                                    Expanded(
                                                                        flex:2,
                                                                        child:Text(
                                                                          "Cash",
                                                                          style: TextStyle(
                                                                              color: selected ==
                                                                                  "cash"
                                                                                  ? Colors
                                                                                  .white
                                                                                  : Colors
                                                                                  .purple[200]
                                                                          ),))
                                                                  ],
                                                                )),

                                                            decoration: BoxDecoration(
                                                                border: Border
                                                                    .all(
                                                                    color: Colors
                                                                        .purple[100])
                                                            ),
                                                          )))),
                                              Expanded(
                                                  child:
                                                  AnimatedContainer(
                                                      curve: Curves
                                                          .bounceOut,
                                                      duration: Duration(
                                                          seconds: 1),
                                                      decoration: BoxDecoration(
                                                        color: selected ==
                                                            "UPI"
                                                            ? Colors
                                                            .purple[200]
                                                            : Colors
                                                            .white,
                                                        borderRadius: BorderRadius
                                                            .circular(
                                                            selected ==
                                                                "UPI"
                                                                ? 5.0
                                                                : 0.0),
                                                      ),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              selected =
                                                              "UPI";
                                                            });
                                                          },
                                                          child: Container(
                                                            child: Center(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize
                                                                      .min,
                                                                  children: <
                                                                      Widget>[

                                                                    Expanded(
                                                                        flex : 3,
                                                                        child:Icon(
                                                                          Icons
                                                                              .attach_money,
                                                                          color: selected !=
                                                                              "UPI"
                                                                              ? Colors
                                                                              .purple[200]
                                                                              : Colors
                                                                              .white,)),

                                                                    Expanded(
                                                                        flex:2,
                                                                        child:Text(
                                                                          "UPI",
                                                                          style: TextStyle(
                                                                              color: selected ==
                                                                                  "UPI"
                                                                                  ? Colors
                                                                                  .white
                                                                                  : Colors
                                                                                  .purple[200]
                                                                          ),))
                                                                  ],
                                                                )),

                                                            decoration: BoxDecoration(
                                                                border: Border
                                                                    .all(
                                                                    color: Colors
                                                                        .purple[100])
                                                            ),
                                                          )))),
                                              Expanded(
                                                  child:
                                                  AnimatedContainer(
                                                      curve: Curves
                                                          .bounceOut,
                                                      duration: Duration(
                                                          seconds: 1),
                                                      decoration: BoxDecoration(
                                                        color: selected ==
                                                            "khata"
                                                            ? Colors
                                                            .purple[200]
                                                            : Colors
                                                            .white,
                                                        borderRadius: BorderRadius
                                                            .circular(
                                                            selected ==
                                                                "khata"
                                                                ? 5.0
                                                                : 0.0),
                                                      ),
                                                      child: GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              selected =
                                                              "khata";
                                                            });
                                                          },
                                                          child: Container(
                                                            child: Center(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize
                                                                      .min,
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                        flex:3,
                                                                        child:Icon(
                                                                          Icons
                                                                              .attach_money,
                                                                          color: selected !=
                                                                              "khata"
                                                                              ? Colors
                                                                              .purple[200]
                                                                              : Colors
                                                                              .white,)),

                                                                    Expanded(
                                                                        flex:2,
                                                                        child:Text(
                                                                          "khata",
                                                                          style: TextStyle(
                                                                              color: selected ==
                                                                                  "khata"
                                                                                  ? Colors
                                                                                  .white
                                                                                  : Colors
                                                                                  .purple[200]
                                                                          ),))
                                                                  ],
                                                                )),

                                                            decoration: BoxDecoration(
                                                                border: Border
                                                                    .all(
                                                                    color: Colors
                                                                        .purple[100])
                                                            ),
                                                          ))))
                                            ],
                                          )
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: FractionallySizedBox(
                                          widthFactor:1,

                                              child: RaisedButton(
                                                  color: Colors
                                                      .green[200],
                                                  onPressed: selected ==
                                                      ""
                                                      ? null
                                                      : () async {
                                                    if (selected ==
                                                        "khata") {
                                                      Widget child = search();
                                                      var type = true;
                                                      var hint = "search customers";
                                                      var Focus = FocusNode();
                                                      List<dynamic> li = new List();
                                                      FirebaseDatabase fire = FirebaseDatabase
                                                          .instance;
                                                      DatabaseReference data = fire
                                                          .reference()
                                                          .child(
                                                          "ordersforacadsales");
                                                      data
                                                          .limitToLast(
                                                          5)
                                                          .onChildAdded
                                                          .listen((
                                                          onData) {
                                                        setState(() {
                                                          li
                                                              .add(
                                                              onData
                                                                  .snapshot
                                                                  .value);
                                                          print(
                                                              onData
                                                                  .snapshot
                                                                  .value);
                                                        });
                                                      });
                                                      showDialog(
                                                          context: context,
                                                          builder: (
                                                              _) =>
                                                              AnimatedSwitcher(
                                                                  duration: Duration(
                                                                      seconds: 3),
                                                                  child: overview(
                                                                      false,
                                                                      weightData
                                                                          .elementAt(
                                                                          0)
                                                                          .number,
                                                                      cart)
                                                              )
                                                      );
                                                    }
                                                    else {
                                                      showDialog(
                                                          context: context,
                                                          builder: (
                                                              _) =>
                                                              AnimatedSwitcher(
                                                                  duration: Duration(
                                                                      seconds: 3),
                                                                  child: overview(
                                                                      null,
                                                                      weightData
                                                                          .elementAt(
                                                                          0)
                                                                          .number,
                                                                      cart)
                                                              )
                                                      );
                                                    }
                                                  }
                                                  ,
                                                  child: Text(
                                                    "Charge  : " +
                                                        ( weightData.length !=0?
                                                        weightData
                                                            .elementAt(
                                                            0)
                                                            .number
                                                            .toString():"0"),
                                                    style: TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontWeight: FontWeight
                                                            .bold
                                                    ),)
                                              )))

                                ]),


                          )));},
              ),
            )









            ])


        );
      }
    }

    List<item> getresult(String text) {
      int n = l.length;
      print(n);
      List<item> res = new List();
      for (int i = 0; i < n; i++) {
        if (l
            .elementAt(i)
            .name
            .toLowerCase()
            .contains(text) &&  (l.elementAt(i).catagory==select || select=="All Items")) {
          res.add(l.elementAt(i));
          print(l
              .elementAt(i)
              .name);
        }
      }
      return res;
    }
  }
class Weight {
  final String itemname;
  final int number;
  Weight(this.itemname, this.number);
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
    da=f.reference().child("StoreName").child("credits");
    fire=FirebaseDatabase.instance;
    data=fire.reference().child("StoreName").child("credits");
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
                                    DatabaseReference daa = order.reference().child("StoreName").child("orders");
                                    ordering["items"]=widget.cart;
                                    ordering["method"]="manual";
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



