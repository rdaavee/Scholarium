import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/professor_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_bloc.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_event.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_state.dart';

class DialogAlertBox extends StatelessWidget {
  final String? scheduleId;
  final String? schoolId;
  final String? date;
  final String? timeIn;
  final String? hkType;
  final String? professorName;
  final String? professorSignature;
  const DialogAlertBox(
      {super.key,
      required this.scheduleId,
      this.schoolId,
      this.date,
      this.timeIn,
      this.hkType,
      this.professorName,
      this.professorSignature});

  @override
  Widget build(BuildContext context) {
    final ScheduleBloc scheduleBloc =
        ScheduleBloc(StudentRepositoryImpl(), ProfessorRepositoryImpl());
    return BlocConsumer<ScheduleBloc, ScheduleState>(
      bloc: scheduleBloc,
      listener: (context, state) {},
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 120,
            width: 100,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Text(
                    "Completed their Duty?",
                    style: TextStyle(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () async {
                          try {
                            scheduleBloc.add(
                                UpdateDutySchedule(id: scheduleId.toString()));
                            final totalDuration =
                                _parseTime(timeIn.toString()) +
                                    _parseTime("01:30:00");
                            String formattedTime =
                                _formatDuration(totalDuration);
                            double hoursToRendered = 0.0;
                            if (hkType.toString() == "HK 25") {
                              hoursToRendered = 50;
                            } else if (hkType.toString() == "HK 50") {
                              hoursToRendered = 90;
                            } else if (hkType.toString() == "HK 75") {
                              hoursToRendered = 120;
                            }
                            final dtrModel = DtrModel(
                              schoolID: schoolId.toString(),
                              date: date.toString(),
                              timeIn: timeIn.toString(),
                              timeOut: formattedTime,
                              hoursToRendered: hoursToRendered,
                              hoursRendered: 1.5,
                              professor: professorName.toString(),
                              professorSignature: 'Signature1',
                            );
                            await ProfessorRepositoryImpl().createDTR(dtrModel);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Student Duty Completed')),
                            );
                            Navigator.pop(context, true);
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $error')),
                            );
                          }
                        }),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, false);
                        }),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Duration _parseTime(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }
}
