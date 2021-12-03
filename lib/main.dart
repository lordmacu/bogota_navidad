import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navidad_bogota/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            bodyText1: TextStyle(
                color: Colors.white
            ),
            bodyText2: TextStyle(
                color: Colors.white

            ),
          ),
          color: Colors.transparent
        ),
           buttonTheme: ButtonThemeData(


             textTheme: ButtonTextTheme.primary,
            buttonColor: Color(0xfff8ac23),

                shape: RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(50)
                )
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: Colors.white
            ),
            bodyText2: TextStyle(
                color: Colors.white

            ),
          ),
        scaffoldBackgroundColor: const Color(0xff202834),
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

