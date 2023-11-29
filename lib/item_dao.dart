import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'item_model.dart';

class ItemDao {
  final dbHelper = DatabaseHelper();

  Future<int> insertItem(Item item) async {
    final db = await dbHelper.database;
    return await db.insert('items', item.toMap());
  }

  Future<List<Item>> getAllItems() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('items');
    return List.generate(maps.length, (index) {
      return Item(
        id: maps[index]['id'],
        name: maps[index]['name'],
        description: maps[index]['description'],
      );
    });
  }

  Future<int> updateItem(Item item) async {
    final db = await dbHelper.database;
    return await db
        .update('items', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
  }

  Future<int> deleteItem(int id) async {
    final db = await dbHelper.database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }
}
