import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Weaklyrep extends StatefulWidget {
  @override
  _WeaklyrepState createState() => _WeaklyrepState();
}

class _WeaklyrepState extends State<Weaklyrep> {

  FirebaseDatabase firebaseDatabase;
  DatabaseReference databaseReference;
  final Shader linearGradient = LinearGradient(colors: <Color>[Color(0xFFF50057), Color(0xFFD500F9)]).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  TextEditingController weekStartController,weekEndController;
  FocusNode weekStartNode,weekEndNode;
  DateTime startDate,endDate;
  var BestSeller;
  var DailyTotalList;
  var DailyTotalSales;
  List<charts.Series<BestSellerItem, String>> _seriesPieData;
  List<charts.Series<DailyTotal, String>> _seriesData;
  List colors;
  int up;

  @override
  void initState() {
    super.initState();
    up=0;
    BestSeller = List<BestSellerItem>();
    DailyTotalList = List<DailyTotal>();
    DailyTotalSales = List<DailyTotal>();
    _seriesPieData = List<charts.Series<BestSellerItem, String>>();
    _seriesData = List<charts.Series<DailyTotal, String>>();
    firebaseDatabase = FirebaseDatabase.instance;
    databaseReference = firebaseDatabase.reference();
    colors = [Colors.red, Colors.blue, Colors.green, Colors.deepPurple, Colors.orange, Colors.yellow, Colors.lightBlueAccent,Colors.lightGreen,Colors.teal,Colors.purple,Colors.greenAccent,Colors.lime,Colors.indigo,Colors.orangeAccent];
    weekStartController = TextEditingController();
    weekEndController = TextEditingController();
    weekStartNode = FocusNode();
    weekEndNode = FocusNode();
    startDate = DateTime.now().subtract(Duration(days: 6));
    endDate = DateTime.now();
    weekStartController.text = DateTime.now().subtract(Duration(days: 6)).toString().split(' ')[0];
    weekEndController.text = DateTime.now().toString().split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setPreferredOrientations([ // Only vertical orientation
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height*0.08,
                child:  Align(
                    alignment: Alignment.center,
                    child: Text('Weekly Analysis',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.055,fontFamily: 'DancingScript-Regular',fontWeight: FontWeight.w900,foreground: Paint()..shader = linearGradient))
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios,color: Colors.deepPurple),
                      onPressed: (){
                        setState(() {
                          startDate = startDate.subtract(Duration(days: 7));
                          endDate = endDate.subtract(Duration(days: 7));
                          weekStartController.text = startDate.toString().split(' ')[0];
                          weekEndController.text = endDate.toString().split(' ')[0];
                        });
                      }
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.3,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 1.0)),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: weekStartController,
                          focusNode: weekStartNode,
                          decoration: InputDecoration(
                            hintText: 'YYYY-MM-DD',
                            hintStyle: TextStyle(color: Colors.grey),
                          )
                        )
                      )
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today,color: Colors.deepPurple),
                      onPressed: () async {
                        final List<DateTime> picked = await DateRangePicker.showDatePicker(
                            context: context,
                            initialFirstDate: startDate,
                            initialLastDate: endDate,
                            firstDate: DateTime(2015),
                            lastDate: DateTime.now()
                        );
                        if(picked.length == 0){
                          Fluttertoast.showToast(msg: "Nothing picked", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white, fontSize: 16.0);
                        }else if(picked.length != 2 ){
                          Fluttertoast.showToast(msg: "select two dates", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white, fontSize: 16.0);
                        }else if(picked[1].difference(picked[0]).inDays != 6){
                          Fluttertoast.showToast(msg: "pick only 7 days", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white, fontSize: 16.0);
                        }else{
                          setState(() {
                            startDate = picked[0];
                            endDate = picked[1];
                            weekStartController.text = picked[0].toString().split(' ')[0];
                            weekEndController.text = picked[1].toString().split(' ')[0];
                          });
                        }
                      }
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.3,
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(width: 1.0)),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: weekEndController,
                          focusNode: weekEndNode,
                          decoration: InputDecoration(
                            hintText: 'YYYY-MM-DD',
                            hintStyle: TextStyle(color: Colors.grey)
                          )
                        )
                      )
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios,color: endDate.add(Duration(days: 7)).difference(DateTime.now()).inDays > 0 ? Colors.grey :Colors.deepPurple),
                      onPressed: endDate.add(Duration(days: 7)).difference(DateTime.now()).inDays > 0 ?
                      null:
                      (){
                        setState(() {
                            startDate = startDate.add(Duration(days: 7));
                            endDate = endDate.add(Duration(days: 7));
                            weekStartController.text = startDate.toString().split(' ')[0];
                            weekEndController.text = endDate.toString().split(' ')[0];
                        });
                      }
                    )
                  ]
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01),
              SizedBox(
                height: MediaQuery.of(context).size.height*0.79,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      StreamBuilder(
                          stream: databaseReference.child("StoreName").child("DailySales").onValue,
                          builder: (context, AsyncSnapshot<Event> snapshot) {
                            BestSeller.clear();
                            if (snapshot.hasData) {
                              DataSnapshot dataValues = snapshot.data.snapshot;
                              Map<dynamic,dynamic> values = dataValues.value;
                              int DateStart = int.tryParse(startDate.toString().split(' ')[0].replaceAll('-', ''));
                              int DateEnd = int.tryParse(endDate.toString().split(' ')[0].replaceAll('-', ''));
                              int date;
                              int i = 0;
                              do {
                                date = int.tryParse(startDate.add(Duration(days: i)).toString().split(' ')[0].replaceAll('-', ''));
                                Map map = values["$date"]['DailyItemsSpent'];
                                if (i == 0) {
                                  map.forEach((key, value) {
                                    BestSeller.add(BestSellerItem(key, value * 1.0, colors[0]));
                                  });
                                } else {
                                  map.forEach((key, value) {
                                    for (int p = 0; p < BestSeller.length; p++) {
                                      if (key == BestSeller[p].itemName) {
                                        BestSeller[p].itemsoldcount = BestSeller[p].itemsoldcount + value * 1.0;
                                        break;
                                      } else {
                                        if (p == BestSeller.length-1) {
                                          BestSeller.add(BestSellerItem(key, value* 1.0, colors[0]));
                                          p++;
                                        }
                                      }
                                    }
                                  });
                                }
                                i++;
                              } while (date != DateEnd);
                              int m = 0;
                              for (int k = 0; k < BestSeller.length; k++) {
                                double valued = BestSeller[m].itemsoldcount;
                                int p = 0;
                                for (int i = m; i < BestSeller.length; i++) {
                                  if (BestSeller[i].itemsoldcount >= valued) {
                                    valued = BestSeller[i].itemsoldcount;
                                    p = i;
                                  }
                                }
                                  BestSeller.insert(m, BestSellerItem(BestSeller[p].itemName, BestSeller[p].itemsoldcount, colors[m]));
                                  BestSeller.removeAt(p + 1);
                                  m++;
                              }
                              _seriesPieData.clear();
                              _seriesPieData.add(
                                  charts.Series(
                                    domainFn: (BestSellerItem bestSellerItem, _) =>
                                    bestSellerItem.itemName,
                                    measureFn: (BestSellerItem bestSellerItem, _) =>
                                    bestSellerItem.itemsoldcount,
                                    colorFn: (BestSellerItem bestSellerItem, _) =>
                                        charts.ColorUtil.fromDartColor(bestSellerItem.color),
                                    id: 'BestSeller Data',
                                    data: BestSeller,
                                    labelAccessorFn: (BestSellerItem bestSellerItem,
                                        _) => '${bestSellerItem.itemsoldcount}',
                                  )
                              );
                              up++;
                            return Container(
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height*0.055,
                                      child: Text('Total items spent',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.04,fontWeight: FontWeight.bold))
                                    ),
                                    Container(
                                      key: ValueKey(up),
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height*0.4+BestSeller.length*MediaQuery.of(context).size.height*0.02,
                                      child: charts.PieChart(
                                        _seriesPieData,
                                        animate: true,
                                        animationDuration: Duration(seconds: 2),
                                        behaviors: [
                                          charts.DatumLegend(
                                            outsideJustification: charts.OutsideJustification.endDrawArea,
                                            horizontalFirst: false,
                                            desiredMaxRows: (BestSeller.length/2).round(),
                                            cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                                            entryTextStyle: charts.TextStyleSpec(color: charts.MaterialPalette.purple.shadeDefault, fontSize: 12),)
                                        ],
                                        defaultRenderer: charts.ArcRendererConfig(
                                          arcWidth: 120,
                                          arcRendererDecorators: [
                                            charts.ArcLabelDecorator(labelPosition: charts.ArcLabelPosition.inside)
                                          ]
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        }
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> DailyItemsSpent(startDate: startDate, endDate: endDate,colors: colors))
                            );
                          },
                          child: Padding(padding: EdgeInsets.only(right: 15), child: Text('View More',style: TextStyle(color: Colors.deepPurple,letterSpacing: 0.3,fontWeight: FontWeight.w700)),)
                        ),
                      ),
                      SizedBox(height: 10,),
                      StreamBuilder(
                        stream: databaseReference.child("StoreName").child("DailySales").onValue,
                        builder: (context, AsyncSnapshot<Event> snapshot) {
                          DailyTotalList.clear();
                          DailyTotalSales.clear();
                          if (snapshot.hasData) {
                            DataSnapshot dataValues = snapshot.data.snapshot;
                            Map<dynamic, dynamic> values = dataValues.value;
                            Map week = {6:'sun',5:'sat',4:'fri',3:'thu',2:'wed',1:'tue',0:'mon'};
                            int i=0;
                            int DateStart = int.tryParse(startDate.toString().split(' ')[0].replaceAll('-',''));
                            int DateEnd = int.tryParse(endDate.toString().split(' ')[0].replaceAll('-',''));
                            int date;
                            DateTime dates;
                            do{
                              dates = startDate.add(Duration(days: i));
                              date = int.tryParse(startDate.add(Duration(days: i )).toString().split(' ')[0].replaceAll('-',''));
                              DailyTotalList.add(DailyTotal(week[values['$date']["Day"]]+"\n"+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),values["$date"]["DailyTotal"]*1.0));
                              DailyTotalSales.add(DailyTotal(week[values['$date']["Day"]]+"\n"+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),values["$date"]["DailyTotalSales"]*1.0));
                              i++;
                            }while(date != DateEnd);
                            _seriesData.clear();
                            _seriesData.add(
                              charts.Series(
                                domainFn: (DailyTotal dailyTotal, _) => dailyTotal.day,
                                measureFn: (DailyTotal dailyTotal, _) => dailyTotal.total,
                                id: 'Daily Total',
                                data: DailyTotalList,
                                fillPatternFn: (_, __) => charts.FillPatternType.solid,
                                fillColorFn: (DailyTotal dailyTotal, _) =>
                                    charts.ColorUtil.fromDartColor(Color(0xff990099)),
                              ),
                            );
                            _seriesData.add(
                              charts.Series(
                                domainFn: (DailyTotal dailyTotal, _) => dailyTotal.day,
                                measureFn: (DailyTotal dailyTotal, _) => dailyTotal.total,
                                id: 'Daily Total Sales',
                                data: DailyTotalSales,
                                fillPatternFn: (_, __) => charts.FillPatternType.solid,
                                fillColorFn: (DailyTotal dailyTotal, _) =>
                                    charts.ColorUtil.fromDartColor(Color(0xff109618)),
                              ),
                            );
                            return Center(
                              child: Container(
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Text('Total Revenue & Sales',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.04,fontWeight: FontWeight.bold)),
                                      Container(
                                        key: ValueKey(up),
                                        height: MediaQuery.of(context).size.height*0.5,
                                        child: charts.BarChart(
                                          _seriesData,
                                          animate: true,
                                          barGroupingType: charts.BarGroupingType.grouped,
                                          behaviors: [charts.SeriesLegend()],
                                          animationDuration: Duration(seconds: 2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        }),
                      SizedBox(height: 10,),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> TotalRevenue(startDate: startDate, endDate: endDate))
                              );
                            },
                            child: Padding(padding: EdgeInsets.only(right: 15), child: Text('View More',style: TextStyle(color: Colors.deepPurple,letterSpacing: 0.3,fontWeight: FontWeight.w700)),)
                        ),
                      ),
                    ],
                  ),
                )
              ),
            ],
          )
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    weekStartController.dispose();
    weekEndController.dispose();
    weekStartNode.dispose();
    weekEndNode.dispose();
  }
}

