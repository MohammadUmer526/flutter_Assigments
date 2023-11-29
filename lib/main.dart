import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'dio_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ApiService apiService = ApiService();
  final DioService dioService = DioService();

  List<Map<String, dynamic>> apiData = [];
  Map<String, dynamic> dioData = {};

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Http Request Example'),
            bottom: TabBar(
              tabs: [
                Tab(text: 'HTTP'),
                Tab(text: 'Dio'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildHttpTab(),
              _buildDioTab(),
            ],
          ),
        ));
  }

  Widget _buildHttpTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _fetchHttpData();
            },
            child: Text('Fetch Data'),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: apiData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Title: ${apiData[index]['title']}'),
                  subtitle: Text('Completed: ${apiData[index]['completed']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDioTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              _fetchDioData(context);
            },
            child: Text('Fetch Data'),
          ),
          SizedBox(height: 20),
          Text('Dio Response:'),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.grey[200],
              child: SingleChildScrollView(
                child: Text(dioData.toString()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchHttpData() async {
    try {
      List<Map<String, dynamic>> result = await apiService.fetchData();
      setState(() {
        apiData = result;
      });
    } catch (e) {
      print('Error ${e}');
    }
  }

  Future<void> _fetchDioData(BuildContext context) async {
    try {
      Map<String, dynamic> result = await dioService.fetchData(context);
      setState(() {
        dioData = result;
      });
    } catch (e) {
      print('Dio Error: $e');
    }
  }
}
