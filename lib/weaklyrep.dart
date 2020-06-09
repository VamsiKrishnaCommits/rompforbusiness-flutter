import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class Weaklyrep extends StatefulWidget {
  @override
  _WeaklyrepState createState() => _WeaklyrepState();
}

class _WeaklyrepState extends State<Weaklyrep> {

  FirebaseDatabase firebaseDatabase;
  DatabaseReference databaseReference;
  var BestSeller;
  var DailyTotalList;
  var DailyTotalSales;
  DateTime dates;
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
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  FutureBuilder(
                      future: databaseReference.child("StoreName").child("DailySales").once(),
                      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          Map<dynamic, dynamic> values = snapshot.data.value;
                          int i=7;
                          int today = int.tryParse(DateTime.now().toString().split(' ')[0].replaceAll('-',''));
                          while(i != 0){
                           String date = DateTime.now().subtract(Duration(days: i + values["$today"]["Day"])).toString().split(' ')[0].replaceAll('-', '');
                            Map map = values["$date"]['DailyItemsSpent'];
                           int r = 0;
                           if(i == 7){
                             map.forEach((key, value) {
                               BestSeller.add(BestSellerItem(key, value*1.0, colors[r]));
                               r++;
                             });
                           } else {
                              map.forEach((key, value) {
                                for(int p=0; p< BestSeller.length;p++){
                                  if(key == BestSeller[p].itemName ){
                                    BestSeller[p].itemsoldcount = BestSeller[p].itemsoldcount + value*1.0;
                                    break;
                                  } else {
                                    if(p == BestSeller.length - 1){
                                      BestSeller.add(BestSellerItem(key, value*1.0, colors[r]));
                                      r++;
                                    }
                                  }
                                }
                              });
                           }
                            i--;
                          }
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
                            BestSeller.insert(m,BestSellerItem(BestSeller[p].itemName, BestSeller[p].itemsoldcount, colors[m]));
                            BestSeller.removeAt(p+1);
                            m++;
                          }
                          return Container(
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    'last week items spent',style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10.0,),
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.6,
                                    child: charts.PieChart(
                                        _seriesPieData,
                                        animate: true,
                                        animationDuration: Duration(seconds: 5),
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
                                            ])),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                  FutureBuilder(
                      future: databaseReference.child("StoreName").child("DailySales").once(),
                      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          Map<dynamic, dynamic> values = snapshot.data.value;
                          int i=7;
                          int date;
                          List week = ['sun','sat','fri','thu','wed','tue','mon'];
                          int today = int.tryParse(DateTime.now().toString().split(' ')[0].replaceAll('-',''));
                          while(i != 0){
                            dates = DateTime.now().subtract(Duration(days: i + values["$today"]["Day"]));
                            date = int.tryParse(dates.toString().split(' ')[0].replaceAll('-',''));
                            DailyTotalList.add(DailyTotal(week[i-1]+"\n"+dates.toString().split(' ')[0].substring(5).replaceAll('-', '/'),values["$date"]["DailyTotal"]*1.0));
                            DailyTotalSales.add(DailyTotal(week[i-1]+"\n"+dates.toString().split(' ')[0].substring(5).replaceAll('-', '/'),values["$date"]["DailyTotalSales"]*1.0));
                            i--;
                          }
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
      ),
    );
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