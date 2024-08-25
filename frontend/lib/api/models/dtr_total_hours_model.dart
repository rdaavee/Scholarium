class DtrHoursModel {
  final int totalhours;
  final int targethours;

  const DtrHoursModel({
    required this.totalhours,
    required this.targethours,
  });

  factory DtrHoursModel.fromJson(Map<String, dynamic> map) {
    return DtrHoursModel(
      totalhours: map['totalhours'] as int,
      targethours: map['targethours'] as int,
    );
  }
}
