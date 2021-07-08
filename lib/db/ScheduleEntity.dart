class ScheduleEntity{

 final String title;
 final String description;
 final String date;
 final String time;
 final int alarm_req_code;

  ScheduleEntity( {required this.title, required this.description, required this.date, required this.time, required this.alarm_req_code});

 Map<String, dynamic> toMap() {
   return {
     'title': title,
     'description': description,
     'date':date,
     'time':time,
     'alarm_req_code':alarm_req_code
   };
 }

 // Implement toString to make it easier to see information about
 // each dog when using the print statement.
 @override
 String toString() {
   return 'Dog{ title: $title, desc: $description,time: $time,date: $date,alarm:$alarm_req_code}';
 }
}