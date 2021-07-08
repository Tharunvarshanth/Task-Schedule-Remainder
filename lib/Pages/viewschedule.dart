
import 'dart:ui';
import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:TaskRemainder/Pages/updateschedule.dart';
import 'package:TaskRemainder/db/ScheduleEntity.dart';
import 'package:TaskRemainder/notification/LocalNotifyManager.dart';
import 'addschedule.dart';
import  'package:TaskRemainder/db/DatabaseServices.dart';
//sql
import 'dart:async';





class ViewSchedule extends StatelessWidget {

@override
Widget build(BuildContext context) {

  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.pink,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: MyHomePage(title: 'Task List'),
  );
}
}

class MyHomePage extends StatefulWidget {

  MyHomePage({ required this.title}) : super();


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  DatabaseServices dbHelper = DatabaseServices();


  final controller = ScrollController();
  double offset = 0;
  late int tasksize;

  //2nd
   late Future<List<ScheduleEntity>> listscheduleentity;

   late bool isUpdating;




  void initState(){
    super.initState();
    isUpdating = false;
    refreshList();
    print("InitState");
  }





  void refreshList(){
       setState(() {
         listscheduleentity = dbHelper.getalltasks();
       });
  }

  @override
  void dispose() {
    print("view duspose");
    controller.dispose();
    super.dispose();
  }


  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  void deleteTask(ScheduleEntity scheduleEntity,BuildContext context){

    dbHelper.deleteDog( scheduleEntity);
    localNotifyManager.cancelNotification(scheduleEntity.alarm_req_code);
    refreshList();
    createSnackBar(context);
  }

  @override
  Widget build(BuildContext context) {
   controller.addListener(onScroll);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          RaisedButton(
            highlightElevation: 2,
            onPressed:(){
              //hideBannerAd();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddSchedule(tasklength:tasksize)),
              );
            },
            child: Text(
              'Add',
              style: TextStyle(fontSize: 20,fontFamily:'NovaFlat'),
            ),
          ),
        ],
      ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/viewshedul.jpg'),
                  fit:BoxFit.fill
            ),
            )          ,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              list(context),
            ],
          ),
        ),
    );
  }

  dataTable(List<ScheduleEntity> employees,BuildContext context) {
     tasksize = employees.length;
     print('${tasksize} : DataTable ');
    return
    ListView.builder(
          itemCount: employees.length,
          padding: const EdgeInsets.all(5),

          itemBuilder: (context,index) {
            return Card(
                borderOnForeground: true,
                shadowColor: Colors.pink,
                elevation:10,
                color: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),),
                child: Column(
                    children: [
                      ListTile(
                        title: Text(employees[index].title,
                            style:TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color:Colors.white,fontFamily:'NovaFlat')
                        ),
                        subtitle:ListTile(

                          title: Text(employees[index].description,
                            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 24,fontFamily:'NovaFlat'),
                          ),
                        ),
                      ),
                          Padding(
                            padding: EdgeInsets.all(0),
                              child: Text(new DateFormat.MMMMd().add_jm() .format(DateTime (DateTime.now().year,int.parse(employees[index].date.substring(0,2)),int.parse(employees[index].date.substring(3)),int.parse(employees[index].time.substring(0,2)) ,int.parse(employees[index].time.substring(3)),0))
                                  ,
                                  style:TextStyle(fontSize: 22,color:Colors.white,fontFamily:'NovaFlat')
                              ),


                          ),
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            onPressed: () {
                            //hideBannerAd();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateSchedule(updatedata : employees[index]),
                                  )
                              );
                            },
                           child: Image(image: AssetImage('assets/outline_border_color_black_24dp.png'),width: 34,height:20,),

                          ),
                          FlatButton(
                            onPressed: () {
                              deleteTask(employees[index],context);
                            },
                            child: Image(image: AssetImage('assets/outline_remove_circle_black_24dp.png'),width:34,height:30,),
                          ),
                        ],
                      ),
                    ]
                )

            );
          }
      );

  }

  void createSnackBar(BuildContext scaffoldContext){
    final snackBarAdded = SnackBar(content: Text('Task Deleted'),);
    Scaffold.of(scaffoldContext).showSnackBar(snackBarAdded);
  }



  list(BuildContext context) {
    return Expanded(
      child: FutureBuilder<List<ScheduleEntity>>(
        future: listscheduleentity,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data!, context);
          }

          if (null == snapshot.data || snapshot.data!.length == 0) {
            return Text("No Data Found");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }




}

