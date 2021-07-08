// @dart = 2.7
import 'package:flutter_local_notifications_extended/flutter_local_notifications_extended.dart';

import 'package:rxdart/subjects.dart';



class LocalNotifyManager{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin  = FlutterLocalNotificationsPlugin() ;

  var initializtionSettings ;

  BehaviorSubject<ReceiveNotification> get didReceiveLocalNotificationSubject =>
                             BehaviorSubject<ReceiveNotification>();

 LocalNotifyManager.init(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin(); //   if(Platform().ios){
  //    requestIosPermission();
  //  }
    initializePlatform();
 }

  requestIosPermission() {}

  initializePlatform(){
    var androidInitialize = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialize = new IOSInitializationSettings();
     initializtionSettings = new InitializationSettings( androidInitialize,iosInitialize);
  }

  setOnNotificationReceive(Function onNotificationReceive){
     didReceiveLocalNotificationSubject.listen((notification) {
         onNotificationReceive(notification);
     });
  }

  setOnNotificationClick(Function onNotificationClick) async{
     await flutterLocalNotificationsPlugin.initialize( initializtionSettings ,
     onSelectNotification: (String payload) async {
        onNotificationClick(payload);
      }
     );
  }

  Future<void> showNotification() async{
     var androidChannel = AndroidNotificationDetails(
       'CHANNEL_ID',
       'CHANNEL_NAME',
       'CHANNEL_DESCRIPTION',
       importance: Importance.Max,
       priority:  Priority.High,
       playSound: true,
     );

     var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformchannel = NotificationDetails(androidChannel,iOSPlatformChannelSpecifics );
      await flutterLocalNotificationsPlugin.show(0, 'Test tile', 'test body', platformchannel,payload: 'New payload');
  }



  Future<void> repeatNotificaion(String title,String description, String date,String time,int alarmcode) async{


    var repeatdatetime = DateTime(DateTime.now().year,int.parse(date.substring(0,2)),int.parse(date.substring(3)),int.parse(time.substring(0,2)) ,int.parse(time.substring(3)),0);
    var repeattime = Time(int.parse(time.substring(0,2)),int.parse(time.substring(3)),00);
    print("LocalNotification : $repeatdatetime");

    var androidChannel = AndroidNotificationDetails(
        'CHANNEL_ID',
        'CHANNEL_NAME',
        'CHANNEL_DESCRIPTION',
        importance: Importance.Max,
        priority:  Priority.High,
        playSound: true,
        enableLights: true
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformchannel = NotificationDetails(androidChannel,iOSPlatformChannelSpecifics );
    await flutterLocalNotificationsPlugin.showYearlyAtDayAndTime(alarmcode, title, description,Day.Monday,repeatdatetime,repeattime ,platformchannel,payload: 'New payload');

  }

  Future<void> cancelNotification(int id) async{
   await flutterLocalNotificationsPlugin.cancel(id);
  }



}

LocalNotifyManager localNotifyManager = LocalNotifyManager.init();
class ReceiveNotification{
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceiveNotification({this.id,this.title ,this.body , this.payload});

}