class BestSellerItem{
  String itemName;
  double itemsoldcount;
  Color color;
  BestSellerItem(this.itemName,this.itemsoldcount,this.color);
}

class DailyTotal{
  String day;
  double total;
  DailyTotal(this.day,this.total);
}

class DailyItemsSpent extends StatefulWidget {

  DailyItemsSpent({Key key,this.startDate,this.endDate,this.colors}) : super(key : key);
  final DateTime startDate;
  final DateTime endDate;
  final List colors;

  @override
  _DailyItemsSpentState createState() => _DailyItemsSpentState();
}

class _DailyItemsSpentState extends State<DailyItemsSpent> {
  FirebaseDatabase firebaseDatabase;
  DatabaseReference databaseReference;
  var BestSeller;
  int up;
  var dataColumn;
  var dataRow;
  @override
  void initState() {
    super.initState();
    up=0;
    firebaseDatabase = FirebaseDatabase.instance;
    databaseReference = firebaseDatabase.reference();
    BestSeller = List<BestSellerItem>();
    dataColumn = List<DataColumn>();
    dataRow = List<DataRow>();
    dataColumn = [
      DataColumn(label: Text('Item\nName',style: TextStyle(color: Colors.deepPurple))),
      DataColumn(label: Text('Total\nSpent',style: TextStyle(color: Colors.deepPurple)),numeric: true),
      DataColumn(label: Text('Average\nSpent',style: TextStyle(color: Colors.deepPurple)),numeric: true)
    ];
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: StreamBuilder(
                stream: databaseReference.child("StoreName").child("DailySales").onValue,
                builder: (context, AsyncSnapshot<Event> snapshot) {
                  BestSeller.clear();
                  dataRow.clear();
                  if (snapshot.hasData) {
                    DataSnapshot dataValues = snapshot.data.snapshot;
                    Map<dynamic,dynamic> values = dataValues.value;
                    int DateStart = int.tryParse(widget.startDate.toString().split(' ')[0].replaceAll('-', ''));
                    int DateEnd = int.tryParse(widget.endDate.toString().split(' ')[0].replaceAll('-', ''));
                    int date;
                    int i = 0;
                    do {
                      date = int.tryParse(widget.startDate.add(Duration(days: i)).toString().split(' ')[0].replaceAll('-', ''));
                      Map map = values["$date"]['DailyItemsSpent'];
                      if (i == 0) {
                        map.forEach((key, value) {
                          BestSeller.add(BestSellerItem(key, value * 1.0, widget.colors[0]));
                        });
                      } else {
                        map.forEach((key, value) {
                          for (int p = 0; p < BestSeller.length; p++) {
                            if (key == BestSeller[p].itemName) {
                              BestSeller[p].itemsoldcount = BestSeller[p].itemsoldcount + value * 1.0;
                              break;
                            } else {
                              if (p == BestSeller.length-1) {
                                BestSeller.add(BestSellerItem(key, value* 1.0, widget.colors[0]));
                                p++;
                              }
                            }
                          }
                        });
                      }
                      i++;
                    } while (date != DateEnd);
                    int m = 0;
                    for (int k = 0; k < BestSeller.length; k++) {
                      double valued = BestSeller[m].itemsoldcount;
                      int p = 0;
                      for (int i = m; i < BestSeller.length; i++) {
                        if (BestSeller[i].itemsoldcount >= valued) {
                          valued = BestSeller[i].itemsoldcount;
                          p = i;
                        }
                      }
                      BestSeller.insert(m, BestSellerItem(BestSeller[p].itemName, BestSeller[p].itemsoldcount, widget.colors[m]));
                      BestSeller.removeAt(p + 1);
                      m++;
                    }
                    for(int i=0;i< BestSeller.length;i++){
                      dataRow.add(DataRow(cells: [
                        DataCell(Text(BestSeller[i].itemName.toString(),style: TextStyle(color: BestSeller[i].color))),
                        DataCell(Text(BestSeller[i].itemsoldcount.toString())),
                        DataCell(Text((BestSeller[i].itemsoldcount/7).toString()))
                      ]));
                    }
                    up++;
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Center(child: Text('BestSeller',style: TextStyle(fontSize: 45,color: Colors.deepPurple),textAlign: TextAlign.center,key:ValueKey(up))),
                          SizedBox(height: 2,),
                          Center(child: Text(BestSeller[0].itemName.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30))),
                          SizedBox(height: 4,),
                          Center(child: Text('Total Spent',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                          SizedBox(height: 4),
                          Center(child: Text(BestSeller[0].itemsoldcount.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(up))),
                          SizedBox(height: 4,),
                          Center(child: Text('Average Spent',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                          SizedBox(height: 4,),
                          Center(child: Text((BestSeller[0].itemsoldcount/7).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(up))),
                          SizedBox(height: 8),
                          Center(child: Text('Item Spent Table',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DataTable(
                            sortColumnIndex: 0,
                            sortAscending: true,
                            columns: dataColumn,
                            rows: dataRow
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }
            ),
          )
        )
      ),
    );
  }
}

class TotalRevenue extends StatefulWidget {
  TotalRevenue({Key key,this.startDate,this.endDate}) : super(key : key);
  final DateTime startDate;
  final DateTime endDate;
  @override
  _TotalRevenueState createState() => _TotalRevenueState();
}

class _TotalRevenueState extends State<TotalRevenue> {
  FirebaseDatabase firebaseDatabase;
  DatabaseReference databaseReference;
  var DailyTotalList;
  var DailyTotalSales;
  var dataColumn;
  var dataRow;
  int up;
  @override
  void initState() {
    super.initState();
    up=0;
    firebaseDatabase = FirebaseDatabase.instance;
    databaseReference = firebaseDatabase.reference();
    DailyTotalList = List<DailyTotal>();
    DailyTotalSales = List<DailyTotal>();
    dataColumn = List<DataColumn>();
    dataRow = List<DataRow>();
    dataColumn = [
      DataColumn(label: Text('Day',style: TextStyle(color: Colors.deepPurple))),
      DataColumn(label: Text('Total\nRevenue',style: TextStyle(color: Colors.deepPurple)),numeric: true),
      DataColumn(label: Text('Total\nSales',style: TextStyle(color: Colors.deepPurple)),numeric: true),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: StreamBuilder(
                stream: databaseReference.child("StoreName").child("DailySales").onValue,
                builder: (context, AsyncSnapshot<Event> snapshot) {
                  DailyTotalList.clear();
                  DailyTotalSales.clear();
                  dataRow.clear();
                  if (snapshot.hasData) {
                    DataSnapshot dataValues = snapshot.data.snapshot;
                    Map<dynamic, dynamic> values = dataValues.value;
                    Map week = {6:'sun',5:'sat',4:'fri',3:'thu',2:'wed',1:'tue',0:'mon'};
                    int i=0;
                    int DateStart = int.tryParse(widget.startDate.toString().split(' ')[0].replaceAll('-',''));
                    int DateEnd = int.tryParse(widget.endDate.toString().split(' ')[0].replaceAll('-',''));
                    int date;
                    DateTime dates;
                    do{
                      dates = widget.startDate.add(Duration(days: i));
                      date = int.tryParse(widget.startDate.add(Duration(days: i )).toString().split(' ')[0].replaceAll('-',''));
                      DailyTotalList.add(DailyTotal(week[values['$date']["Day"]]+"\n"+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),values["$date"]["DailyTotal"]*1.0));
                      DailyTotalSales.add(DailyTotal(week[values['$date']["Day"]]+"\n"+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),values["$date"]["DailyTotalSales"]*1.0));
                      i++;
                    }while(date != DateEnd);
                    int totalindex,salesindex;
                    double totalvalue= DailyTotalList[0].total;
                    for(int i=0;i<DailyTotalList.length;i++){
                      if(DailyTotalList[i].total >= totalvalue){
                        totalvalue = DailyTotalList[i].total;
                        totalindex = i;
                      }
                    }
                    double salevalue= DailyTotalSales[0].total;
                    for(int i=0;i<DailyTotalSales.length;i++){
                      if(DailyTotalSales[i].total >= salevalue){
                        salevalue = DailyTotalSales[i].total;
                        salesindex=i;
                      }
                    }
                    double totalRevenue= DailyTotalList[0].total;
                    double totalSales= DailyTotalSales[0].total;
                    for(int i=1;i<DailyTotalList.length;i++){
                      totalRevenue = totalRevenue + DailyTotalList[i].total;
                      totalSales = totalSales + DailyTotalSales[i].total;
                    }
                    for(int i=0;i< DailyTotalList.length;i++){
                      dataRow.add(DataRow(cells: [
                        DataCell(Text((DailyTotalSales[i].day.toString()))),
                        DataCell(Text(DailyTotalList[i].total.toString())),
                        DataCell(Text(DailyTotalSales[i].total.toString()))
                      ]));
                    }
                    up++;
                    return Column(
                      children: <Widget>[
                        Center(child: Text('Highest Revenue',style: TextStyle(fontSize: 45,color: Colors.deepPurple),textAlign: TextAlign.center,key:ValueKey(up))),
                        SizedBox(height: 4,),
                        Center(child: Text(DailyTotalList[totalindex].day.toString().replaceAll('\n',' ')+" : "+DailyTotalList[totalindex].total.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30))),
                        SizedBox(height: 4,),
                        Center(child: Text('Total Revenue',style: TextStyle(fontSize: 45,color: Colors.deepPurple),textAlign: TextAlign.center,key:ValueKey(up))),
                        SizedBox(height: 4,),
                        Center(child: Text(totalRevenue.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30))),
                        SizedBox(height: 4,),
                        Center(child: Text('Average Revenue',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                        SizedBox(height: 4),
                        Center(child: Text((totalRevenue/7).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(up))),
                        SizedBox(height: 4,),
                        Center(child: Text('Highest Sales',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                        SizedBox(height: 4,),
                        Center(child: Text(DailyTotalSales[salesindex].day.toString().replaceAll('\n',' ')+' : '+DailyTotalSales[salesindex].total.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(up))),
                        SizedBox(height: 4),
                        Center(child: Text('Total Sales',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                        SizedBox(height: 4),
                        Center(child: Text(totalSales.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(up))),
                        SizedBox(height: 4),
                        Center(child: Text('Average Sales',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                        SizedBox(height: 4),
                        Center(child: Text((totalSales/7).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(up))),
                        SizedBox(height: 4),
                        Center(child: Text('Revenue and Sales Table',textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(up))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DataTable(
                              columns: dataColumn,
                              rows: dataRow
                          ),
                        )
                      ],
                    );
                  }
                  return Center(child: CircularProgressIndicator());
                }),
          )
        ),
      ),
    );
  }
}
