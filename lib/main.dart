import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage()));
}

//testingcommit
class FilterOptions {
  static const String All = 'All';
  static const String Done = 'Done';
  static const String NotDone = 'Not Done';

  static const List<String> choices = <String>[All, Done, NotDone];
}

class Item {
  int id;
  String value;
  bool status;
  Item(this.id, this.value, this.status);
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _information = '';

  List<Item> toDoList = [];
  List<Item> filteredToDoList = [];
  addToList(int id, String value, bool status) {
    toDoList.add(new Item(id, value, status));
  }

  @override
  void initState() {
    super.initState();
    filteredToDoList = toDoList;
  }

  void updateInformation(String information) {
    if (information != null) {
      setState(() {
        _information = information;
        addToList(toDoList.length, _information, false);
      });
    }
  }

  void moveToSecondPage() async {
    final information = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyAddPage()),
    );
    updateInformation(information);
  }

  void filterAction(String choice) {
    if (choice == FilterOptions.All) {
      setState(() {
        filteredToDoList = toDoList;
      });
    }
    if (choice == FilterOptions.Done) {
      setState(() {
        filteredToDoList = toDoList.where((element) => element.status).toList();
      });
    }
    if (choice == FilterOptions.NotDone) {
      setState(() {
        filteredToDoList =
            toDoList.where((element) => !element.status).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Things you gotta do, get to it!'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: filterAction,
              itemBuilder: (BuildContext context) {
                return FilterOptions.choices
                    .map((String choice) => PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        ))
                    .toList();
              })
        ],
      ),
      body: ListView.builder(
          itemCount: filteredToDoList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                  title: Text(filteredToDoList[index].value),
                  trailing: GestureDetector(
                    child: Icon(Icons.remove_circle_outline),
                    onTap: () {
                      toDoList.removeWhere((element) =>
                          element.id == filteredToDoList[index].id);
                      if (filteredToDoList.isNotEmpty) {
                        filteredToDoList.removeAt(index);
                      }
                      setState(() {}); //?
                    },
                  ),
                  leading: Checkbox(
                    value: filteredToDoList[index].status,
                    onChanged: (bool newValue) {
                      setState(() {
                        print(toDoList[index].status);
                        print(filteredToDoList[index].status);
                        filteredToDoList[index].status = newValue;
                        print(toDoList[index].status);
                        print(filteredToDoList[index].status);
                      });
                    },
                  )),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          moveToSecondPage();
        },
        child: Text(
          '+',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}

class MyAddPage extends StatefulWidget {
  @override
  _MyAddPageState createState() => _MyAddPageState();
}

class _MyAddPageState extends State<MyAddPage> {
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
          ),
        ]));
  }
}
