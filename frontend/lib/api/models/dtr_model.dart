class DtrModel {
  final int? id;
  final String? date;
  final String? timeIn;
  final String? timeOut;
  final double? hoursToRendered;
  final double? hoursRendered;
  final String? professor;
  final String? professorSignature;

  const DtrModel({
    this.id,
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
      date: map['date'] as String?,
      timeIn: map['time_in'] as String?,
      timeOut: map['time_out'] as String?,
      hoursToRendered: (map['hours_to_rendered'] as num).toDouble(),
      hoursRendered: (map['hours_rendered'] as num).toDouble(),
      professor: map['professor'] as String?,
      professorSignature: map['professor_signature'] as String?,
    );
  }
}