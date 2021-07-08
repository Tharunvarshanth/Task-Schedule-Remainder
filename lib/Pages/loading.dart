import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:TaskRemainder/Pages/viewschedule.dart';
import 'dart:async';




class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return(MaterialApp(
        debugShowCheckedModeBanner: false,
      home:LoadingHome()
    )

    );

  }

}

class LoadingHome extends StatefulWidget{
  LoadingHome() : super();

  @override
  SplashScreen createState() => SplashScreen();



}

class SplashScreen extends State<LoadingHome>{


  @override
  void initState() {
      super.initState();

      Timer(Duration(seconds: 1),
          ()=>   Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ViewSchedule(),
              )
          )
      );

  }





  @override
  Widget build(BuildContext context) {

    const spinkit = SpinKitRotatingCircle(
      color: Colors.white,
      size: 50.0,
    );


    return MaterialApp(

      home:Container(
        decoration:BoxDecoration(

          image: DecorationImage(
              image: AssetImage('assets/loading.png'),
              fit: BoxFit.fill
          ),
        ),

          child: Center(
            child: spinkit
          ),




    )
    );
  }
  
}
