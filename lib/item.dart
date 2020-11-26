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
