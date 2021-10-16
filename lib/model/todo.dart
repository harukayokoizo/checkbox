class Todo{
  int id;
  String text;
  int modelId;
  int isDone;

  ///コンストラクタが最初に実行される
  ///{}があることで、呼び出される際に引数がなくても実行できる
  Todo({this.id, this.text, this.modelId, this.isDone});

  ///Map化して保存する
  Map<String, dynamic> toMap(){
    return{
      'id':id,
      'text': text,
      'modelId': modelId,
      'isDone' : isDone,
    };
  }
}