import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'api_service.dart';
import 'dio_service.dart';
import 'socket_service.dart';

// ... (previous imports)

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
  final DioService dioService = DioService();
  final SocketService socketService = SocketService(); // Add this line

  @override
  void initState() {
    super.initState();
    socketService.initSocket(); // Initialize socket connection
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _openChatScreen(context);
          },
          child: Text('Open Chat'),
        ),
      ),
    );
  }

  void _openChatScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(socketService),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final SocketService socketService;

  ChatScreen(this.socketService);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _messageController = TextEditingController();
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    widget.socketService.listenForMessages(_onMessageReceived);
  }

  @override
  void dispose() {
    _messageController.dispose();
    widget.socketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onMessageReceived(String message) {
    setState(() {
      _messages.add(message);
    });
  }

  void _sendMessage() {
    String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      widget.socketService.sendMessage(message);
      _messageController.clear();
    }
  }
}
