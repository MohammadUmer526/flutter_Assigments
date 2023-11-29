import 'package:flutter/material.dart';
import 'item_dao.dart';
import 'item_model.dart';

class ItemScreen extends StatefulWidget {
  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final ItemDao _itemDao = ItemDao();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  late List<Item> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    _items = await _itemDao.getAllItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Items'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_items[index].name),
                  subtitle: Text(_items[index].description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await _itemDao.deleteItem(_items[index].id!);
                      _loadItems();
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final newItem = Item(
                      name: _nameController.text,
                      description: _descriptionController.text,
                    );
                    await _itemDao.insertItem(newItem);
                    _loadItems();
                    _nameController.clear();
                    _descriptionController.clear();
                  },
                  child: Text('Add Item'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
