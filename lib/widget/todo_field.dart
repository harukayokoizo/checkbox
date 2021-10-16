import 'package:checkbox_app/database_helper.dart';
import 'package:checkbox_app/model/todo.dart';
import 'package:flutter/material.dart';

typedef parentFunctionCallback= void Function(String value);
class TodoFieldWidget extends StatefulWidget{
  int todoId;
  String taskText;
  int isDone;

  TodoFieldWidget({this.todoId, this.taskText, this.isDone});

  @override
  TodoField createState() => new TodoField();
}

class TodoField extends State<TodoFieldWidget>{
  bool _flag;
  int _todoId;
  String _taskText;
  int _isDone;

  ///最初に実行されるもの
  @override
  void initState() {
    _todoId = widget.todoId;
    _taskText = widget.taskText;
    if(widget.isDone == 0){
      _flag = false;
    }else{
      _flag = true;
    }
    print(_flag);
    print(_todoId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseHelper _dbHelper = DatabaseHelper();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          children: <Widget>[
            ///チェックボックスを表示する
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Column(
                children: <Widget>[
                  new Checkbox(
                    activeColor: Colors.blue,
                    ///チェックボックスの値false
                    value: _flag,
                    onChanged: (bool value) async{
                      ///setStateはその状態が変化したことを教えて画面の再描画を依頼する
                      setState(() {
                        _flag = value;
                        if(_flag == true){
                          widget.isDone = 1;
                        }else{
                          widget.isDone = 0;
                        }
                      });

                      await _dbHelper.updateCheck(widget.todoId, widget.isDone);
                    },
                  ),
                ]
              ),
            ),
            Expanded(
                child: Column(
                  children: <Widget>[
                    new TextFormField(
                      style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                      ///todoの内容を表示する。
                      controller: TextEditingController()..text = _taskText,

                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        ///アウトラインを引く
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        ///hintText: 'テキストを入力してください。'
                      ),
                      ///Enterを押したときの挙動
                      onFieldSubmitted: (value) async{
                        print(_taskText);
                        ///Enterを押したときにvalue値が空白でなければ
                        if(value != ""){
                          ///Enterを押したときにtodoがnullの時insertする
                          if(_taskText == null){
                            await _dbHelper.updateTodo(_todoId, value);
                            _taskText = value;
                            print("Update the exisiting task");
                            ///Enterを押したときにtodoが入力されているとき時updateする
                          }else{
                            await _dbHelper.updateTodo(_todoId, value);
                            _taskText = value;
                            print("Update the exisiting task");
                          }
                        }else{
                          await _dbHelper.updateTodo(widget.todoId, "");
                          _taskText = "";
                          print("Update the exisiting task");
                        }
                      },

                    ),
                  ],
                )
            ),
          ],
        ),
    );
  }
}