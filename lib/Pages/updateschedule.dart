
import 'package:TaskRemainder/notification/LocalNotifyManager.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:TaskRemainder/Pages/viewschedule.dart';
import 'package:TaskRemainder/db/DatabaseServices.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:TaskRemainder/db/ScheduleEntity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
//sql
import 'dart:async';




class UpdateSchedule extends StatelessWidget{
  final ScheduleEntity updatedata;

  UpdateSchedule({required this.updatedata}):super();


  @override
  Widget build(BuildContext context) {

    return (
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Update Schedule',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyUpdateForm(updatedata: updatedata),
    )
    );

  }

}

class MyUpdateForm extends StatefulWidget{

  MyUpdateForm( {required this.updatedata} ):super();

  final ScheduleEntity updatedata;

  @override
  State<StatefulWidget> createState() {
  return MyUpdateFormState();
  }

}

class MyUpdateFormState  extends State<MyUpdateForm>{



  DatabaseServices databaseServices = DatabaseServices();
  final controller  = ScrollController();
  double offset = 0;



 late int year;
 late String title ;
 late String description;
 late String date;
 late String time;



  void initState(){
    super.initState();
    var now = new DateTime.now();
    year=(now.year);
    controller.addListener(onScroll);
    localNotifyManager.setOnNotificationReceive(onNotificationReceive);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
 }

  onNotificationReceive(ReceiveNotification notification){
    print('Notification Received :${notification.id}');
  }

  onNotificationClick(String payload){
    print("Payload :$payload");
  }

  List<String> datetimedivider(String date){
      return date.split(" ");
  }



