import 'dart:convert';

class Model{
  int id;
  String title;
  int taskId;
  String modifiedDate;

  ///コンストラクタが最初に実行される
  ///{}があることで、呼び出される際に引数がなくても実行できる
  Model({this.id, this.title, this.taskId, this.modifiedDate});

  ///Map化して保存する
  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'title': title,
      'taskId': taskId,
      'modified_date' : modifiedDate,
    };
  }
}