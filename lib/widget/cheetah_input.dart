import 'package:flutter/material.dart';

class CheetahInput extends StatelessWidget {
  final String labelText;
  final Function onSaved;

  CheetahInput({@required this.labelText, @required this.onSaved,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      ///テキストフィールドの装飾
      decoration: InputDecoration(
        ///フィールドの中の色
        fillColor: Colors.white,
        filled: true,
        labelText: labelText,
        ///アウトラインを引く
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),


      initialValue: '',
      validator: (String value) {
        ///値が何もないとき
        if (value.isEmpty) {
          ///Name is required
          return '$labelText is required';
        }

        return null;
      },
      onSaved: onSaved,
    );
  }
}
