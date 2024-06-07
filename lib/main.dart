import 'package:flutter/material.dart';
import 'package:mood_diary/app_style/colors.dart';
import 'package:mood_diary/models/person_mood.dart';
import 'package:provider/provider.dart';

import 'screens/calendar/calendar_screen.dart';
import 'screens/main_screen/main_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    Stream<DateTime> dateTimeNow =
        Stream<DateTime>.periodic(const Duration(seconds: 10), (_) {
      return DateTime.now();
    });
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PersonMood(),
        ),
        StreamProvider<DateTime>(
          create: (_) => dateTimeNow,
          initialData: DateTime.now(),
        )
      ],
      child: MaterialApp(
        color: AppColors.lightBackground,
        routes: {
          '/': (context) => const MainScreen(),
          '/calendar': (context) => const CalendarScreen(),
        },
        initialRoute: '/',
      ),
    );
  }
}
