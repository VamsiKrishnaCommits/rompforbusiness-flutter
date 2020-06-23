import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'ManagerCheckout.dart';
import 'owner.dart';
import 'tokenandstore.dart';
void main(){
  runApp(new owner());
}
//loginpage
class mee extends StatefulWidget {
  @override
  _meeState createState() => _meeState();
}
class _meeState extends State<mee> {
  final control=TextEditingController();
  var k=Colors.deepOrange;
  var firebase=FirebaseDatabase.instance;
  DatabaseReference data;
  int count=0;
  double fac=0;
  double width=200;
  int color=0x7FFFD4;
  String a="hey";
  double c=0,d=0;
  var al=Alignment.bottomLeft;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data=firebase.reference();
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title :"SellDom", home:
    Builder(
        builder: (context)=>Center(
            child: Scaffold(
                appBar: AppBar(
                  title: Text("Selldom"),
                ),
                body:Container(
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children : <Widget>[
                              FractionallySizedBox(
                                widthFactor: 3/4,
                                child:Theme(
                                    data: new ThemeData(
                                        primaryColor: k
                                    ),
                                    child:TextField(
                                      onTap: () {
                                        setState(() {
                                        });
                                      },
                                      controller: control,
                                      decoration: InputDecoration(
                                        hintText:  "StoreName/PhoneNumber",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(3.0),
                                            borderSide: BorderSide(
                                                style: BorderStyle.solid
                                            )
                                        ),
                                      ),
                                      onChanged: (text){
                                        setState(() {
                                          a=text;
                                        });
                                      }
                                      ,
                                    ) ),

                              )
                              ,
                              SizedBox(height: 20,)
                              ,FractionallySizedBox(
                                widthFactor: 3/4,
                                child:Theme(
                                    data: new ThemeData(
                                        primaryColor: k
                                    ),
                                    child: TextField(
                                      obscureText: true,
                                      onTap: () {
                                        setState(() {
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Password",
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(3.0),
                                            borderSide: BorderSide(
                                                style: BorderStyle.solid
                                            )
                                        ),
                                      ),
                                      onChanged: (text){
                                        setState(() {
                                          a=text;
                                        });
                                      }
                                      ,
                                    )),
                              ),
                              SizedBox(height: 10,),
                              RaisedButton(
                                color: Colors.cyanAccent,
                                onPressed:() {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => manager()),
                                        (Route<dynamic> route) => false,
                                  );                                },
                                child: Text("Sign Up!"),
                              )
                              ,

                              Padding(
                                  padding: EdgeInsets.only(top:30),
                                  child:FractionallySizedBox(
                                      widthFactor: 9/10,
                                      child: Divider(
                                        height: 10.0,
                                        color: Colors.purple,
                                        thickness: 3.0,
                                      )
                                  ))
                              ,
                              Padding(
                                  padding:EdgeInsets.only(top:30),
                                  child: RaisedButton(
                                      color: Colors.cyanAccent,
                                      onPressed: (){
                                        Navigator.push(context,  MaterialPageRoute(builder: (context) => register()));
                                      },
                                      child: Text("Dont have an account? Register here!")
                                  ))
                            ]
                        )
                    )
                )
            )
        ) ) );
  }
}
//verify phone number
class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}
class _registerState extends State<register> {
  String phonenumber;
  FirebaseAuth phone=FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  var al=Alignment.topCenter;
  final control=TextEditingController();
  final control2=TextEditingController();
  var con;
  @override
  Widget build(BuildContext context) {
    FirebaseAuth phone=FirebaseAuth.instance;
    Future.delayed(Duration(milliseconds: 250),(){
      setState(() {
        al=Alignment.center;
      });
    });
    return Container(
        child: MaterialApp(
            title: "Register",home:
        Builder(
            builder:(context)=>Center(
              child:Scaffold(
                appBar: AppBar(
                  title: Text("Register"),
                ),
                body:
                AnimatedContainer(
                  color: Colors.cyanAccent,
                  duration: Duration(seconds: 1),
                  curve: Curves.elasticOut,
                  alignment:Alignment.topRight,
                  child:GestureDetector(
                      child :Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Card(
                              child: TextField(
                                onChanged: (string){
                                  if(string.length==10){
                                    phonenumber="+91"+string;
                                    print(phonenumber);
                                    Phone.number=phonenumber;
                                  }
                                },
                                controller: control,
                                decoration: InputDecoration(
                                  hintText:  "Phone Number",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(3.0),
                                      borderSide: BorderSide(
                                          style: BorderStyle.solid
                                      )
                                  ),
                                ),
                              )),
                          Builder(
                              builder:(context)=>Center(
                                  child: RaisedButton(
                                    child: Text("Get OTP"),
                                    onPressed:() async {
                                      Phone.ph=phone;
                                      con=context;
                                      await phone.verifyPhoneNumber(
                                          phoneNumber: phonenumber,
                                          timeout: Duration(seconds: 0),
                                          verificationCompleted: (authCredential) => _verificationComplete(authCredential, context),
                                          verificationFailed: (authException) => _verificationFailed(authException, context),
                                          codeAutoRetrievalTimeout: (verificationId) => _codeAutoRetrievalTimeout(verificationId),
                                          // called when the SMS code is sent
                                          codeSent: (verificationId, [code]) => _smsCodeSent(verificationId, [code])
                                      );
                                    },
                                  ))
                          )
                        ],
                      )
                  ),
                ),
              ),
            ) )));
  }

  _verificationComplete(AuthCredential authCredential, BuildContext context) {
    phone.signInWithCredential(authCredential).then((authResult) {
      SnackBar s=new SnackBar(content: Text("verified"),duration: Duration(seconds: 0),);
      Scaffold.of(context).showSnackBar(s);
    });
  }
  _verificationFailed(AuthException authException, BuildContext context) {
    print(authException.message);
    print("here");
  }

  _codeAutoRetrievalTimeout(String verificationId) {
    print("times up bud");
    Phone.verid=verificationId;
  }

  _smsCodeSent(String verificationId, List<int> list) {
    Phone.verid=verificationId;
    TextEditingController textEditingController=TextEditingController();
    showDialog(context: con,builder:(_)=>
        AlertDialog(
          title: Text("Enter OTP"),content: TextField(
          keyboardType: TextInputType.phone,
          controller: textEditingController,
        ),
          actions: <Widget>[
            Builder(
                builder : (context)=>FlatButton(
                  child: Text("Yes"),onPressed:(){
                  AuthCredential credential=PhoneAuthProvider.getCredential(verificationId: Phone.verid, smsCode: "123456");
                  Phone.ph.signInWithCredential(credential).
                  then((authResult){
Future<FirebaseUser> user=FirebaseAuth.instance.currentUser();
user.then((value) {
  FirebaseDatabase fire=FirebaseDatabase.instance;
  DatabaseReference da=fire.reference();
  da.child("authentication").child(Phone.number).set(value.uid).then((value1)  {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>registername(value.uid)));

  });

});

                  });
                },)
            ) ],),
    );

  }
}
//MainPage
class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Selldom", home: new Scaffold(
        appBar:  AppBar(
          title: Text("Selldom"),
        ),
        body:  TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0.0),
            isDense: true,
            hintText: "hey vamsi kill it",
          ),
        )
    ),

    );
  }
}
//register
class registername extends StatefulWidget {
String uid;
  registername(this.uid);
  @override
  _registernameState createState() => _registernameState();
}

