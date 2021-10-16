import 'package:checkbox_app/content_detail.dart';
import 'package:checkbox_app/home_zero.dart';
import 'package:flutter/material.dart';
import 'package:checkbox_app/form_page.dart';
import 'package:checkbox_app/model/model.dart';
import 'package:checkbox_app/database_helper.dart';

class MyWidget extends StatefulWidget {
  int id;
  int id2;
  Function function;
  List list2;

  ///{}をつけた理由は引数がない時に呼び出しできるようにするため
  MyWidget({this.list2, this.function});
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyWidget> {
  int countItem;
  Future<List<Model>> db;

  _MyHomePageState();


  @override
  Widget build(BuildContext context) {
    DatabaseHelper _dbHelper = DatabaseHelper();
    ///itemCount();
    ///addTitle(_title);
    return FutureBuilder(
        initialData: [],
        future: _dbHelper.get(widget.list2),
        ///futureでセットしたメソッドがreturnしてくれる値をsnapshot.dataで取得できる。
        builder:(context, snapshot){
          print(snapshot);
          print(snapshot);
          ///自動でListを表示する。
         return ListView.builder(
            ///ListViewで使われるもので、スクロールできるようになる
            shrinkWrap: true,
            ///itemの数だけListを表示する
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index){
              return Column(
                children: <Widget>[
                  Divider(height: 40,),
                  Card(
                    color: Colors.white,
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Container(
                      height: 100,
                      width: 300,
                      child: ListTile(
                        ///leading: Icon(Icons.vpn_key),
                        ///titleがnull(何も入力されていない)時"新規メモ"を表示する。
                        title: Text(
                          snapshot.data[index].title ?? "新規メモ",
                          style: TextStyle(color: Colors.black, fontSize: 20.0,fontWeight: FontWeight.bold),
                        ),
                        onTap: () async{
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => TaskDetail(task: snapshot.data[index]),
                            ),
                          );
                          widget.function();
                        },
                      ),
                    ),
                  ),
                ],
              );
            }
          );
        },
      );
  }
  ///title == null ? Container():
}