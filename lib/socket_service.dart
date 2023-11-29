import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final String _serverUrl =
      'ws:http://localhost:64366/'; // Replace with your socket server URL
  late io.Socket _socket;

  void initSocket() {
    _socket = io.io(_serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();
  }

  void sendMessage(String message) {
    if (_socket != null && _socket.connected) {
      _socket.emit('chatMessage', {'message': message});
    }
  }

  void listenForMessages(void Function(String) onMessageReceived) {
    if (_socket != null && _socket.connected) {
      _socket.on('chatMessage', (data) {
        onMessageReceived(data['message']);
      });
    }
  }

  void dispose() {
    if (_socket != null && _socket.connected) {
      _socket.disconnect();
    }
  }
}
