import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/api/models/user_model.dart';
import 'package:isHKolarium/blocs/bloc_dtr/dtr_bloc.dart';
import 'package:isHKolarium/config/assets/app_images.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/loading_circular.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/cell_widget.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/header_widget.dart';
import 'package:http/http.dart' as http;
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/your_dtr_hours_card.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DtrScreen extends StatefulWidget {
  final UserModel user;
  const DtrScreen({super.key, required this.user});

  @override
  State<DtrScreen> createState() => _DtrScreenState();
}

class _DtrScreenState extends State<DtrScreen> {
  late DtrBloc dtrBloc;

  @override
  void initState() {
    super.initState();
    final apiService = StudentRepositoryImpl();
    dtrBloc = DtrBloc(apiService);
    dtrBloc.add(FetchDtrEvent(schoolId: widget.user.schoolID.toString()));
  }

  Future<pw.ImageProvider> fetchImage(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return pw.MemoryImage(response.bodyBytes);
    } else {
      throw Exception('Failed to load image from $url');
    }
  }

  Future<Uint8List> loadAssetImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  Future<void> generatePdf(List<DtrModel> dtrList) async {
    final pdfDocument = pw.Document();
    final Uint8List logoBytes = await loadAssetImage(AppImages.uPangLogo);
    final pw.ImageProvider logoImage = pw.MemoryImage(logoBytes);
    // Table data
    print(widget.user.professor.toString());
    final List<List<dynamic>> tableData = [];
    for (var dtr in dtrList) {
      String formattedDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(dtr.date.toString()));

      final imageProvider = await fetchImage(dtr.professorSignature.toString());

      tableData.add([
        formattedDate,
        dtr.timeIn,
        dtr.timeOut,
        dtr.hoursRendered.toString(),
        dtr.remarks,
        imageProvider,
      ]);
    }

    pdfDocument.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Image(logoImage, width: 60, height: 60),
                    pw.SizedBox(width: 20),
                    pw.Text('HawakKamay Student DTR',
                        style: pw.TextStyle(
                            fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Text('HK-SF No: ',
                    style: pw.TextStyle(
                        fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.Text("", style: pw.TextStyle(fontSize: 12)),
                pw.Row(
                  children: [
                    pw.Text('Name: ',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                        "${widget.user.lastName}, ${widget.user.firstName} ${widget.user.middleName}",
                        style: pw.TextStyle(fontSize: 12)),
                    pw.Spacer(),
                    pw.Text('Contact: ',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text(widget.user.contact.toString(),
                        style: pw.TextStyle(fontSize: 12)),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  children: [
                    pw.Text('Type of Scholarship: ',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text(widget.user.hkType.toString(),
                        style: pw.TextStyle(fontSize: 12)),
                    pw.Spacer(),
                    pw.Text('Endorsement Date: ',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.Text("________________",
                        style: pw.TextStyle(fontSize: 12)),
                  ],
                ),
                pw.SizedBox(height: 20),
              ],
            ),
          ),
          pw.TableHelper.fromTextArray(
            headers: [
              'Date',
              'Time In',
              'Time Out',
              'No. of Hours',
              'Remarks',
              'Authorized Signature'
            ],
            data: tableData.map((row) {
              return [
                row[0], // Date
                row[1], // Time In
                row[2], // Time Out
                row[3], // Hours Rendered
                row[4], // Remarks
                pw.Container(
                  child: pw.Image(row[5]), // Signature image
                  width: 50,
                  height: 50,
                ),
              ];
            }).toList(),
            border: pw.TableBorder.all(), // Add border to table
            headerStyle:
                pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            cellStyle: pw.TextStyle(fontSize: 10),
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            cellHeight: 30,
            columnWidths: {
              0: pw.FlexColumnWidth(1), // Date column
              1: pw.FlexColumnWidth(1), // Time In
              2: pw.FlexColumnWidth(1), // Time Out
              3: pw.FlexColumnWidth(1), // No. of Hours
              4: pw.FlexColumnWidth(1), // remarks
              5: pw.FlexColumnWidth(1.2), // Authorized Signature
            },
          ),
          pw.Footer(
            padding: const pw.EdgeInsets.only(top: 20),
            title: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Text(
                      'Total Hours to Render: ',
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      dtrList[0].hoursToRendered.toString(),
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(width: 100),
                    pw.Text(
                      'Expert Teacher: ',
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      widget.user.professor.toString(),
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  children: [
                    pw.Text(
                      'Total Hours Rendered: ',
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      calculateTotalHours(dtrList).toString(),
                      style: pw.TextStyle(fontSize: 12),
                    ),
                    pw.SizedBox(width: 150),
                    pw.Text(
                      'Verified By: ',
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text("________________",
                        style: pw.TextStyle(fontSize: 12)),
                  ],
                ),
                pw.SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );

    // Save the PDF and prompt for download
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfDocument.save(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download Completed')),
    );
  }

// Helper function to calculate total hours rendered
  int calculateTotalHours(List<DtrModel> dtrList) {
    return dtrList.fold(0, (total, dtr) => total + dtr.hoursRendered!.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DtrBloc>(create: (context) => dtrBloc),
      ],
      child: Scaffold(
        backgroundColor: Color(0xFFF0F3F4),
        appBar: const AppBarWidget(title: "DTR", isBackButton: true),
        body: BlocConsumer<DtrBloc, DtrState>(
          listener: (context, state) {
            if (state is DtrErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is DtrLoadingState) {
              return LoadingCircular();
            } else if (state is DtrLoadedSuccessState) {
              return Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F3F4),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            child: YourDtrHoursCard(
                              progress: (state.hours[0].totalhours /
                                      state.hours[0].targethours)
                                  .clamp(0.0, 1.0),
                              cardColor: Colors.white,
                            ),
                          ),
                          Table(
                            border: TableBorder.all(
                              color: Colors.black.withOpacity(1),
                              width: 0.5,
                            ),
                            columnWidths: const {
                              0: FixedColumnWidth(85),
                              1: FixedColumnWidth(85),
                              2: FixedColumnWidth(85),
                              3: FixedColumnWidth(90),
                              4: FixedColumnWidth(105),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                ),
                                children: [
                                  HeaderWidget(text: 'Date'),
                                  HeaderWidget(text: 'Time In'),
                                  HeaderWidget(text: 'Time Out'),
                                  HeaderWidget(text: 'Hrs Rendered'),
                                  HeaderWidget(text: 'Remarks'),
                                ],
                              ),
                              ...state.dtr.map((dtr) {
                                return TableRow(
                                  children: [
                                    CellWidget(
                                      text: DateFormat('yyyy-MM-dd').format(
                                        DateTime.parse(
                                          dtr.date.toString(),
                                        ),
                                      ),
                                    ),
                                    CellWidget(
                                      text: dtr.timeIn.toString(),
                                    ),
                                    CellWidget(
                                      text: dtr.timeOut.toString(),
                                    ),
                                    CellWidget(
                                      text: dtr.hoursRendered.toString(),
                                    ),
                                    CellWidget(text: dtr.remarks.toString()),
                                  ],
                                );
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: FloatingActionButton(
                        backgroundColor: ColorPalette.primary,
                        onPressed: () {
                          generatePdf(state.dtr);
                        },
                        tooltip: 'Generate PDF',
                        child: const Icon(
                          Icons.file_download_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return LoadingCircular();
            }
          },
        ),
      ),
    );
  }
}