class _registernameState extends State<registername> {
  TextEditingController textEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialApp(
          title: "Register",
          home: Scaffold(
            appBar: AppBar(title:Text("Register")),
            body: Container(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          hintText: "Business Name"
                      ),
                    ),
                    RaisedButton(
                      child: Text("Next"),
                      onPressed:(){
                        FirebaseDatabase f=FirebaseDatabase.instance;
                        DatabaseReference da=f.reference();
                        da.child("IdBusinessMap").child(widget.uid).set(textEditingController.text).then((_){
                        }).catchError((onError){
                        });
                        da.child(widget.uid).child(token.tokenname).child(token.storename).set(textEditingController.text).then((_){
Navigator.push(context, MaterialPageRoute(builder: (context)=>registerbusiness(widget.uid)));
                        });
                      } ,
                    )
                  ],
                )
            ),
          ),
        )
    );
  }
}
class Phone{
  static String number;
  static String verid;
  static var ph;
}

class registerbusiness extends StatefulWidget {
  String uid;
  registerbusiness(this.uid);
  @override
  _registerbusinessState createState() => _registerbusinessState();
}

class _registerbusinessState extends State<registerbusiness> {
  TextEditingController textEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialApp(
          title: "Register",
          home: Scaffold(
            appBar: AppBar(title:Text("Register")),
            body: Container(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          hintText: "Your Name"
                      ),
                    ),
                    RaisedButton(
                      child: Text("Go"),
                      onPressed:(){
                        FirebaseDatabase f=FirebaseDatabase.instance;
                        DatabaseReference da=f.reference();
                        da.child(widget.uid).child("Team").child(Phone.number).child("role").set("owner").then((_){
                          da.child(widget.uid).child("Team").child(Phone.number).child("name").set(textEditingController.text).then((_)
                          {

                            Navigator.push(context, MaterialPageRoute(builder: (context)=> multiplebranches(widget.uid)));

                          });
                        }).catchError((onError){
                        });


                      } ,
                    )
                  ],
                )
            ),
          ),
        )
    );
  }
}
class multiplebranches extends StatefulWidget {
  String uid;
  multiplebranches(this.uid);
  @override
  _multiplebranchesState createState() => _multiplebranchesState();
}
class _multiplebranchesState extends State<multiplebranches> {
  TextEditingController textEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialApp(
          title: "Register",
          home: Scaffold(
            appBar: AppBar(title:Text("Register")),
            body: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                        "Do you own more than one branch"
                    ),
                    RaisedButton(
                      child: Text("Yes"),
                      onPressed:(){
                        FirebaseDatabase f=FirebaseDatabase.instance;
                        DatabaseReference da=f.reference();
                        da.child(widget.uid).child("multiplebranches").set("yes").then((_){

                          Navigator.push(context, MaterialPageRoute(builder: (context)=> operate(widget.uid)));

                        }).catchError((onError){
                        });
                      } ,
                    ),
                    RaisedButton(
                      child: Text("Nah"),
                      onPressed:(){
                        FirebaseDatabase f=FirebaseDatabase.instance;
                        DatabaseReference da=f.reference();
                        da.child(widget.uid).child("multiplebranches").set("no").then((_){
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => manager()),
                                (Route<dynamic> route) => false,
                          );
                        }).catchError((onError){
                        });
                      } ,
                    )
                  ],
                )
            ),
          ),
        )
    );
  }
}
class operate extends StatefulWidget {
  String uid;
  operate(this.uid);
  @override
  _operateState createState() => _operateState();
}
class _operateState extends State<operate> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialApp(
          title: "Register",
          home: Scaffold(
            appBar: AppBar(title:Text("Register")),
            body: Container(
                child: Column(
                  children: <Widget>[
                    Text(
                        "Do you operate any branch on your own ?"
                    ),
                    RaisedButton(
                      child: Text("Yes"),
                      onPressed:(){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => branchname(widget.uid)),
                              (Route<dynamic> route) => false,
                        );                      }  ,
                    ),
                    RaisedButton(
                      child: Text("Nah"),
                      onPressed:(){
FirebaseDatabase f=FirebaseDatabase.instance;
DatabaseReference da=f.reference();
                        da.child(widget.uid).child("Team").child(Phone.number).child("branch").set("-").then((value) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => manager()),

                                (Route<dynamic> route) => false,
                          );
                        });
                                           } ,
                    )
                  ],
                )
            ),
          ),
        )
    );
  }
}
class branchname extends StatefulWidget {
  String uid;
  branchname(this.uid);

  @override
  _branchnameState createState() => _branchnameState();
}

class _branchnameState extends State<branchname> {
  TextEditingController textEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialApp(
          title: "Register",
          home: Scaffold(
            appBar: AppBar(title:Text("Register")),
            body: Container(
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                          hintText: "Branch name you operate"
                      ),
                    ),
                    RaisedButton(
                      child: Text("Next"),
                      onPressed:(){
                        FirebaseDatabase f=FirebaseDatabase.instance;
                        DatabaseReference da=f.reference();
                        da.child(widget.uid).child("Team").child(Phone.number).child("branch").set(textEditingController.text).then((_){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>manager()));
                        }).catchError((onError){
                        });
                        da.child(widget.uid).child(token.tokenname).child(token.storename).set(textEditingController.text).then((_){
                        });
                      } ,
                    )
                  ],
                )
            ),
          ),
        )
    );
  }
}
