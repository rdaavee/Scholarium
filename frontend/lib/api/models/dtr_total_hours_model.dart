class DtrHoursModel {
  final double totalhours;
  final double targethours;

  const DtrHoursModel({
    required this.totalhours,
    required this.targethours,
  });

  factory DtrHoursModel.fromJson(Map<String, dynamic> json) {
    return DtrHoursModel(
      totalhours: (json['totalhours'] as num).toDouble(),
      targethours: (json['targethours'] as num).toDouble(),
    );
  }
}
