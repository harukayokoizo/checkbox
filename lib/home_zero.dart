import 'package:checkbox_app/content_detail.dart';
import 'package:flutter/material.dart';
import 'package:checkbox_app/form_page.dart';
import 'package:checkbox_app/model/model.dart';
import 'package:checkbox_app/database_helper.dart';
import 'package:checkbox_app/home.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:intl/date_symbol_data_local.dart';

class MyWidgetZero extends StatefulWidget {
  ///final List<Model> titles;

  ///{}をつけた理由は引数がない時に呼び出しできるようにするため
  ///MyWidget({this.titles});
  @override
  _MyHomePageStateZero createState() => new _MyHomePageStateZero();
}

class _MyHomePageStateZero extends State<MyWidgetZero> {
  double countd;
  var count = 0;
  int countItem;
  int maincount;
  int maxItem;
  Future<List<Model>> db;
  List list1 = [];
  int number;
  ///List<String> titleList = ['仕事', '買い物'];
  /*addTitle(Model model){
    setState(() {
      titleList.add(model);
    });
  }*/

  void set(){
    setState(() {

    });
  }

  Future<int> maxId() async {
    DatabaseHelper _dbHelper = DatabaseHelper();
    maxItem = await _dbHelper.getMaxId();

    if(maxItem == null){
      maxItem = 0;
      return maxItem;
    }
    return maxItem;
  }

  ///DBのテーブルにあるレコードの数を取得する。
  Future<List> itemCount() async {
    DatabaseHelper _dbHelper = DatabaseHelper();

    ///返り値int型
    countItem = await _dbHelper.getCount();
    countd = countItem / 4;
    print(countd);
    ///実数
    ///1.5なら四捨五入されて2になる
    count = countItem ~/ 4;
    print(count.toDouble());
    ///整数

    ///1.25 != 1.00
    if (count.toDouble() < countd && countd < count.toDouble()+1) {
      count = count + 1;
    } else {
      count = count;
    }

    List list = List.generate(count, (int index)=> index * 4);
    return list;

  }
 /*
  List<MyWidget> loopMyWidget(List list) {
    ///itemCount();
    ///list1 = listgene();
    ///print(list1);
    ///number = itemCount() as int;
    return List.generate(list.length, (index){
      ///取得した順番にmodelの引数にして返す
      return MyWidget(id: list[index], function: set,);
    });
  }*/

  List<MyWidget> getMyTask(List list){
    final chunkItems = [];
    final chunkSize = 4;
    var number = 0;
    print(list);

    do{
      chunkItems.add(list.skip(number).take(chunkSize).toList());
      number += chunkSize;
    }while(number < list.length);

    print(chunkItems);///[[1,2,3,4],[5,6,7,8]]
    print(chunkItems.length);
    return List.generate(chunkItems.length, (index){
      ///取得した順番にmodelの引数にして返す
      return MyWidget(list2: chunkItems[index], function: set,);
    });

  }



  @override
  Widget build(BuildContext context) {
    DatabaseHelper _dbHelper = DatabaseHelper();
    maxId();
    ///itemCount();
    ///addTitle(_title);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Center(
          child: Text(
            "TODOメモリスト",
            style: TextStyle(
                color: Colors.black,
                fontSize: 25.0,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          height: 630,
          width: 370,
          color: Colors.blueGrey,
          child: FutureBuilder(
                initialData: [],
                future: _dbHelper.getTitle(),
                ///futureでセットしたメソッドがreturnしてくれる値をsnapshot.dataで取得できる。
               ///AsyncSnapshot(ConnectionState.done, data, null, null) snapshot.dataはAsyncSnapshotのdataの部分を表す
                builder:(context, snapshot){
                  if (snapshot.hasData) {
                    print(snapshot);
                    return PageView(
                      children: getMyTask(snapshot.data)
                    );
                  } else {
                    return Text("データが存在しません");
                  }
                },
              ),
            ///children: loopMyWidget(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.orangeAccent,
          onPressed: ()async{

            DatabaseHelper _dbHelper = DatabaseHelper();
            initializeDateFormatting('ja_JP');
            DateTime datetime = DateTime.now();
            var formatter = new DateFormat('yyyy/MM/dd(E) HH:mm');
            String date = formatter.format(datetime.toLocal());

            print(date);
            Model model = Model(id: maxItem + 1, title: null, taskId: maxItem + 1, modifiedDate: date);
            await _dbHelper.insertTask(model);


            /**
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => FormPageWidget(model: model),
              ),
            );**/
            set();
          }
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
///title == null ? Container():
}


