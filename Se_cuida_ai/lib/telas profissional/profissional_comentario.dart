import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class comentarios extends StatefulWidget {

  @override
  _comentariosState createState() => _comentariosState();
}

class _comentariosState extends State<comentarios> {
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
