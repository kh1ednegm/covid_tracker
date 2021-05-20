import 'package:covid_tracker/home_screen.dart';
import 'package:covid_tracker/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatefulWidget{


  @override
  _LoadingScreenState createState() {
    return _LoadingScreenState();
  }
}

class _LoadingScreenState extends State<LoadingScreen>{


  Map<String,String> resultMap = {};
  var result;
  Networking request = Networking();


  Future<void> getData()async{
    result = await request.getData();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomeScreen(result: result,),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF212121),
      body: Center(
        child: SpinKitRing(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getData();
  }
}