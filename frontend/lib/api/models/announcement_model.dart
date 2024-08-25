class AnnouncementModel {
  final int? adminID;
  final String title;
  final String body;
  final String time;
  final String date;


  const AnnouncementModel({
    this.adminID,
    required this.title,
    required this.body,
    required this.time,
    required this.date,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> map) {
    return AnnouncementModel(
      adminID: map['adminID'] as int?,
      title: map['title'] as String,
      body: map['body'] as String,
      time: map['time'] as String,
      date: map['date'] as String,
    );
  }
}