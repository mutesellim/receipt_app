import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cook_book/home_page.dart';
import 'package:flutter_cook_book/receipt_list.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Cook Book",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomePage(myOtherStorage: MyOtherStorage()),
    );
  }
}