  void goBack(BuildContext context,int time){
    Timer(Duration(seconds: time),
            ()=>{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ViewSchedule()),
          )
        }
    );
  }



  void storeDB(BuildContext context) async {
    print("Update Schedule Date : $date");
       List<String> datetime = datetimedivider(date) ;
       datetime[0] = datetime[0].substring(5);
       var scheduleEntity = ScheduleEntity(title: title,description: description,date: datetime[0],time:datetime[1],alarm_req_code: 0);

       //  _showNotification(datetime);
       databaseServices.updateDog(scheduleEntity);

       var yearstring_not = new DateTime.now().year;
       yearstring_not.toString();
       String d_not = datetime[0] ;
       String t_not = datetime[1] ;
      String schedulingdate = "$yearstring_not-$d_not $t_not:00Z";
   await localNotifyManager.repeatNotificaion(title,description,d_not,t_not,widget.updatedata.alarm_req_code);
   goBack(context, 1);
  }

  @override
  void dispose(){

    controller.dispose();
    super.dispose();
  }

  void onScroll(){
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }
  final _formKey = GlobalKey<FormState>();




  @override
  Widget build(BuildContext context) {

    var yearstring = new DateTime.now().year;
         yearstring.toString();
         String d = widget.updatedata.date ;
         String t = widget.updatedata.time ;

   
    return
    Scaffold(
      body:SingleChildScrollView(
           controller:  controller,
        child:Column(
          children: <Widget>[
            ClipPath(
              clipper: HeadClipper(),
                child:Container(
                  height:300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                     gradient: LinearGradient(
                         colors: [
                           Color(0xFFEC407A),
                           Color(0xFF8E24AA)
                         ]
                     )
                  ),
                  child:Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget> [
                      GestureDetector(
                        onTap:(){

                         goBack(context, 0);
                          },
                        child: Align(
                            alignment: FractionalOffset(0.0025, 0.25),
                            child:Image(
                              image:AssetImage('assets/back.png'),width: 44,height: 84,
                            )

                        ),
                      ),
                      Align(
                          alignment: FractionalOffset(0.2, 0.6),
                          child:Image(
                            image:AssetImage('assets/bauble.png'),width: 24,height: 24,
                          )
                      ),
                      Align(
                          alignment: FractionalOffset(0.5, 0.6),
                          child:Image(
                            image:AssetImage('assets/bell.png'),width: 24,height: 24,
                          )
                      ),
                      Align(
                          alignment: FractionalOffset(0.8, 0.6),
                          child:Image(
                            image:AssetImage('assets/light-bulb.png'),width: 24,height: 24,
                          )
                      ),

                      Expanded(
                          child:Stack(
                            children: <Widget>[
                              Align(
                                  alignment: FractionalOffset(0.2, 0.2),
                                  child:Image(
                                    image:AssetImage('assets/balloons.png'),width: 24,height: 24,
                                  )
                              ),
                              Align(
                                  alignment: FractionalOffset(0.8, 0.3),
                                  child:Image(
                                    image:AssetImage('assets/sofa.png'),width: 24,height: 24,
                                  )
                              ),
                              Align(
                                  alignment: FractionalOffset(0.5, 0.3),
                                  child: Text(
                                    'Update Task ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 36,color: Colors.white,),
                                  )
                              )
                            ],
                          )
                      ),
                    ],
                  ),
              )              ,
            ),
            updateform(context),

          ],
        )
      )
     );


  }



  updateform(BuildContext context){
    return(
        Builder(
            builder: (BuildContext context) {
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Text("Title",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32,
                                foreground: Paint()
                                  ..shader = ui.Gradient.linear(
                                    const Offset(0, 73),
                                    const Offset(411, 20),
                                    <Color>[
                                      Colors.pink,
                                      Colors.purple,
                                    ],
                                  )
                            ),
                          ),
                          TextFormField(
                            initialValue: widget.updatedata.title,
                            decoration: const InputDecoration(
                              //  hintText: updatedata.title,
                              icon: Icon(Icons.title),
                              border: const OutlineInputBorder(),
                            ),
                            style: TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 18,
                              foreground: Paint()
                                ..shader = ui.Gradient.linear(
                                  const Offset(0, 73),
                                  const Offset(411, 20),
                                  <Color>[
                                    Colors.deepPurple,
                                    Colors.pink
                                  ],
                                ),
                            ),
                            onSaved: (String? value) {
                              title = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 25,),
                          Text("Description",
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 28,
                                foreground: Paint()
                                  ..shader = ui.Gradient.linear(
                                    const Offset(0, 73),
                                    const Offset(411, 20),
                                    <Color>[
                                      Colors.pink,
                                      Colors.purple,
                                    ],
                                  )
                            ),),
                          TextFormField(
                            initialValue: widget.updatedata.description,
                            decoration: const InputDecoration(
                              hintText: 'Enter your Description',
                              icon: Icon(Icons.description),
                              border: const OutlineInputBorder(),
                            ),
                            style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 16,
                                foreground: Paint()
                                  ..shader = ui.Gradient.linear(
                                    const Offset(0, 73),
                                    const Offset(411, 20),
                                    <Color>[
                                      Colors.deepPurple,
                                      Colors.pink
                                    ],
                                  )
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            onSaved: (String? value) {
                              description = value!;
                            },
                          ),
                          SizedBox(height: 25,),
                          DateTimePicker(
                            type: DateTimePickerType.dateTimeSeparate,
                            dateMask: 'd MMM',
                            // initialValue: DateTime.now().toString(),
                            //   initialValue: DateTime.parse(initialdate).toString(),

                            use24HourFormat: true,
                            firstDate: DateTime(year),
                            lastDate: DateTime(year + 2),
                            icon: Icon(Icons.event),
                            dateLabelText: 'Date',

                            timeLabelText: "Time",

                            onChanged: (val) => print(val),
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Choose date';
                              }

                              return null;
                            },
                            onSaved: (String? val) {
                              date = val!;
                            },
                          ),
                          SizedBox(height: 10,),
                          RaisedButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                _formKey.currentState!.save();

                                //Send Api
                                createSnackBar(context);
                                storeDB(context);
                              },
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: <Color>[
                                      Color(0xFFE11B9A),
                                      Color(0xFFBA68C8),
                                      Color(0xFF8E24AA),
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.all(10.0),
                                child:
                                const Text(
                                    'Update', style: TextStyle(fontSize: 20)),
                              )
                          ),
                        ],
                      )
                  )
              );
            }
            )
    );
  }

 createSnackBar(BuildContext context){
   final snackBarDelete = SnackBar(content: Text('Task Updated'),);
   Scaffold.of(context).showSnackBar(snackBarDelete);
 }



}



class HeadClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0,size.height-80);
    path.quadraticBezierTo(size.width/2, size.height, size.width, size.height-80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return false;
  }

}
