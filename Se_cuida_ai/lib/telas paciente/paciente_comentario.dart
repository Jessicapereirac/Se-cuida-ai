import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class comentar extends StatefulWidget {

  @override
  _comentarState createState() => _comentarState();
}

class _comentarState extends State<comentar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text("Se cuida aí"),
        ),
        body:Container(
          color: Colors.red,
        )
    );
  }
}
