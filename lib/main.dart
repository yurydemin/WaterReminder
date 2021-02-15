import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_reminder/providers/drink_water_provider.dart';
import 'package:water_reminder/views/home_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DrinkWaterProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Water Reminder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => HomeView(),
        },
      ),
    );
  }
}
