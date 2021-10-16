import 'package:checkbox_app/database_helper.dart';
import 'package:checkbox_app/home_zero.dart';
import 'package:checkbox_app/widget/cheetah_button.dart';
import 'package:checkbox_app/widget/cheetah_input.dart';
import 'package:flutter/material.dart';
import 'package:checkbox_app/model/model.dart';
import 'model/todo.dart';
import 'package;checkbox_app/widget/cheetah_input.dart';
import 'package;checkbox_app/widget/cheetah_button.dart';
import 'package:checkbox_app/home.dart';
import 'package:checkbox_app/widget/todo_field.dart';


///StatefulWidgetはbuildメソッドを持たない
///StatefulWidgetはcreateStateメソッドを持ち、これがStateクラスを返す
class FormPageWidget extends StatefulWidget {
  ///titleとtodoのIdが一緒になるように
  Model model;

  FormPageWidget({this.model});
  @override
  FormPage createState() => new FormPage();
}

///StateクラスはBuildメソッドを持ち、Widgetを返す時に定義したメソッドをアクションとして組み込まれる
class FormPage extends State<FormPageWidget>{
  @override
  String todo = "";
  bool _flag = false;
  ///タイトルの変数定義
  String _title;
  int todoId;
  int number = 0;
  int _taskId;
  int _taskIdOfTask;


  @override
  ///クラスのコンストラクタが呼び出されたあと、すぐにこのinitStateが呼ばれる。最初に一度だけ実行される。
  void initState(){
    if(widget.model != null){
      _taskId = widget.model.id;
      _title = widget.model.title;
      _taskIdOfTask = widget.model.taskId;
      print(_taskId);
      print(_title);
      print(_taskIdOfTask);
    }
    super.initState();
  }

  ///プラスボタンを押したときに呼び出されるメソッド
  void count(){
    setState(() {
      number++;
    });
    print(number);
  }

  ///グローバルキーの変数宣言
  ///バリデーションエラーを表示するために必要
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: Text(
            '作成',
            style: TextStyle(
              color: Colors.white,  ///文字の色を白にする
              fontWeight: FontWeight.bold,  ///文字を太字する
              fontSize: 12.0,  ///文字のサイズを調整する
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
           child: Column(
              children: [
                TextFormField(
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold
                  ),
                  ///テキストフィールドの装飾
                  decoration: InputDecoration(
                    ///フィールドの中の色
                    fillColor: Colors.white,
                    filled: true,
                    ///アウトラインを引く
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),
                  ///Enterキーを押したときに動作すること
                  onFieldSubmitted: (value) async{
                    DatabaseHelper _dbHelper = DatabaseHelper();
                    ///Enterキーを押したときにvalue値が空白じゃなければ
                    if(value != ""){
                      ///元々入力されている値がないときがない
                      if(_title == null){
                        await _dbHelper.updateTaskTitle(_taskId, value);
                        print("Update the exisiting task");
                        ///元々入力されている値があるときそのデータを編集する
                      }else{
                        await _dbHelper.updateTaskTitle(_taskId, value);
                        print("Update the exisiting task");
                      }
                    }else{
                      await _dbHelper.updateTaskTitle(_taskId, value);
                      print("Update the exisiting task");
                    }
                  },
                ),
                TodoFieldWidget(todoId: _taskIdOfTask, taskText: null, isDone: 0),
                ///プラスボタンを押したときに表示する
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: number,
                  itemBuilder: (context, index) {
                    return TodoFieldWidget(
                      todoId: _taskIdOfTask,
                      taskText: null,
                      isDone: 0,
                    );
                  },
                ),
                Row(
                  children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, left:150.0),
                        ///プラスボタン
                        child: RaisedButton(
                          child: Icon(
                              Icons.add,
                              size: 40.0,
                          ),
                            onPressed: (){
                              count();
                            }
                        ),
                      ),
                  ]
                ),
              ],
            ),
         )
      ),
    );
  }
}
