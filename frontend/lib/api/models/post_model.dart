class PostModel {
  final String title;
  final String body;
  final DateTime date;
  final String time;
  final String status;
  final String schoolId;
  final String profId;

  PostModel({
    required this.title,
    required this.body,
    required this.date,
    required this.time,
    required this.status,
    required this.schoolId,
    required this.profId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'],
      body: json['body'],
      date: DateTime.parse(json['date']),
      time: json['time'],
      status: json['status'],
      schoolId: json['school_id'],
      profId: json['prof_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'date': date.toIso8601String(),
      'time': time,
      'status': status,
      'school_id': schoolId,
      'prof_id': profId,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'date': date.toIso8601String(),
      'time': time,
      'status': status,
      'school_id': schoolId,
      'prof_id': profId,
    };
  }
}
