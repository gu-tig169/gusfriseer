import 'package:flutter/material.dart';

class SecondView extends StatefulWidget {
  @override
  _SecondViewState createState() => _SecondViewState();
}

class _SecondViewState extends State<SecondView> {
  final TextEditingController userInputController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add something to your list!'),
          centerTitle: true,
        ),
        body: Column(children: [
          TextField(
            controller: userInputController,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter something to do'),
          ),
          RaisedButton(
            onPressed: () {
              if (userInputController.text != '' &&
                  userInputController.text != null) {
                Navigator.pop(context, userInputController.text);
              }
            },
            child: const Text('Add', style: TextStyle(fontSize: 20)),
            color: Colors.green,
            splashColor: Colors.white,
          ),
        ]));
  }
}
