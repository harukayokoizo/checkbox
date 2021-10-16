import 'package:flutter/material.dart';
import 'package:checkbox_app/form_page.dart';
import 'package:checkbox_app/model/model.dart';

class MyWidgetSecond extends StatefulWidget {

  @override
  _MyHomePageStateSec createState() => new _MyHomePageStateSec();
}

class _MyHomePageStateSec extends State<MyWidgetSecond> {
  List<Model> titles;
  ///List<String> titleList = ['仕事', '買い物'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Boxer"),
      ),
      body: Text('harukayokomizo'),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FormPageWidget(),
              ),
            );
          }
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}