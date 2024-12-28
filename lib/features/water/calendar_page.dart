import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrate/core/domain/water_cubit/water_cubit.dart';
import 'package:hydrate/core/domain/water_cubit/water_cubit_state.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  static const String path = '/calendar';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Water Calendar',
          style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 102, 242, 252),
      ),
      body: Column(
        children: [
          BlocBuilder<WaterCubit, WaterCubitState>(
            builder: (context, state) {
              return TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: DateTime.now(),
                onDaySelected: (selectedDay, focusedDay) {
                  context.read<WaterCubit>().loadDrinksForDate(selectedDay);
                },
                calendarStyle: CalendarStyle(
                  todayTextStyle: GoogleFonts.roboto(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  todayDecoration: const BoxDecoration(
                    color: Colors.lightBlueAccent,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: const BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: GoogleFonts.roboto(fontSize: 16),
                ),
                headerStyle: HeaderStyle(
                  titleTextStyle: GoogleFonts.poppins(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  formatButtonTextStyle: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<WaterCubit, WaterCubitState>(
              builder: (context, state) {
                if (state is WaterCubitLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WaterCubitDateLoaded) {
                  if (state.drinks.isEmpty) {
                    return Center(
                      child: Text(
                        'No data for ${state.date.day}/${state.date.month}/${state.date.year}',
                        style: GoogleFonts.roboto(
                            fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: state.drinks.length,
                    itemBuilder: (context, index) {
                      final drink = state.drinks[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Water Intake:',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'You drank ${drink.amountTaken} ml',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Time: ${drink.dateAndTime.hour}:${drink.dateAndTime.minute}',
                                style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is WaterCubitError) {
                  return Center(
                    child: Text(
                      state.error,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  );
                }
                return Center(
                  child: Text(
                    'Select a date.',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueGrey,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
