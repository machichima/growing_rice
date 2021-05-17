
class Alarm_look {
  Alarm_look({
    this.id,
    this.alarm_time,
    this.sound,
    this.enable_task,
    this.isactive,
    this.Sunday,
    this.Monday,
    this.Tuesday,
    this.Wednesday,
    this.Thursday,
    this.Friday,
    this.Saturday,
  });

  int id;
  DateTime alarm_time;
  String sound='1.mp3';
  bool enable_task=true;
  bool isactive=true;
  bool Sunday=true;
  bool Monday=true;
  bool Tuesday=true;
  bool Wednesday=true;
  bool Thursday=true;
  bool Friday=true;
  bool Saturday=true;

  factory Alarm_look.fromJson(Map<String, dynamic> json) => Alarm_look(
    id: json["id"],
    alarm_time: DateTime.parse(json["alarm_time"]),
    sound: json["sound"],
    enable_task: json["enable_task"] == 1,
    isactive: json["isactive"]==1,
    Sunday: json["Sunday"]==1,
    Monday: json["Monday"]==1,
    Tuesday: json["Tuesday"]==1,
    Wednesday: json["Wednesday"]==1,
    Thursday: json["Thursday"]==1,
    Friday: json["Friday"]==1,
    Saturday: json["Saturday"]==1,
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "alarm_time": alarm_time.toIso8601String(),
    "sound": sound,
    "enable_task": enable_task ?1:0,
    "isactive": isactive?1:0,
    "Sunday": Sunday?1:0,
    "Monday": Monday?1:0,
    "Tuesday": Tuesday?1:0,
    "Wednesday": Wednesday?1:0,
    "Thursday": Thursday?1:0,
    "Friday": Friday?1:0,
    "Saturday": Saturday?1:0,
  };
}