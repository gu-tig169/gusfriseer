import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:erikstodoapp/secondView.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MyState extends ChangeNotifier {}

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
  String id;
  String title;
  bool done;
  Item({this.id, this.title, this.done});

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      title: json['title'],
      done: json['done'],
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _information = '';
  String url(String id) {
    if (id != '') {
      return 'https://todoapp-api-vldfm.ondigitalocean.app/todos/' +
          id +
          '?key=1d8993c3-159e-4cb7-929c-20bcb6544bb5';
    } else {
      return 'https://todoapp-api-vldfm.ondigitalocean.app/todos?key=1d8993c3-159e-4cb7-929c-20bcb6544bb5';
    }
  }

  Future<List<Item>> toDoList;

  Future<List<Item>> getToDoList() async {
    var response = await http.get(url(''));
    List jsonData = json.decode(response.body);
    return jsonData.map((toDo) => new Item.fromJson(toDo)).toList();
  }

  Future<List<Item>> createItem(Item item) async {
    var response = await http.post(url(item.id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': item.id,
          'title': item.title,
          'done': item.done
        }));
    List jsonData = json.decode(response.body);
    return jsonData.map((toDo) => new Item.fromJson(toDo)).toList();
  }

  Future<List<Item>> updateItem(Item item) async {
    var response = await http.put(url(item.id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': item.id,
          'title': item.title,
          'done': item.done
        }));
    List jsonData = json.decode(response.body);
    return jsonData.map((toDo) => new Item.fromJson(toDo)).toList();
  }

  Future<List<Item>> deleteItem(String id) async {
    var response = await http.delete(url(id));
    List jsonData = json.decode(response.body);
    return jsonData.map((toDo) => new Item.fromJson(toDo)).toList();
  }

  @override
  void initState() {
    super.initState();
    toDoList = getToDoList();
  }

  void updateInformation(String information) {
    if (information != null) {
      setState(() {
        _information = information;
        toDoList =
            createItem(new Item(id: '', title: _information, done: false));
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
        toDoList = getToDoList();
      });
    }
    if (choice == FilterOptions.Done) {
      setState(() {
        toDoList = getToDoList()
            .then((value) => value.where((element) => element.done).toList());
      });
    }
    if (choice == FilterOptions.NotDone) {
      setState(() {
        toDoList = getToDoList()
            .then((value) => value.where((element) => !element.done).toList());
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
      body: _itemListView(),
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

  Widget _itemListView() {
    return FutureBuilder<List<Item>>(
        future: toDoList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _listBuilder(snapshot.data);
          }
          return _listBuilder([]);
        });
  }

  Widget _listBuilder(List<Item> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                title: Text(
                  list[index].title,
                  style: list[index].done
                      ? TextStyle(decoration: TextDecoration.lineThrough)
                      : TextStyle(decoration: TextDecoration.none),
                ),
                trailing: GestureDetector(
                  child: Icon(Icons.cancel_outlined),
                  onTap: () {
                    var itemToRemove = list[index];
                    deleteItem(itemToRemove.id);
                    setState(() {
                      toDoList.then((value) => value.remove(itemToRemove));
                    });
                  },
                ),
                leading: Checkbox(
                  value: list[index].done,
                  onChanged: (bool newValue) {
                    setState(() {
                      toDoList = updateItem(new Item(
                          id: list[index].id,
                          title: list[index].title,
                          done: newValue));
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
