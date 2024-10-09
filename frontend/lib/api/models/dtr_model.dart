class DtrModel {
  final int? id;
  final String? schoolID;
  final String? date;
  final String? timeIn;
  final String? timeOut;
  final double? hoursToRendered;
  final double? hoursRendered;
  final String? professor;
  final String? professorSignature;

  const DtrModel({
    this.id,
    this.schoolID,
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.hoursToRendered,
    required this.hoursRendered,
    required this.professor,
    required this.professorSignature,
  });

  factory DtrModel.fromJson(Map<String, dynamic> map) {
    return DtrModel(
      id: map['id'] as int?,
      schoolID: map['school_id'] as String?,
      date: map['date'] as String?,
      timeIn: map['time_in'] as String?,
      timeOut: map['time_out'] as String?,
      hoursToRendered: (map['hours_to_rendered'] as num).toDouble(),
      hoursRendered: (map['hours_rendered'] as num).toDouble(),
      professor: map['professor'] as String?,
      professorSignature: map['professor_signature'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school_id': schoolID,
      'date': date,
      'time_in': timeIn,
      'time_out': timeOut,
      'hours_to_rendered': hoursToRendered,
      'hours_rendered': hoursRendered,
      'professor': professor,
      'professor_signature': professorSignature,
    };
  }
}
