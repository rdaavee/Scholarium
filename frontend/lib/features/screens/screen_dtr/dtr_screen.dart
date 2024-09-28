import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/implementations/student_repository_impl.dart';
import 'package:isHKolarium/api/models/dtr_model.dart';
import 'package:isHKolarium/blocs/bloc_dtr/dtr_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/app_bar.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/your_dtr_card.dart';
import 'package:isHKolarium/features/widgets/student_widgets/dtr_widgets/your_dtr_hours_card.dart';
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

  Future<void> generatePdf(List<DtrModel> dtrList) async {
    final pdfDocument = pw.Document();

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
            data: dtrList.map((dtr) {
              return [
                dtr.date,
                dtr.timeIn,
                dtr.timeOut,
                dtr.hoursRendered.toString(),
                dtr.professor,
                dtr.professorSignature,
              ];
            }).toList(),
          ),
        ],
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfDocument.save(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download Completed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DtrBloc>(create: (context) => dtrBloc),
      ],
      child: BlocConsumer<DtrBloc, DtrState>(listener: (context, state) {
        if (state is DtrErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      }, builder: (context, state) {
        print('Building UI with state: $state');
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
              backgroundColor: ColorPalette.accent,
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
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  YourDtrCard(
                                    date: DateTime.parse(
                                        "2024-08-27T16:00:00.000Z"),
                                    timeIn: dtr.timeIn.toString(),
                                    timeOut: dtr.timeOut.toString(),
                                    hoursRendered: dtr.hoursRendered.toString(),
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
      }),
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
