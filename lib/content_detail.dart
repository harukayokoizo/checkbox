import 'package:checkbox_app/home.dart';
import 'package:checkbox_app/home_zero.dart';
import 'package:checkbox_app/widget/cheetah_button.dart';
import 'package:checkbox_app/widget/cheetah_input.dart';
import 'package:checkbox_app/widget/todo_field.dart';
import 'package:flutter/material.dart';
import 'package:checkbox_app/database_helper.dart';

import 'model/model.dart';
import 'model/todo.dart';

class TaskDetail extends StatefulWidget {
  Model task;
  int id;

  TaskDetail({@required this.task});
  ///{}をつけた理由は引数がない時に呼び出しできるようにするため

  _Detail createState() => new _Detail();
}

class _Detail extends State<TaskDetail>{
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String _taskTitle = "";
  bool _flag = false;
  String todo = "";
  String _title;
  int _taskIdOfTask;
  int _isDone;
  int maxTodoItem;
  int number = 0;
  ///List[1]<'id':id,'text': text,'modelId': modelId,>
  ///List[2]<'id':id,'text': text,'modelId': modelId,>
  Future<List<Todo>> todoData;

  FocusNode _titleFocus;

  ///プラスボタンを押したときに呼び出される
  void set(){
    setState(() {});
  }

  Future<int> maxTodoId() async {
    DatabaseHelper _dbHelper = DatabaseHelper();
    maxTodoItem = await _dbHelper.getMaxTodoId();

    if(maxTodoItem == null){
      maxTodoItem = 0;
      return maxTodoItem;
    }
    return maxTodoItem;
  }

  Future<int> deleteTodo(todo)async{
    DatabaseHelper _dbHelper = DatabaseHelper();
    await _dbHelper.insertTodo(todo);
  }


  ///グローバルキーの変数宣言
  ///バリデーションエラーを表示するために必要
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  ///クラスのコンストラクタが呼び出されたあと、すぐにこのinitStateが呼ばれる。最初に一度だけ実行される。
  void initState(){
    print("ID: ${widget.task.id}");
    if(widget.task != null){
      _taskId = widget.task.id;
      _taskIdOfTask = widget.task.taskId;
      print(_taskIdOfTask);
    }
    super.initState();
  }

  Widget build(BuildContext context){
    maxTodoId();
    ///todoData = _dbHelper.getTodo(_taskIdOfTask);
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          child: Text(
            'back',
            style: TextStyle(
              color: Colors.white,  ///文字の色を白にする
              fontWeight: FontWeight.bold,  ///文字を太字する
              fontSize: 12.0,  ///文字のサイズを調整する
            ),
          ),
          onPressed: ()async{
            await _dbHelper.deleteTodo2();
            Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => MyWidgetZero(),
                )
            );
          },
        ),
      ),
       ///画面に入りきらない表示をスクロールさせたい時に使うWidget
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 50.0, left: 20, right: 20, bottom: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 20.0,fontWeight: FontWeight.bold),
                  ///タイトルを表示する
                  controller: TextEditingController()..text = widget.task.title,
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
                  ///Enterキーを押したときにvalue値が空白じゃなければ
                    if(value != ""){
                      ///元々入力されている値がないときがない
                      if(widget.task.title == null){
                        await _dbHelper.updateTaskTitle(_taskId, value);
                        widget.task.title = value;
                      ///元々入力されている値があるときそのデータを編集する
                      }else{
                        await _dbHelper.updateTaskTitle(_taskId, value);
                        widget.task.title = value;
                        print("Update the exisiting task");
                      }
                    }else{
                      await _dbHelper.updateTaskTitle(_taskId, "");
                      widget.task.title = value;
                    }
                  },
              ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: FutureBuilder(
                    initialData: [],
                    ///同じフィールドで作成したコンテンツの_タイトルのtaskIdとTODOのmodelIdは同じである。
                    future: _dbHelper.getTodo(_taskIdOfTask),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                          ///スクロールの向きが縦である。
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            final todo = snapshot.data[index];
                            ///横にスクロールできるWidget
                            return  TodoFieldWidget(
                                  todoId: snapshot.data[index].id,
                                  taskText: snapshot.data[index].text,
                                  isDone: snapshot.data[index].isDone,
                              );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    ///プラスボタン
                    child: RaisedButton(
                        child: Icon(
                          Icons.add,
                          size: 40.0,
                        ),
                        onPressed: ()async{
                          Todo todo = Todo(id: maxTodoItem + 1, text: null, modelId: _taskIdOfTask, isDone: 0);
                          await _dbHelper.insertTodo(todo);
                          set();
                          ///_count();
                        }
                    ),
                  ),
              ],
            ),
          )
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.close),
          backgroundColor: Colors.red,
          onPressed: () async{
            if(_taskId != 0){
              ///タスクを削除する
              await _dbHelper.deleteTask(_taskId);
            }
            Navigator.of(context).pop(

            );
          }
      ),
    );
  }
}