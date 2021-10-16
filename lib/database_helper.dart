import 'package:path/path.dart';
import 'package:checkbox_app/model/model.dart';
import 'package:checkbox_app/model/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DatabaseHelper{
  ///データベースに接続する
  Future<Database> database() async{
    ///openDatabaseでデータベースと接続する
    return openDatabase(
      ///getdatabasepath()でデータベースファイルを保存するパスを取得する
      join(await getDatabasesPath(), 'checkbox12.db'),
      onCreate: (db, version) async{
        ///Create文を実行する
        await db.execute(
          "CREATE TABLE memo(id INTEGER PRIMARY KEY, title TEXT, taskId INTEGER, modified_date Text)",
        );

        await db.execute(
          "CREATE TABLE todo(id INTEGER PRIMARY KEY, text TEXT, modelId INTEGER, isDone INTEGER)",
        );

        return db;
      },
      version: 1,
    );
  }
  ///データベースにデータをinsertする
  Future<void> insertTask(Model model) async{
    Database _db = await database();
    await _db.insert(
      ///対象のデータベース名
        'memo',
        ///保存するデータのマップ
        model.toMap(),
        ///コンフリクト時のアルゴリズムの指定
        ///INSERTやUPDATEのときにConflict(衝突)が発生したらどのように振る舞うかを定義しておくことができる機能
        ///replaceはSQLステートメントと競合している対象レコードを削除し、SQLステートメントを実行します。
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  ///データベースにデータをinsertする
  Future<void> insertTodo(Todo todo) async{
    Database _db = await database();
    await _db.insert(
      ///対象のデータベース名
        'todo',
        ///保存するデータのマップ
        todo.toMap(),
        ///コンフリクト時のアルゴリズムの指定
        ///INSERTやUPDATEのときにConflict(衝突)が発生したらどのように振る舞うかを定義しておくことができる機能
        ///replaceはSQLステートメントと競合している対象レコードを削除し、SQLステートメントを実行します。
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }


  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE memo SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTodo(int id, String text) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET text = '$text' WHERE id = '$id'");
  }

  Future<void> updateCheck(int id, int isDone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isDone = '$isDone' WHERE id = '$id'");
  }

  ///データベースからデータを取得する
  Future<List<Model>> getTasks(int id) async{
    Database _db = await database();
    id = id + 1;
    int id2 = id + 3;
    ///memoのデータベースから全件のデータを取得する、今回は検索条件はない
    List<Map<String, dynamic>> taskMap1 = await _db.rawQuery("SELECT * FROM memo WHERE id BETWEEN '$id' AND '$id2'");
    ///generateの第一引数はmemoテーブルのレコードの数、第二引数は番号
      return List.generate(taskMap1.length, (index){
        ///取得した順番にmodelの引数にして返す
        return Model(
            id:taskMap1[index]['id'],
            title:taskMap1[index]['title'],
            taskId:taskMap1[index]['taskId'],
        );
    });
  }

  Future<List> getTitle() async{
    List list = [];
    Database _db = await database();
    List<Map<String, dynamic>> taskMap2 = await _db.rawQuery("SELECT id FROM memo ORDER BY modified_date DESC");
    ///generateの第一引数はmemoテーブルのレコードの数、第二引数は番号
    print(taskMap2);

    for(var lis in taskMap2){
      list.add(lis['id']);
    }
    print(list);
    return list;
  }

  Future<List<Model>> get(List list) async{
    print(list.length);
    int j = 0;
    int id1,id2,id3,id4;
    for(var i in list){
      if(j == 0){
        id1 = i;
        j++;
      }else if(j == 1){
        id2 = i;
        j++;
      }else if(j == 2){
        id3 = i;
        j++;
      }else if(j == 3){
        id4 = i;
        j++;
      }
    }

    Database _db = await database();
      ///memoのデータベースから全件のデータを取得する、今回は検索条件はない
      List<Map<String, dynamic>> taskMap3 = await _db.rawQuery("SELECT * FROM memo WHERE id IN('$id1','$id2','$id3','$id4') ORDER BY modified_date DESC");

    print(taskMap3);

      return List.generate(taskMap3.length, (index){
        ///取得した順番にmodelの引数にして返す
        return Model(
          id:taskMap3[index]['id'],
          title:taskMap3[index]['title'],
          taskId:taskMap3[index]['taskId'],
        );
      });

    ///generateの第一引数はmemoテーブルのレコードの数、第二引数は番号

  }

  Future<List<Todo>> getTodo(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery("SELECT * FROM todo WHERE modelId = $taskId");
    return List.generate(todoMap.length, (index) {
      return Todo(id: todoMap[index]['id'], text: todoMap[index]['text'], modelId: todoMap[index]['modelId'], isDone: todoMap[index]['isDone']);
    });
  }

  ///データベースからデータの長さを取得する
  Future<int> getCount() async{
    Database _db = await database();
    ///memoのデータベースからレコードの数を取得する
    var taskCount = await _db.rawQuery("SELECT COUNT(*) FROM memo");
    print(taskCount);
    ///クエリの最初のint値を取得する。COUNT(*)で有用
    int count = Sqflite.firstIntValue(taskCount);
    print(count);
    return count;
  }

  Future<int> getMaxId() async{
    Database _db = await database();
    ///memoのデータベースからレコードの数を取得する
    var maxId = await _db.rawQuery("SELECT MAX(id) FROM memo");
    print(maxId);
    ///クエリの最初のint値を取得する。COUNT(*)で有用
    int count = Sqflite.firstIntValue(maxId);
    print(count);
    return count;
  }

  Future<int> getMaxTodoId() async{
    Database _db = await database();
    ///memoのデータベースからレコードの数を取得する
    var maxId = await _db.rawQuery("SELECT MAX(id) FROM todo");
    print(maxId);
    ///クエリの最初のint値を取得する。COUNT(*)で有用
    int count = Sqflite.firstIntValue(maxId);
    print(count);
    return count;
  }

  Future<void> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM memo WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE modelId = '$id'");
    ///もう一つ追加
    ///await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
  }

  Future<void> deleteTodo(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM todo WHERE id = '$id'");
    ///もう一つ追加
    ///await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
  }

  Future<void> deleteTodo2() async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM todo WHERE text is Null");
    ///もう一つ追加
    ///await _db.rawDelete("DELETE FROM todo WHERE taskId = '$id'");
  }
}