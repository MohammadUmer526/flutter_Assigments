import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  TextEditingController _themeController = TextEditingController();
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeController.text = _prefs.getString('theme') ?? '';
    });
  }

  Future<void> _savePreferences() async {
    await _prefs.setString('theme', _themeController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _themeController,
              decoration: InputDecoration(labelText: 'Theme'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _savePreferences();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Preferences saved')),
                );
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
