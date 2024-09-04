class DtrHoursModel {
  final double totalhours;
  final double targethours;

  const DtrHoursModel({
    required this.totalhours,
    required this.targethours,
  });

  factory DtrHoursModel.fromJson(Map<String, dynamic> map) {
    return DtrHoursModel(
      totalhours: (map['totalhours'] as num).toDouble(),
      targethours: (map['targethours'] as num).toDouble(),
    );
  }
}
