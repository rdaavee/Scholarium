import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/blocs/bloc_dtr/dtr_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/your_dtr_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/your_dtr_hours_card.dart';
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DtrScreen extends StatefulWidget {
  const DtrScreen({super.key});

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
    dtrBloc.add(FetchDtrEvent());
  }

  Future<pw.ImageProvider> fetchImage(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return pw.MemoryImage(response.bodyBytes);
    } else {
      throw Exception('Failed to load image from $url');
    }
  }

  Future<void> generatePdf(List<DtrModel> dtrList) async {
    final pdfDocument = pw.Document();

    final List<List<dynamic>> tableData = [];

    for (var dtr in dtrList) {
      String formattedTimeIn = formatTimeToAmPm(dtr.timeIn.toString());
      String formattedTimeOut = formatTimeToAmPm(dtr.timeOut.toString());

      // Fetch the image asynchronously
      final imageProvider = await fetchImage(dtr.professorSignature.toString());

      tableData.add([
        dtr.date,
        formattedTimeIn,
        formattedTimeOut,
        dtr.hoursRendered.toString(),
        dtr.professor,
        imageProvider,
      ]);
    }

    pdfDocument.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'DTR Report',
              style: const pw.TextStyle(fontSize: 24),
            ),
          ),
          pw.TableHelper.fromTextArray(
            headers: [
              'Date',
              'Time In',
              'Time Out',
              'Hours Rendered',
              'Professor',
              'Professor Signature',
            ],
            data: tableData.map((row) {
              return [
                row[0],
                row[1],
                row[2],
                row[3],
                row[4],
                pw.Container(
                  child: pw.Image(row[5]), 
                  width: 50, 
                  height: 50,
                ),
              ];
            }).toList(),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfDocument.save(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download Completed')),
    );
  }

  String formatTimeToAmPm(String time) {
    DateTime dateTime = DateFormat('HH:mm:ss').parse(time);
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DtrBloc>(create: (context) => dtrBloc),
      ],
      child: BlocConsumer<DtrBloc, DtrState>(
        listener: (context, state) {
          if (state is DtrErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is DtrLoadingState) {
            return const Scaffold(
              backgroundColor: ColorPalette.accent,
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (state is DtrLoadedSuccessState) {
            return Scaffold(
              backgroundColor: ColorPalette.primary.withOpacity(0.9),
              appBar: const AppBarWidget(title: "DTR", isBackButton: true),
              floatingActionButton: FloatingActionButton(
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
              body: Column(
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
                            padding: const EdgeInsets.all(8.0),
                            child: YourDtrHoursCard(
                              progress: (state.hours[0].totalhours /
                                      state.hours[0].targethours)
                                  .clamp(0.0, 1.0),
                              cardColor: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Table(
                                border: TableBorder.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                                columnWidths: const {
                                  0: FixedColumnWidth(100),
                                  1: FixedColumnWidth(100),
                                  2: FixedColumnWidth(100),
                                  3: FixedColumnWidth(120),
                                },
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                    ),
                                    children: [
                                      _buildHeader('Date'),
                                      _buildHeader('Time In'),
                                      _buildHeader('Time Out'),
                                      _buildHeader('Hours Rendered'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: state.dtr.length,
                              itemBuilder: (context, index) {
                                final dtr = state.dtr[index];
                                String formattedTimeIn =
                                    formatTimeToAmPm(dtr.timeIn.toString());
                                String formattedTimeOut =
                                    formatTimeToAmPm(dtr.timeOut.toString());
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    YourDtrCard(
                                      date: DateTime.parse(dtr.date.toString()),
                                      timeIn: formattedTimeIn,
                                      timeOut: formattedTimeOut,
                                      hoursRendered:
                                          dtr.hoursRendered.toString(),
                                      cardColor: Colors.white,
                                    ),
                                    const Divider(
                                      thickness: 0.1,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Manrope',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
