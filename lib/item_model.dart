class Item {
  int? id;
  String name;
  String description;

  Item({this.id, required this.name, required this.description});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'description': description};
  }
}
