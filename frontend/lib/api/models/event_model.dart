class EventModel {
  final String? id;
  String imageLink;
  String eventName;
  String description;
  String date;
  String time;

  EventModel({
    this.id,
    required this.imageLink,
    required this.eventName,
    required this.description,
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'event_image': imageLink,
      'event_name': eventName,
      'description': description,
      'date': date,
      'time': time,
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['_id'],
      eventName: json['event_name'],
      description: json['description'],
      date: json['date'],
      time: json['time'],
      imageLink: json['image_link'],
    );
  }
}
