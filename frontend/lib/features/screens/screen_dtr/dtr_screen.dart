import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isHKolarium/api/api_service/api_service.dart';
import 'package:isHKolarium/blocs/bloc_dtr/dtr_bloc.dart';
import 'package:isHKolarium/config/constants/colors.dart';
import 'package:isHKolarium/features/widgets/dtr_card.dart';
import 'package:isHKolarium/features/widgets/dtr_hours_card.dart';
import 'package:isHKolarium/features/widgets/your_dtr_card.dart';
import 'package:isHKolarium/features/widgets/your_dtr_hours_card.dart';

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
    final apiService = ApiService();
    dtrBloc = DtrBloc(apiService);
    dtrBloc.add(FetchDtrEvent());
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
            backgroundColor: ColorPalette.primary,
            body: Column(
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_sharp,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Container(
                        height: 100.0,
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          "DTR",
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.1,
                            color: ColorPalette.accentWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0F3F4),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: ListView.builder(
                        itemCount: state.dtr.length,
                        itemBuilder: (context, index) {
                          final dtr = state.dtr[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  YourDtrHoursCard(
                                    progress: (state.hours[0].totalhours /
                                            state.hours[0].targethours)
                                        .clamp(0.0, 1.0),
                                    cardColor: Colors.white,
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 0.1,
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  YourDtrCard(
                                    date: DateTime.parse(
                                        "2024-08-27T16:00:00.000Z"),
                                    timeIn: dtr.timeIn.toString(),
                                    timeOut: dtr.timeOut.toString(),
                                    hoursToRendered:
                                        dtr.hoursToRendered.toString(),
                                    hoursRendered: dtr.hoursRendered.toString(),
                                    teacher: dtr.teacher.toString(),
                                    teacherSignature:
                                        dtr.teacherSignature.toString(),
                                    cardColor: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
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
}
