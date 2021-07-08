import 'package:flutter/material.dart';
// @dart = 2.7
import 'package:flutter_local_notifications_extended/flutter_local_notifications_extended.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'db/DatabaseServices.dart';
import 'Pages/loading.dart';
import 'Pages/viewschedule.dart';
import 'Pages/addschedule.dart';
import 'package:flutter/widgets.dart';




void main() async{

  WidgetsFlutterBinding.ensureInitialized();






  WidgetsFlutterBinding.ensureInitialized();
  DatabaseServices();


  runApp(
      MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
       routes: <String, WidgetBuilder>{
         '/': (BuildContext context) => Loading(),
         '/viewschedule': (BuildContext context) => ViewSchedule(),
         '/addschedule' :(BuildContext context) => AddSchedule(tasklength: 0,),

       }
     )
  );

}





