import 'package:checkbox_app/home2.dart';
import 'package:flutter/material.dart';
import 'package:checkbox_app/home_zero.dart';
import 'package:checkbox_app/form_page.dart';
import 'package:checkbox_app/model/model.dart';
///import 'package:flutter_stetho/flutter_stetho.dart';
///import 'package:provider/provider.dart';

///コンテンツ一覧ページ
void main() {
  ///Stetho.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.white70,
      ),
      home: MyWidgetZero(),
    );
  }
}


