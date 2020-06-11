import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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
  Map<dynamic, dynamic> values;

  @override
  void initState() {
    super.initState();
    BestSeller = List<BestSellerItem>();
    DailyTotalList = List<DailyTotal>();
    DailyTotalSales = List<DailyTotal>();
    _seriesPieData = List<charts.Series<BestSellerItem, String>>();
    _seriesData = List<charts.Series<DailyTotal, String>>();
    firebaseDatabase = FirebaseDatabase.instance;
    databaseReference = firebaseDatabase.reference();
    colors = [Colors.red, Colors.blue, Colors.green, Colors.deepPurple, Colors.orange, Colors.yellow, Colors.lightBlueAccent];
    weekStartController = TextEditingController();
    weekEndController = TextEditingController();
    weekStartNode = FocusNode();
    weekEndNode = FocusNode();
    startDate = DateTime.now().subtract(Duration(days: 7));
    endDate = DateTime.now().subtract(Duration(days: 1));
    weekStartController.text = DateTime.now().subtract(Duration(days: 8)).toString().split(' ')[0];
    weekEndController.text = DateTime.now().subtract(Duration(days: 2)).toString().split(' ')[0];

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
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child:  Align(
                    alignment: Alignment.center,
                    child: Text('Weekly Analysis',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.055,fontFamily: 'DancingScript-Regular',fontWeight: FontWeight.w900,foreground: Paint()..shader = linearGradient))
                )
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: (){
                        setState(() {
//                          startDate = startDate.subtract(Duration(days: 1));
//                          endDate = endDate.subtract(Duration(days: 1));
//                          weekStartController.text = startDate.toString().split(' ')[0];
//                          weekEndController.text = endDate.toString().split(' ')[0];
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
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        final List<DateTime> picked = await DateRangePicker.showDatePicker(
                            context: context,
                            initialFirstDate: DateTime.now().subtract(Duration(days: 6)),
                            initialLastDate: DateTime.now(),
                            firstDate: DateTime(2015),
                            lastDate: DateTime.now()
                        );
                        if (picked != null && picked.length == 2) {
                          startDate = picked[0];
                          endDate = picked[1];
                          weekStartController.text = picked[0].toString().split(' ')[0];
                          weekEndController.text = picked[1].toString().split(' ')[0];
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
                            hintStyle: TextStyle(color: Colors.grey),
                          )
                        )
                      )
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios),
                      onPressed: (){
                        setState(() {
//                          startDate = startDate.add(Duration(days: 1));
//                          endDate = endDate.add(Duration(days: 1));
//                          weekStartController.text = startDate.toString().split(' ')[0];
//                          weekEndController.text = endDate.toString().split(' ')[0];
                        });
                      }
                    )
                  ],
                )
              ),
              Expanded(
                flex: 10,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      FutureBuilder(
                          future: databaseReference.child("StoreName").child("DailySales").once(),
                          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              values = snapshot.data.value;
                              int i=0;
                              int DateStart = int.tryParse(startDate.toString().split(' ')[0].replaceAll('-',''));
                              int DateEnd = int.tryParse(endDate.toString().split(' ')[0].replaceAll('-',''));
                              int date;
                              do{
                                date = int.tryParse(startDate.add(Duration(days: i + values["$DateStart"]["Day"])).toString().split(' ')[0].replaceAll('-',''));
                                Map map = values["$date"]['DailyItemsSpent'];
                                if(i == 0){
                                  map.forEach((key, value) {
                                    BestSeller.add(BestSellerItem(key, value*1.0,colors[0]));
                                  });
                                }else{
                                  map.forEach((key, value) {
                                    for(int p=0; p< BestSeller.length;p++){
                                      if(key == BestSeller[p].itemName ){
                                        BestSeller[p].itemsoldcount = BestSeller[p].itemsoldcount + value*1.0;
                                        break;
                                      } else {
                                        if(p == BestSeller.length - 1){
                                          BestSeller.add(BestSellerItem(key, value*1.0,colors[0]));
                                        }
                                      }
                                    }
                                  });
                                }
                                i++;
                              } while (date != DateEnd);
                              int  length = BestSeller.length;
                              int m=0;
                              int p=0;
                              for(int k = 0; k < length ; k++ ){
                                double valued = BestSeller[m].itemsoldcount;
                                for(int i=m+1; i < length; i++){
                                  if(BestSeller[i].itemsoldcount >= valued){
                                    valued = BestSeller[i].itemsoldcount;
                                    p=i;
                                  }
                                }


                                BestSeller.insert(m,BestSellerItem(BestSeller[p].itemName, BestSeller[p].itemsoldcount,colors[m]));
                                BestSeller.removeAt(p+1);
                                m++;
                              }
                              return Container(
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        'weekly items spent',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                                      SizedBox(height: 10.0,),
                                      Container(
                                        height: MediaQuery.of(context).size.height*0.6,
                                        child: charts.PieChart(
                                            _seriesPieData,
                                            animate: true,
                                            animationDuration: Duration(seconds: 2),
                                            behaviors: [
                                              charts.DatumLegend(
                                                outsideJustification: charts.OutsideJustification.endDrawArea,
                                                horizontalFirst: false,
                                                desiredMaxRows: 2,
                                                cellPadding: EdgeInsets.only(right: 4.0, bottom: 4.0),
                                                entryTextStyle: charts.TextStyleSpec(
                                                    color: charts.MaterialPalette.purple.shadeDefault,
                                                    fontSize: 11),
                                              )
                                            ],
                                            defaultRenderer: charts.ArcRendererConfig(
                                                arcWidth: 80,
                                                arcRendererDecorators: [
                                                  charts.ArcLabelDecorator(
                                                      labelPosition: charts.ArcLabelPosition.inside)
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
                      FutureBuilder(
                          future: databaseReference.child("StoreName").child("DailySales").once(),
                          builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                            if (snapshot.hasData) {
                              Map<dynamic, dynamic> values = snapshot.data.value;
                              Map week = {6:'sun',5:'sat',4:'fri',3:'thu',2:'wed',1:'tue',0:'mon'};
                              int i=0;
                              int DateStart = int.tryParse(startDate.toString().split(' ')[0].replaceAll('-',''));
                              int DateEnd = int.tryParse(endDate.toString().split(' ')[0].replaceAll('-',''));
                              int date;
                              do{
                                date = int.tryParse(startDate.add(Duration(days: i + values["$DateStart"]["Day"])).toString().split(' ')[0].replaceAll('-',''));
                                DailyTotalList.add(DailyTotal(week[values['$date']["Day"]]+"\n"+date.toString().split(' ')[0].substring(5).replaceAll('-', '/'),values["$date"]["DailyTotal"]*1.0));
                                DailyTotalSales.add(DailyTotal(week[values['$date']["Day"]]+"\n"+date.toString().split(' ')[0].substring(5).replaceAll('-', '/'),values["$date"]["DailyTotalSales"]*1.0));
                                i++;
                                print(date.toString());
                              }while(date != DateEnd);
                              return Center(
                                child: Container(
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Text('last week Daily Total & sales',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                                        Container(
                                          height: MediaQuery.of(context).size.height*0.5,
                                          child: charts.BarChart(
                                            _seriesData,
                                            animate: true,
                                            barGroupingType: charts.BarGroupingType.grouped,
                                            behaviors: [charts.SeriesLegend()],
                                            animationDuration: Duration(seconds: 5),
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