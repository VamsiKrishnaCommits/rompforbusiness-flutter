import 'package:firebase_database/firebase_database.dart';

class item{
  String name;
  int cost;
  int stock;
String key;
String available;
String managestock
String catagory;
  item(DataSnapshot snapshot){
    Map<dynamic,dynamic> val=snapshot.value;
    name=val["name"];
    available=val["available"].toString();
    key=snapshot.key;
    cost=int.parse(val["cost"]);
    stock=int.parse(val["stock"]);
    managestock=val["managestock"];
    catagory=val["catagory"];
  }
  item.add(String name,int cost,int stock){
    this.name=name;
    this.cost=cost;
    this.stock=stock;
  }
}