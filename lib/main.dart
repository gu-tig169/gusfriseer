import 'package:flutter/material.dart';
import 'package:erikstodoapp/secondView.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage()));
}

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
      MaterialPageRoute(builder: (context) => SecondView()),
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
          actions: [
            _filterMenu(),
          ]),
      body: _listBuilder(),
      floatingActionButton: _addItemsToListButton(),
    );
  }

  Widget _filterMenu() {
    return PopupMenuButton<String>(
        onSelected: filterAction,
        itemBuilder: (BuildContext context) {
          return FilterOptions.choices
              .map((String choice) => PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  ))
              .toList();
        });
  }

  Widget _listBuilder() {
    return ListView.builder(
        itemCount: filteredToDoList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                title: Text(filteredToDoList[index].value),
                trailing: GestureDetector(
                  child: Icon(Icons.cancel_outlined),
                  onTap: () {
                    var itemToRemove = filteredToDoList[index];

                    setState(() {
                      filteredToDoList.remove(itemToRemove);
                    });

                    toDoList.removeWhere(
                        (element) => element.id == itemToRemove.id);
                  },
                ),
                leading: Checkbox(
                  value: filteredToDoList[index].status,
                  onChanged: (bool newValue) {
                    setState(() {
                      filteredToDoList[index].status = newValue;
                    });
                  },
                )),
          );
        });
  }

  Widget _addItemsToListButton() {
    return FloatingActionButton(
      onPressed: () {
        moveToSecondPage();
      },
      splashColor: Colors.white,
      child: Text(
        '+',
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}
