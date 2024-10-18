// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/professor_repository_impl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_bloc.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_event.dart';
import 'package:isHKolarium/blocs/bloc_schedule/schedule_state.dart';
import 'package:signature/signature.dart';

class DialogAlertBox extends StatefulWidget {
  final String scheduleId;
  final String role;
  final String selectedMonth;
  final String schoolId;
  final String date;
  final String timeIn;
  final String timeOut;
  final String remarks;
  final String hkType;
  final String professorName;

  const DialogAlertBox({
    super.key,
    required this.scheduleId,
    required this.role,
    required this.selectedMonth,
    required this.schoolId,
    required this.date,
    required this.timeIn,
    required this.timeOut,
    required this.remarks,
    required this.hkType,
    required this.professorName,
  });

  @override
  _DialogAlertBoxState createState() => _DialogAlertBoxState();
}

class _DialogAlertBoxState extends State<DialogAlertBox> {
  final ScheduleBloc _scheduleBloc =
      ScheduleBloc(StudentRepositoryImpl(), ProfessorRepositoryImpl());
  final SignatureController _signatureController =
      SignatureController(penStrokeWidth: 5, penColor: Colors.black);

  Uint8List? _signatureImage;

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScheduleBloc, ScheduleState>(
      bloc: _scheduleBloc,
      listener: (context, state) {},
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 450,
            width: 300,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Text(
                    "Completed their Duty? Please Sign Below:",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Signature(
                    controller: _signatureController,
                    height: 300,
                    width: double.infinity,
                    backgroundColor: Colors.grey[200]!,
                  ),
                ),
                if (_signatureImage !=
                    null) // Display the signature image if it exists
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.memory(_signatureImage!),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(
                        "Confirm",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_signatureController.isNotEmpty) {
                          final image = await _signatureController.toImage();
                          final byteData = await image?.toByteData(
                              format: ImageByteFormat.png);
                          _signatureImage = byteData!.buffer.asUint8List();
                          setState(() {});
                          try {
                            _scheduleBloc.add(UpdateDutySchedule(
                                id: widget.scheduleId,
                                selectedMonth: widget.selectedMonth,
                                role: widget.role));
                            double hoursToRendered = 0.0;
                            if (widget.hkType == "HK 25") {
                              hoursToRendered = 50;
                            } else if (widget.hkType == "HK 50") {
                              hoursToRendered = 90;
                            } else if (widget.hkType == "HK 75") {
                              hoursToRendered = 120;
                            }
                            final dtrModel = DtrModel(
                              schoolID: widget.schoolId.toString(),
                              date: widget.date.toString(),
                              timeIn: widget.timeIn.toString(),
                              timeOut: widget.timeOut.toString(),
                              hoursToRendered: hoursToRendered,
                              hoursRendered: double.parse(
                                  (convertTimeToDecimal(widget.timeOut) -
                                          convertTimeToDecimal(widget.timeIn))
                                      .toStringAsFixed(2)),
                              remarks: widget.remarks.toString(),
                              professor: widget.professorName.toString(),
                              professorSignature: _signatureImage != null
                                  ? base64Encode(_signatureImage!)
                                  : null,
                            );
                            _scheduleBloc.add(CreateDTREvent(
                                dtr: dtrModel,
                                selectedMonth: widget.selectedMonth,
                                role: widget.role));
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
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please sign to confirm.')),
                          );
                        }
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double convertTimeToDecimal(String time) {
    // Split the time string into the time part and AM/PM part
    List<String> parts = time.split(' ');
    String timePart = parts[0];
    String period = parts[1];

    // Split the time part into hours and minutes
    List<String> timeParts = timePart.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    // Convert to 24-hour format if necessary
    if (period == 'PM' && hours != 12) {
      hours += 12;
    } else if (period == 'AM' && hours == 12) {
      hours = 0;
    }

    // Convert the time into decimal hours
    double decimalTime = hours + (minutes / 60.0);

    return decimalTime;
  }
}
