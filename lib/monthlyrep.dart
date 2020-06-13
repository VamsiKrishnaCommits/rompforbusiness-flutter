import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'package:fluttertoast/fluttertoast.dart';
import 'weaklyrep.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class MonthlyRep extends StatefulWidget {
  @override
  _MonthlyRepState createState() => _MonthlyRepState();
}

class _MonthlyRepState extends State<MonthlyRep> {
  FirebaseDatabase firebaseDatabase;
  DatabaseReference databaseReference;
  int key;
  int Year;
  int Month;
  var MonthList;
  DateTime startDate,endDate;
  var BestSeller;
  var DailyTotalList;
  var DailyTotalSales;
  List colors;
  List<charts.Series<BestSellerItem, String>> _seriesPieData;
  List<charts.Series<DailyTotal, String>> _seriesData;
  TextEditingController yearController,monthController,startDateController,endDateController;
  FocusNode yearNode,monthNode,startDateNode,endDateNode;
  final Shader linearGradient = LinearGradient(colors: <Color>[Color(0xFFF50057), Color(0xFFD500F9)]).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  @override
  void initState() {
    super.initState();
      key = 0;
      firebaseDatabase = FirebaseDatabase.instance;
      databaseReference = firebaseDatabase.reference();
    _seriesPieData = List<charts.Series<BestSellerItem, String>>();
    _seriesData = List<charts.Series<DailyTotal, String>>();
      BestSeller = List<BestSellerItem>();
      DailyTotalList = List<DailyTotal>();
      DailyTotalSales = List<DailyTotal>();
      colors = [Colors.red, Colors.blue, Colors.green, Colors.deepPurple,
        Colors.orange, Colors.yellow, Colors.lightBlueAccent, Colors.lightGreen,
        Colors.teal,Colors.purple,Colors.greenAccent,Colors.lime,
        Colors.indigo,Colors.orangeAccent,Colors.lightGreenAccent,Colors.deepOrangeAccent];
      Year = int.parse(DateTime.now().toString().split(' ')[0].split('-')[0]);
      Month = int.parse(DateTime.now().toString().split(' ')[0].split('-')[1]);
      MonthList = Map<int,String>();
      MonthList = { 0:'Jan', 1:'Feb', 2:'Mar', 3:'Apr', 4:'May', 5:'Jun', 6:'Jul', 7:'Aug', 8:'Sept', 9:'Oct', 10:'Nov', 11:'Dec' };
      yearController = TextEditingController();
      yearNode = FocusNode();
      monthController = TextEditingController();
      monthNode = FocusNode();
      startDateController = TextEditingController();
      startDateNode = FocusNode();
      endDateController = TextEditingController();
      endDateNode = FocusNode();
      yearController.text = Year.toString();
      monthController.text = MonthList[int.tryParse(DateTime.now().toString().split(' ')[0].split('-')[1])];
      startDate = DateTime(DateTime.now().year,DateTime.now().month,1);
      endDate = DateTime(DateTime.now().year,DateTime.now().month+1,1).subtract(Duration(days: 1));
      startDateController.text = DateTime(DateTime.now().year,DateTime.now().month,1).toString().split(' ')[0];
      endDateController.text = DateTime(DateTime.now().year,DateTime.now().month+1,1).subtract(Duration(days: 1)).toString().split(' ')[0];
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    return MaterialApp(
      home: Scaffold(
        body: mediaQueryData.orientation == Orientation.landscape ?  _buildHorizontalLayout() :  _buildVerticalLayout(),
      ),
    );
  }
  Widget _buildVerticalLayout(){
    return SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
                height: MediaQuery.of(context).size.height*0.08,
                child:  Align(
                    alignment: Alignment.center,
                    child: Text('Monthly Analysis',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.055,fontFamily: 'DancingScript-Regular',fontWeight: FontWeight.w900,foreground: Paint()..shader = linearGradient))
                )
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01,bottom: MediaQuery.of(context).size.height*0.01),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios,color: Colors.deepPurple),
                          onPressed: (){
                            setState(() {
                              Year = Year-1;
                              yearController.text = Year.toString();
                              startDate = DateTime(startDate.year-1,startDate.month,1);
                              endDate = DateTime(endDate.year-1,endDate.month+1,1).subtract(Duration(days: 1));
                              startDateController.text = startDate.toString().split(' ')[0];
                              endDateController.text = endDate.toString().split(' ')[0];
                            });
                          }
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width*0.2,
                          child: Container(
                              decoration: BoxDecoration(border: Border.all(width: 1.0)),
                              child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: yearController,
                                  focusNode: yearNode,
                                  decoration: InputDecoration(
                                    hintText: 'YEAR',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  )
                              )
                          )
                      ),
                      IconButton(
                          icon: Icon(Icons.arrow_forward_ios,color: Year == DateTime.now().year ? Colors.grey : Colors.deepPurple),
                          onPressed: Year == DateTime.now().year ? null :
                              (){
                            setState(() {
                            Year = Year+1;
                            yearController.text = Year.toString();
                            startDate = DateTime(startDate.year+1,startDate.month,1);
                            endDate = DateTime(endDate.year+1,endDate.month+1,1).subtract(Duration(days: 1));
                            startDateController.text = startDate.toString().split(' ')[0];
                            endDateController.text = endDate.toString().split(' ')[0];
                            });
                          }
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios,color: Colors.deepPurple),
                          onPressed: (){ setState(() {
                            DateTime date1 = DateTime(startDate.year,startDate.month - 1,1);
                            DateTime date2 = DateTime(startDate.year,startDate.month,1).subtract(Duration(days: 1));
                            startDate = date1;
                            endDate = date2;
                            startDateController.text = startDate.toString().split(' ')[0];
                            endDateController.text = endDate.toString().split(' ')[0];
                            Month = startDate.month;
                            monthController.text = MonthList[Month-1];
                            Year = startDate.year;
                            yearController.text = Year.toString();
                          }); }
                      ),
                      SizedBox(
                          width: MediaQuery.of(context).size.width*0.25,
                          child: Container(
                              decoration: BoxDecoration(border: Border.all(width: 1.0)),
                              child: TextField(
                                  textAlign: TextAlign.center,
                                  controller: monthController,
                                  focusNode: monthNode,
                                  decoration: InputDecoration(
                                    hintText: 'Month',
                                    hintStyle: TextStyle(color: Colors.grey),
                                  )
                              )
                          )
                      ),
                      IconButton(
                          icon: Icon(Icons.arrow_forward_ios,color: startDate.year == DateTime.now().year && startDate.month == DateTime.now().month ? Colors.grey :Colors.deepPurple),
                          onPressed: startDate.year == DateTime.now().year && startDate.month == DateTime.now().month ? null :
                              (){
                            setState(() {
                            DateTime date1 = DateTime(startDate.year,startDate.month +1,1);
                            DateTime date2 = DateTime(startDate.year,startDate.month + 2,1).subtract(Duration(days: 1));
                            startDate = date1;
                            endDate = date2;
                            startDateController.text = startDate.toString().split(' ')[0];
                            endDateController.text = endDate.toString().split(' ')[0];
                            Month = startDate.month;
                            monthController.text = MonthList[Month-1];
                            Year = startDate.year;
                            yearController.text = Year.toString();
                          }); }
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.01,bottom: MediaQuery.of(context).size.height*0.01),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back_ios,color: Colors.deepPurple),
                        onPressed: (){
                          setState(() {
                            DateTime date1 = DateTime(startDate.year,startDate.month - 1,1);
                            DateTime date2 = DateTime(startDate.year,startDate.month,1).subtract(Duration(days: 1));
                            startDate = date1;
                            endDate = date2;
                            startDateController.text = startDate.toString().split(' ')[0];
                            endDateController.text = endDate.toString().split(' ')[0];
                            Month = startDate.month;
                            monthController.text = MonthList[Month-1];
                            Year = startDate.year;
                            yearController.text = Year.toString();
                          });
                        }
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width*0.3,
                        child: Container(
                            decoration: BoxDecoration(border: Border.all(width: 1.0)),
                            child: TextField(
                                textAlign: TextAlign.center,
                                controller: startDateController,
                                focusNode: startDateNode,
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
                              lastDate: DateTime(startDate.year,startDate.month+1,1).subtract(Duration(days: 1))
                          );
                          if(picked.length == 0){
                            Fluttertoast.showToast(msg: "Nothing picked", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white, fontSize: 16.0);
                          }else if(picked.length != 2 ){
                            Fluttertoast.showToast(msg: "select two dates", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white, fontSize: 16.0);
                          }else if(picked[1].difference(picked[0]).inDays < 27 || picked[1].difference(picked[0]).inDays >30){
                            Fluttertoast.showToast(msg: "pick only 28 or 29 or 30 or 31 days", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white, fontSize: 16.0);
                          }else{
                            setState(() {
                              startDate = picked[0];
                              endDate = picked[1];
                              startDateController.text = picked[0].toString().split(' ')[0];
                              endDateController.text = picked[1].toString().split(' ')[0];
                              Month = startDate.month;
                              if(startDate.toString().split(' ')[0].substring(5,7) == endDate.toString().split(' ')[0].substring(5,7)){
                                monthController.text = MonthList[Month-1];
                              }else{
                                monthController.text = MonthList[Month-1]+','+MonthList[int.tryParse(endDate.toString().split(' ')[0].substring(5,7))-1];
                              }
                              Year = startDate.year;
                              if(startDate.toString().split(' ')[0].substring(0,4) == endDate.toString().split(' ')[0].substring(0,4)){
                                yearController.text = Year.toString();
                              }else{
                                yearController.text = Year.toString()+','+endDate.toString().split(' ')[0].substring(0,4);
                              }
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
                                controller: endDateController,
                                focusNode: endDateNode,
                                decoration: InputDecoration(
                                    hintText: 'YYYY-MM-DD',
                                    hintStyle: TextStyle(color: Colors.grey)
                                )
                            )
                        )
                    ),
                    IconButton(
                        icon: Icon(Icons.arrow_forward_ios,color: startDate.year == DateTime.now().year && startDate.month == DateTime.now().month ? Colors.grey : Colors.deepPurple),
                        onPressed: startDate.year == DateTime.now().year && startDate.month == DateTime.now().month ? null :
                            (){
                          setState(() {
                            DateTime date1 = DateTime(startDate.year,startDate.month +1,1);
                            DateTime date2 = DateTime(startDate.year,startDate.month + 2,1).subtract(Duration(days: 1));
                            startDate = date1;
                            endDate = date2;
                            startDateController.text = startDate.toString().split(' ')[0];
                            endDateController.text = endDate.toString().split(' ')[0];
                            Month = startDate.month;
                            monthController.text = MonthList[Month-1];
                            Year = startDate.year;
                            yearController.text = Year.toString();
                          });
                        }
                    )
                  ]
              ),
            ),
            Expanded(
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
                              int q=0;
                              do {
                                date = int.tryParse(startDate.add(Duration(days: i)).toString().split(' ')[0].replaceAll('-', ''));
                                if(values.containsKey('$date')){
                                  Map map = values["$date"]['DailyItemsSpent'];
                                  if (q == 0) {
                                    map.forEach((key, value) {
                                      BestSeller.add(BestSellerItem(key, value * 1.0, colors[0]));
                                    });
                                    q++;
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
                              key++;
                              return Column(
                                children: <Widget>[
                                  SizedBox(
                                      height: MediaQuery.of(context).size.height*0.055,
                                      child: Text('Total items spent',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.04,fontWeight: FontWeight.bold))
                                  ),
                                  Container(
                                    key: ValueKey(key),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height*0.4+BestSeller.length*MediaQuery.of(context).size.height*0.02,
                                    child: BestSeller.length == 0 ? Center(child: Text('No Activity',style: TextStyle(color: Colors.purple,fontSize: 40,fontWeight: FontWeight.bold))) :
                                    charts.PieChart(
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
                                  SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        onTap: (){
                                          BestSeller.length==0 ? null :
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> MonthlyItemsSpent(startDate: startDate, endDate: endDate,colors: colors)));
                                        },
                                        child: Padding(padding: EdgeInsets.only(right: 25), child: Text('View More',style: TextStyle(color: BestSeller.length==0 ? Colors.grey :Colors.deepPurple,letterSpacing: 0.3,fontWeight: FontWeight.w700)),)
                                    ),
                                  )
                                ],
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          }
                      ),
                      StreamBuilder(
                          stream: databaseReference.child("StoreName").child("DailySales").onValue,
                          builder: (context, AsyncSnapshot<Event> snapshot) {
                            DailyTotalList.clear();
                            DailyTotalSales.clear();
                            if (snapshot.hasData) {
                              DataSnapshot dataValues = snapshot.data.snapshot;
                              Map<dynamic, dynamic> values = dataValues.value;
                              Map week = {7:'sun',6:'sat',5:'fri',4:'thu',3:'wed',2:'tue',1:'mon'};
                              int i=0;
                              int DateStart = int.tryParse(startDate.toString().split(' ')[0].replaceAll('-',''));
                              int DateEnd = int.tryParse(endDate.toString().split(' ')[0].replaceAll('-',''));
                              int date;
                              DateTime dates;
                              int q=0;
                              int weekno=1;
                              bool newweek=true;
                              double totalamount=0;
                              double totalsales=0;
                              DateTime newWeekStart;
                              do{
                                dates = startDate.add(Duration(days: i));
                                date = int.tryParse(startDate.add(Duration(days: i )).toString().split(' ')[0].replaceAll('-',''));
                                if(values.containsKey('$date')){
                                  if(dates.weekday != 6){
                                    if(newweek){
                                      newWeekStart = dates;
                                      newweek=false;
                                    }
                                    totalamount = totalamount + values["$date"]["DailyTotal"]*1.0;
                                    totalsales = totalsales + values["$date"]["DailyTotalSales"]*1.0;
                                    if(newWeekStart == endDate){
                                      DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+values["$date"]["DailyTotal"]*1.0));
                                      DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+values["$date"]["DailyTotalSales"]*1.0));
                                    } else if(dates == endDate){
                                      DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+values["$date"]["DailyTotal"]*1.0));
                                      DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+values["$date"]["DailyTotalSales"]*1.0));
                                    }
                                  }else{
                                    DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+values["$date"]["DailyTotal"]*1.0));
                                    DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+values["$date"]["DailyTotalSales"]*1.0));
                                    newweek = true;
                                    totalamount = 0;
                                    totalsales = 0;
                                  }
                                  q++;
                                }else{
                                  if(dates.weekday != 6){
                                    if(newweek){
                                      newWeekStart = dates;
                                      newweek=false;
                                    }
                                    if(newWeekStart == endDate){
                                      DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+0.0));
                                      DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+0.0));
                                    }else if(dates == endDate){
                                      DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+0.0));
                                      DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+0.0));
                                    }
                                  }else{
                                    if(newWeekStart == null){
                                      DailyTotalList.add(DailyTotal(week[dates.weekday]+"\n"+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount));
                                      DailyTotalSales.add(DailyTotal(week[dates.weekday]+"\n"+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales));
                                      newweek = true;
                                      totalamount =0;
                                      totalsales =0;
                                    }else{
                                      DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount));
                                      DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales));
                                      newweek = true;
                                      totalamount =0;
                                      totalsales =0;
                                    }
                                  }
                                }
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
                              return Column(
                                children: <Widget>[
                                  Text('Total Revenue & Sales',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.04,fontWeight: FontWeight.bold)),
                                  Container(
                                    key: ValueKey(key),
                                    height: MediaQuery.of(context).size.height*0.5,
                                    child:q==0? Center(child: Text('No Activity',style: TextStyle(color: Colors.purple,fontSize: 40,fontWeight: FontWeight.bold))) :
                                    charts.BarChart(
                                      _seriesData,
                                      animate: true,
                                      barGroupingType: charts.BarGroupingType.grouped,
                                      behaviors: [charts.SeriesLegend()],
                                      animationDuration: Duration(seconds: 2),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> MonthlyTotalRevenue(startDate: startDate, endDate: endDate))
                                          );
                                        },
                                        child: Padding(padding: EdgeInsets.only(right: 20,bottom: 10), child: Text('View More',style: TextStyle(color: q==0? Colors.grey : Colors.deepPurple,letterSpacing: 0.3,fontWeight: FontWeight.w700)),)
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          }),
                    ],
                  ),
                )
            )
          ],
        )
    );
  }
  Widget _buildHorizontalLayout(){
    return SafeArea(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 5,bottom: 5),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('Monthly Analysis',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.12,fontFamily: 'DancingScript-Regular',fontWeight: FontWeight.w900,foreground: Paint()..shader = linearGradient))
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.arrow_back_ios,color: Colors.deepPurple),
                                onPressed: (){
                                  setState(() {
                                    Year = Year-1;
                                    yearController.text = Year.toString();
                                    startDate = DateTime(startDate.year-1,startDate.month,1);
                                    endDate = DateTime(endDate.year-1,endDate.month+1,1).subtract(Duration(days: 1));
                                    startDateController.text = startDate.toString().split(' ')[0];
                                    endDateController.text = endDate.toString().split(' ')[0];
                                  });
                                }
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width*0.2,
                                child: Container(
                                    decoration: BoxDecoration(border: Border.all(width: 1.0)),
                                    child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: yearController,
                                        focusNode: yearNode,
                                        decoration: InputDecoration(
                                          hintText: 'YEAR',
                                          hintStyle: TextStyle(color: Colors.grey),
                                        )
                                    )
                                )
                            ),
                            IconButton(
                                icon: Icon(Icons.arrow_forward_ios,color: Year == DateTime.now().year ? Colors.grey : Colors.deepPurple),
                                onPressed: (){
                                  Year == DateTime.now().year ? null :
                                  setState(() {
                                    Year = Year+1;
                                    yearController.text = Year.toString();
                                    startDate = DateTime(startDate.year+1,startDate.month,1);
                                    endDate = DateTime(endDate.year+1,endDate.month+1,1).subtract(Duration(days: 1));
                                    startDateController.text = startDate.toString().split(' ')[0];
                                    endDateController.text = endDate.toString().split(' ')[0];
                                  });
                                }
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.arrow_back_ios,color: Colors.deepPurple),
                                onPressed: (){ setState(() {
                                  DateTime date1 = DateTime(startDate.year,startDate.month - 1,1);
                                  DateTime date2 = DateTime(startDate.year,startDate.month,1).subtract(Duration(days: 1));
                                  startDate = date1;
                                  endDate = date2;
                                  startDateController.text = startDate.toString().split(' ')[0];
                                  endDateController.text = endDate.toString().split(' ')[0];
                                  Month = startDate.month;
                                  monthController.text = MonthList[Month-1];
                                  Year = startDate.year;
                                  yearController.text = Year.toString();
                                }); }
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width*0.2,
                                child: Container(
                                    decoration: BoxDecoration(border: Border.all(width: 1.0)),
                                    child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: monthController,
                                        focusNode: monthNode,
                                        decoration: InputDecoration(
                                          hintText: 'Month',
                                          hintStyle: TextStyle(color: Colors.grey),
                                        )
                                    )
                                )
                            ),
                            IconButton(
                                icon: Icon(Icons.arrow_forward_ios,color: startDate.year == DateTime.now().year && startDate.month == DateTime.now().month ? Colors.grey :Colors.deepPurple),
                                onPressed: startDate.year == DateTime.now().year && startDate.month == DateTime.now().month ? null :
                                    (){
                                  setState(() {
                                    DateTime date1 = DateTime(startDate.year,startDate.month +1,1);
                                    DateTime date2 = DateTime(startDate.year,startDate.month + 2,1).subtract(Duration(days: 1));
                                    startDate = date1;
                                    endDate = date2;
                                    startDateController.text = startDate.toString().split(' ')[0];
                                    endDateController.text = endDate.toString().split(' ')[0];
                                    Month = startDate.month;
                                    monthController.text = MonthList[Month-1];
                                    Year = startDate.year;
                                    yearController.text = Year.toString();
                                  }); }
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.arrow_back_ios,color: Colors.deepPurple),
                                onPressed: (){
                                  setState(() {
                                    DateTime date1 = DateTime(startDate.year,startDate.month - 1,1);
                                    DateTime date2 = DateTime(startDate.year,startDate.month,1).subtract(Duration(days: 1));
                                    startDate = date1;
                                    endDate = date2;
                                    startDateController.text = startDate.toString().split(' ')[0];
                                    endDateController.text = endDate.toString().split(' ')[0];
                                    Month = startDate.month;
                                    monthController.text = MonthList[Month-1];
                                    Year = startDate.year;
                                    yearController.text = Year.toString();
                                  });
                                }
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                SizedBox(
                                    width: MediaQuery.of(context).size.width*0.2,
                                    child: Container(
                                        decoration: BoxDecoration(border: Border.all(width: 1.0)),
                                        child: TextField(
                                            textAlign: TextAlign.center,
                                            controller: startDateController,
                                            focusNode: startDateNode,
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
                                          lastDate: DateTime(startDate.year,startDate.month+1,1).subtract(Duration(days: 1))
                                      );
                                      if(picked.length == 0){
                                        Fluttertoast.showToast(msg: "Nothing picked", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white, fontSize: 16.0);
                                      }else if(picked.length != 2 ){
                                        Fluttertoast.showToast(msg: "select two dates", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white, fontSize: 16.0);
                                      }else if(picked[1].difference(picked[0]).inDays < 27 || picked[1].difference(picked[0]).inDays >30){
                                        Fluttertoast.showToast(msg: "pick only 28 or 29 or 30 or 31 days", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.deepPurple, textColor: Colors.white, fontSize: 16.0);
                                      }else{
                                        setState(() {
                                          startDate = picked[0];
                                          endDate = picked[1];
                                          startDateController.text = picked[0].toString().split(' ')[0];
                                          endDateController.text = picked[1].toString().split(' ')[0];
                                          Month = startDate.month;
                                          if(startDate.toString().split(' ')[0].substring(5,7) == endDate.toString().split(' ')[0].substring(5,7)){
                                            monthController.text = MonthList[Month-1];
                                          }else{
                                            monthController.text = MonthList[Month-1]+','+MonthList[int.tryParse(endDate.toString().split(' ')[0].substring(5,7))-1];
                                          }
                                          Year = startDate.year;
                                          if(startDate.toString().split(' ')[0].substring(0,4) == endDate.toString().split(' ')[0].substring(0,4)){
                                            yearController.text = Year.toString();
                                          }else{
                                            yearController.text = Year.toString()+','+endDate.toString().split(' ')[0].substring(0,4);
                                          }
                                        });
                                      }
                                    }
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width*0.2,
                                    child: Container(
                                        decoration: BoxDecoration(border: Border.all(width: 1.0)),
                                        child: TextField(
                                            textAlign: TextAlign.center,
                                            controller: endDateController,
                                            focusNode: endDateNode,
                                            decoration: InputDecoration(
                                                hintText: 'YYYY-MM-DD',
                                                hintStyle: TextStyle(color: Colors.grey)
                                            )
                                        )
                                    )
                                ),
                              ],
                            ),
                            IconButton(
                                icon: Icon(Icons.arrow_forward_ios,color: startDate.year == DateTime.now().year && startDate.month == DateTime.now().month ? Colors.grey : Colors.deepPurple),
                                onPressed: startDate.year == DateTime.now().year && startDate.month == DateTime.now().month ? null :
                                    (){
                                  setState(() {
                                    DateTime date1 = DateTime(startDate.year,startDate.month +1,1);
                                    DateTime date2 = DateTime(startDate.year,startDate.month + 2,1).subtract(Duration(days: 1));
                                    startDate = date1;
                                    endDate = date2;
                                    startDateController.text = startDate.toString().split(' ')[0];
                                    endDateController.text = endDate.toString().split(' ')[0];
                                    Month = startDate.month;
                                    monthController.text = MonthList[Month-1];
                                    Year = startDate.year;
                                    yearController.text = Year.toString();
                                  });
                                }
                            )
                          ],
                        )
                      ],
                    )
                  )
                ],
              )
            ),
            Expanded(
              flex: 5,
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
                              int q=0;
                              do {
                                date = int.tryParse(startDate.add(Duration(days: i)).toString().split(' ')[0].replaceAll('-', ''));
                                if(values.containsKey('$date')){
                                  Map map = values["$date"]['DailyItemsSpent'];
                                  if (q == 0) {
                                    map.forEach((key, value) {
                                      BestSeller.add(BestSellerItem(key, value * 1.0, colors[0]));
                                    });
                                    q++;
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
                              key++;
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text('Total items spent',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.1,fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    key: ValueKey(key),
                                    width: MediaQuery.of(context).size.width,
                                    height: 2.5*MediaQuery.of(context).size.height*0.4+BestSeller.length*MediaQuery.of(context).size.height*0.02,
                                    child: BestSeller.length == 0 ? Center(child: Text('No Activity',style: TextStyle(color: Colors.purple,fontSize: 40,fontWeight: FontWeight.bold))) :
                                    charts.PieChart(
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
                                  SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        onTap: (){
                                          BestSeller.length==0 ? null :
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> MonthlyItemsSpent(startDate: startDate, endDate: endDate,colors: colors)));
                                        },
                                        child: Padding(padding: EdgeInsets.only(right: 20), child: Text('View More',style: TextStyle(color: BestSeller.length==0 ? Colors.grey :Colors.deepPurple,letterSpacing: 0.3,fontWeight: FontWeight.w700)),)
                                    ),
                                  )
                                ],
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          }
                      ),
                      StreamBuilder(
                          stream: databaseReference.child("StoreName").child("DailySales").onValue,
                          builder: (context, AsyncSnapshot<Event> snapshot) {
                            DailyTotalList.clear();
                            DailyTotalSales.clear();
                            if (snapshot.hasData) {
                              DataSnapshot dataValues = snapshot.data.snapshot;
                              Map<dynamic, dynamic> values = dataValues.value;
                              Map week = {7:'sun',6:'sat',5:'fri',4:'thu',3:'wed',2:'tue',1:'mon'};
                              int i=0;
                              int DateStart = int.tryParse(startDate.toString().split(' ')[0].replaceAll('-',''));
                              int DateEnd = int.tryParse(endDate.toString().split(' ')[0].replaceAll('-',''));
                              int date;
                              DateTime dates;
                              int q=0;
                              int weekno=1;
                              bool newweek=true;
                              double totalamount=0;
                              double totalsales=0;
                              DateTime newWeekStart;
                              do{
                                dates = startDate.add(Duration(days: i));
                                date = int.tryParse(startDate.add(Duration(days: i )).toString().split(' ')[0].replaceAll('-',''));
                                if(values.containsKey('$date')){
                                  if(dates.weekday != 6){
                                    if(newweek){
                                      newWeekStart = dates;
                                      newweek=false;
                                    }
                                    totalamount = totalamount + values["$date"]["DailyTotal"]*1.0;
                                    totalsales = totalsales + values["$date"]["DailyTotalSales"]*1.0;
                                    if(newWeekStart == endDate){
                                      DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+values["$date"]["DailyTotal"]*1.0));
                                      DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+values["$date"]["DailyTotalSales"]*1.0));
                                    } else if(dates == endDate){
                                      DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+values["$date"]["DailyTotal"]*1.0));
                                      DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+values["$date"]["DailyTotalSales"]*1.0));
                                    }
                                  }else{
                                    DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+values["$date"]["DailyTotal"]*1.0));
                                    DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+values["$date"]["DailyTotalSales"]*1.0));
                                    newweek = true;
                                    totalamount = 0;
                                    totalsales = 0;
                                  }
                                  q++;
                                }else{
                                  if(dates.weekday != 6){
                                    if(newweek){
                                      newWeekStart = dates;
                                      newweek=false;
                                    }
                                    if(newWeekStart == endDate){
                                      DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+0.0));
                                      DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+0.0));
                                    }else if(dates == endDate){
                                      DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+0.0));
                                      DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+0.0));
                                    }
                                  }else{
                                    if(newWeekStart == null){
                                      DailyTotalList.add(DailyTotal(week[dates.weekday]+"\n"+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount));
                                      DailyTotalSales.add(DailyTotal(week[dates.weekday]+"\n"+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales));
                                      newweek = true;
                                      totalamount =0;
                                      totalsales =0;
                                    }else{
                                      DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount));
                                      DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales));
                                      newweek = true;
                                      totalamount =0;
                                      totalsales =0;
                                    }
                                  }
                                }
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
                              return Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text('Total Revenue & Sales',style: TextStyle(fontSize: MediaQuery.of(context).size.height*0.1,fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    key: ValueKey(key),
                                    height: MediaQuery.of(context).size.height*0.85,
                                    child:q==0? Center(child: Text('No Activity',style: TextStyle(color: Colors.purple,fontSize: 40,fontWeight: FontWeight.bold))) :
                                    charts.BarChart(
                                      _seriesData,
                                      animate: true,
                                      barGroupingType: charts.BarGroupingType.grouped,
                                      behaviors: [charts.SeriesLegend()],
                                      animationDuration: Duration(seconds: 2),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> MonthlyTotalRevenue(startDate: startDate, endDate: endDate))
                                          );
                                        },
                                        child: Padding(padding: EdgeInsets.only(right: 20,bottom: 10), child: Text('View More',style: TextStyle(color: q==0? Colors.grey : Colors.deepPurple,letterSpacing: 0.3,fontWeight: FontWeight.w700)),)
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Center(child: CircularProgressIndicator());
                          }),
                    ],
                  ),
                )
            )
          ],
        )
    );
  }
  @override
  void dispose() {
    super.dispose();
    yearController.dispose();
    yearNode.dispose();
    startDateController.dispose();
    startDateNode.dispose();
    endDateController.dispose();
    endDateNode.dispose();
  }
}

