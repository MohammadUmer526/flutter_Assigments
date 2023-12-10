import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var user = FirebaseAuth.instance.currentUser;
  print("Current User: $user");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Flutter Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                // Write data to Firestore
                await addData();
              },
              child: Text('Write Data to Firestore'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Read data from Firestore
                await fetchData();
              },
              child: Text('Read Data from Firestore'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addData() async {
    // Replace 'data' with the actual name of your collection
    await FirebaseFirestore.instance.collection('data').add({
      'field1': 'value1',
      'field2': 'value2',
    });
    print('Data added to Firestore');
  }

  Future<void> fetchData() async {
    // Replace 'data' with the actual name of your collection
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('data').get();

    querySnapshot.docs.forEach((doc) {
      print(doc.data());
    });
  }
}