class MonthlyItemsSpent extends StatefulWidget {
  MonthlyItemsSpent({Key key,this.startDate,this.endDate,this.colors}) : super(key : key);
  final DateTime startDate;
  final DateTime endDate;
  final List colors;
  @override
  _MonthlyItemsSpentState createState() => _MonthlyItemsSpentState();
}

class _MonthlyItemsSpentState extends State<MonthlyItemsSpent> {
  FirebaseDatabase firebaseDatabase;
  DatabaseReference databaseReference;
  var BestSeller;
  int key;
  var dataColumn;
  var dataRow;
  @override
  void initState() {
    super.initState();
    key=0;
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
    final mediaQueryData = MediaQuery.of(context);
    return MaterialApp(
      home: Scaffold(
        body: mediaQueryData.orientation == Orientation.landscape ?  _buildHorizontalLayout() :  _buildVerticalLayout(),
      ),
    );
  }
  Widget _buildVerticalLayout(){
    return SafeArea(
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
                  int q=0;
                  do {
                    date = int.tryParse(widget.startDate.add(Duration(days: i)).toString().split(' ')[0].replaceAll('-', ''));
                    if(values.containsKey('$date')){
                      Map map = values["$date"]['DailyItemsSpent'];
                      if (q == 0) {
                        map.forEach((key, value) {
                          BestSeller.add(BestSellerItem(key, value * 1.0, widget.colors[0]));
                        });
                        q++;
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
                          q++;
                        });
                      }
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
                      DataCell(Text((BestSeller[i].itemsoldcount/q).toString()))
                    ]));
                  }
                  key++;
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Center(child: Text('BestSeller',style: TextStyle(fontSize: 45,color: Colors.deepPurple),textAlign: TextAlign.center,key:ValueKey(key))),
                        SizedBox(height: 2,),
                        Center(child: Text(BestSeller[0].itemName.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30))),
                        SizedBox(height: 4,),
                        Center(child: Text('Total Spent',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                        SizedBox(height: 4),
                        Center(child: Text(BestSeller[0].itemsoldcount.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                        SizedBox(height: 4,),
                        Center(child: Text('Average Spent',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                        SizedBox(height: 4,),
                        Center(child: Text((BestSeller[0].itemsoldcount/q).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                        SizedBox(height: 8),
                        Center(child: Text('Item Spent Table',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                        FittedBox(
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
    );
  }
  Widget _buildHorizontalLayout(){
    return SafeArea(
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
                int q=0;
                do {
                  date = int.tryParse(widget.startDate.add(Duration(days: i)).toString().split(' ')[0].replaceAll('-', ''));
                  if(values.containsKey('$date')){
                    Map map = values["$date"]['DailyItemsSpent'];
                    if (q == 0) {
                      map.forEach((key, value) {
                        BestSeller.add(BestSellerItem(key, value * 1.0, widget.colors[0]));
                      });
                      q++;
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
                        q++;
                      });
                    }
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
                    DataCell(Text((BestSeller[i].itemsoldcount/q).toString()))
                  ]));
                }
                key++;
                return Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 2),
                          Center(child: Text('BestSeller',style: TextStyle(fontSize: 45,color: Colors.deepPurple),textAlign: TextAlign.center,key:ValueKey(key))),
                          SizedBox(height: 2),
                          Center(child: Text(BestSeller[0].itemName.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30))),
                          SizedBox(height: 4),
                          Center(child: Text('Total Spent',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                          SizedBox(height: 4),
                          Center(child: Text(BestSeller[0].itemsoldcount.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                          SizedBox(height: 4),
                          Center(child: Text('Average Spent',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                          SizedBox(height: 4),
                          Center(child: Text((BestSeller[0].itemsoldcount/q).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                          SizedBox(height: 8)
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Center(child: Text('Item Spent Table',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                            ),
                            FittedBox(
                              child: DataTable(
                                  sortColumnIndex: 0,
                                  sortAscending: true,
                                  columns: dataColumn,
                                  rows: dataRow
                              ),
                            )
                          ],
                        ),
                      )
                    )
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            }
        )
    );
  }
}

class MonthlyTotalRevenue extends StatefulWidget {
  MonthlyTotalRevenue({Key key,this.startDate,this.endDate}) : super(key : key);
  final DateTime startDate;
  final DateTime endDate;
  @override
  _MonthlyTotalRevenueState createState() => _MonthlyTotalRevenueState();
}

class _MonthlyTotalRevenueState extends State<MonthlyTotalRevenue> {
  FirebaseDatabase firebaseDatabase;
  DatabaseReference databaseReference;
  var DailyTotalList;
  var DailyTotalSales;
  var dataColumn;
  var dataRow;
  int key;
  @override
  void initState() {
    super.initState();
    key=0;
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
    final mediaQueryData = MediaQuery.of(context);
    return MaterialApp(
      home: Scaffold(
        body: mediaQueryData.orientation == Orientation.landscape ?  _buildHorizontalLayout() :  _buildVerticalLayout(),
      ),
    );
  }
  Widget _buildVerticalLayout(){
    return SafeArea(
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
                  Map week = {7:'sun',6:'sat',5:'fri',4:'thu',3:'wed',2:'tue',1:'mon'};
                  int i=0;
                  int DateStart = int.tryParse(widget.startDate.toString().split(' ')[0].replaceAll('-',''));
                  int DateEnd = int.tryParse(widget.endDate.toString().split(' ')[0].replaceAll('-',''));
                  int date;
                  DateTime dates;
                  int q=0;
                  int weekno=1;
                  bool newweek=true;
                  double totalamount=0;
                  double totalsales=0;
                  DateTime newWeekStart;
                  do{
                    dates = widget.startDate.add(Duration(days: i));
                    date = int.tryParse(widget.startDate.add(Duration(days: i )).toString().split(' ')[0].replaceAll('-',''));
                    if(values.containsKey('$date')){
                      if(dates.weekday != 6){
                        if(newweek){
                          newWeekStart = dates;
                          newweek=false;
                        }
                        totalamount = totalamount + values["$date"]["DailyTotal"]*1.0;
                        totalsales = totalsales + values["$date"]["DailyTotalSales"]*1.0;
                        if(dates == widget.endDate){
                          DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+values["$date"]["DailyTotal"]*1.0));
                          DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+values["$date"]["DailyTotalSales"]*1.0));
                        }
                      }else{
                        DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+values["$date"]["DailyTotal"]*1.0));
                        DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+values["$date"]["DailyTotalSales"]*1.0));
                        newweek = true;
                        totalamount = 0;
                        totalsales = 0;
                      }
                      q++;
                    }else{
                      if(dates.weekday != 6){
                        if(newweek){
                          newWeekStart = dates;
                          newweek=false;
                        }
                        if(dates == widget.endDate){
                          DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount));
                          DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales));
                        }
                      }else{
                        DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount));
                        DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales));
                        newweek = true;
                        totalamount =0;
                        totalsales =0;
                      }
                    }
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
                  double totalSale= DailyTotalSales[0].total;
                  for(int i=1;i<DailyTotalList.length;i++){
                    totalRevenue = totalRevenue + DailyTotalList[i].total;
                    totalSale = totalSale + DailyTotalSales[i].total;
                  }
                  for(int i=0;i< DailyTotalList.length;i++){
                    dataRow.add(DataRow(cells: [
                      DataCell(Text((DailyTotalSales[i].day.toString()))),
                      DataCell(Text(DailyTotalList[i].total.toString())),
                      DataCell(Text(DailyTotalSales[i].total.toString()))
                    ]));
                  }
                  key++;
                  return Column(
                    children: <Widget>[
                      Center(child: Text('Highest Revenue',style: TextStyle(fontSize: 45,color: Colors.deepPurple),textAlign: TextAlign.center,key:ValueKey(key))),
                      SizedBox(height: 4,),
                      Center(child: Text(DailyTotalList[totalindex].day.toString().replaceFirst('\n', '',12)+" : "+DailyTotalList[totalindex].total.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30))),
                      SizedBox(height: 4,),
                      Center(child: Text('Total Revenue',style: TextStyle(fontSize: 45,color: Colors.deepPurple),textAlign: TextAlign.center,key:ValueKey(key))),
                      SizedBox(height: 4,),
                      Center(child: Text(totalRevenue.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30))),
                      SizedBox(height: 4,),
                      Center(child: Text('Average Revenue',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                      SizedBox(height: 4),
                      Center(child: Text((totalRevenue/q).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                      SizedBox(height: 4,),
                      Center(child: Text('Highest Sales',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                      SizedBox(height: 4,),
                      Center(child: Text(DailyTotalSales[salesindex].day.toString().replaceAll('\n',' ')+' : '+DailyTotalSales[salesindex].total.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                      SizedBox(height: 4),
                      Center(child: Text('Total Sales',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                      SizedBox(height: 4),
                      Center(child: Text(totalSale.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                      SizedBox(height: 4),
                      Center(child: Text('Average Sales',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                      SizedBox(height: 4),
                      Center(child: Text((totalSale/q).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                      SizedBox(height: 4),
                      Center(child: Text('Revenue and Sales Table',textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                      FittedBox(
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
    );
  }
  Widget _buildHorizontalLayout(){
    return SafeArea(
        child: StreamBuilder(
            stream: databaseReference.child("StoreName").child("DailySales").onValue,
            builder: (context, AsyncSnapshot<Event> snapshot) {
              DailyTotalList.clear();
              DailyTotalSales.clear();
              dataRow.clear();
              if (snapshot.hasData) {
                DataSnapshot dataValues = snapshot.data.snapshot;
                Map<dynamic, dynamic> values = dataValues.value;
                Map week = {7:'sun',6:'sat',5:'fri',4:'thu',3:'wed',2:'tue',1:'mon'};
                int i=0;
                int DateStart = int.tryParse(widget.startDate.toString().split(' ')[0].replaceAll('-',''));
                int DateEnd = int.tryParse(widget.endDate.toString().split(' ')[0].replaceAll('-',''));
                int date;
                DateTime dates;
                int q=0;
                int weekno=1;
                bool newweek=true;
                double totalamount=0;
                double totalsales=0;
                DateTime newWeekStart;
                do{
                  dates = widget.startDate.add(Duration(days: i));
                  date = int.tryParse(widget.startDate.add(Duration(days: i )).toString().split(' ')[0].replaceAll('-',''));
                  if(values.containsKey('$date')){
                    if(dates.weekday != 6){
                      if(newweek){
                        newWeekStart = dates;
                        newweek=false;
                      }
                      totalamount = totalamount + values["$date"]["DailyTotal"]*1.0;
                      totalsales = totalsales + values["$date"]["DailyTotalSales"]*1.0;
                      if(dates == widget.endDate){
                        DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+values["$date"]["DailyTotal"]*1.0));
                        DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+values["$date"]["DailyTotalSales"]*1.0));
                      }
                    }else{
                      DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount+values["$date"]["DailyTotal"]*1.0));
                      DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales+values["$date"]["DailyTotalSales"]*1.0));
                      newweek = true;
                      totalamount = 0;
                      totalsales = 0;
                    }
                    q++;
                  }else{
                    if(dates.weekday != 6){
                      if(newweek){
                        newWeekStart = dates;
                        newweek=false;
                      }
                      if(dates == widget.endDate){
                        DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount));
                        DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales));
                      }
                    }else{
                      DailyTotalList.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalamount));
                      DailyTotalSales.add(DailyTotal(week[newWeekStart.weekday]+' - '+week[dates.weekday]+"\n"+newWeekStart.toString().split(' ')[0].substring(5).replaceAll('-','/')+'-\n'+dates.toString().split(' ')[0].substring(5).replaceAll('-','/'),totalsales));
                      newweek = true;
                      totalamount =0;
                      totalsales =0;
                    }
                  }
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
                double totalSale= DailyTotalSales[0].total;
                for(int i=1;i<DailyTotalList.length;i++){
                  totalRevenue = totalRevenue + DailyTotalList[i].total;
                  totalSale = totalSale + DailyTotalSales[i].total;
                }
                for(int i=0;i< DailyTotalList.length;i++){
                  dataRow.add(DataRow(cells: [
                    DataCell(Text((DailyTotalSales[i].day.toString()))),
                    DataCell(Text(DailyTotalList[i].total.toString())),
                    DataCell(Text(DailyTotalSales[i].total.toString()))
                  ]));
                }
                key++;
                return Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 4,),
                            Center(child: Text('Highest Revenue',style: TextStyle(fontSize: 45,color: Colors.deepPurple),textAlign: TextAlign.center,key:ValueKey(key))),
                            SizedBox(height: 4,),
                            Center(child: Text(DailyTotalList[totalindex].day.toString().replaceFirst('\n', '',12)+" : "+DailyTotalList[totalindex].total.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30))),
                            SizedBox(height: 4,),
                            Center(child: Text('Total Revenue',style: TextStyle(fontSize: 45,color: Colors.deepPurple),textAlign: TextAlign.center,key:ValueKey(key))),
                            SizedBox(height: 4,),
                            Center(child: Text(totalRevenue.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30))),
                            SizedBox(height: 4,),
                            Center(child: Text('Average Revenue',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                            SizedBox(height: 4),
                            Center(child: Text((totalRevenue/q).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                            SizedBox(height: 4,),
                            Center(child: Text('Highest Sales',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                            SizedBox(height: 4,),
                            Center(child: Text(DailyTotalSales[salesindex].day.toString().replaceAll('\n',' ')+' : '+DailyTotalSales[salesindex].total.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                            SizedBox(height: 4),
                            Center(child: Text('Total Sales',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                            SizedBox(height: 4),
                            Center(child: Text(totalSale.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                            SizedBox(height: 4),
                            Center(child: Text('Average Sales',style: TextStyle(fontSize: 35,color: Colors.deepPurple),textAlign: TextAlign.center)),
                            SizedBox(height: 4),
                            Center(child: Text((totalSale/q).toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key))),
                            SizedBox(height: 4),
                          ],
                        ),
                      )
                    ),
                    Expanded(
                      flex: 5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Revenue and Sales Table',textAlign: TextAlign.center,style: TextStyle(fontSize: 30),key:ValueKey(key)),
                            ),
                            FittedBox(
                              child: DataTable(
                                  columns: dataColumn,
                                  rows: dataRow
                              ),
                            )
                          ],
                        ),
                      )
                    ),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            })
    );
  }
}

