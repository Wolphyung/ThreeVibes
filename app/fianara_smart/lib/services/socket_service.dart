import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../models/notification_model.dart';
import 'notification_service.dart';

class SocketService {
  static IO.Socket? _socket;
  static const String socketUrl = 'https://threevibes.onrender.com';

  static void init() {
    if (_socket != null) return;

    print('Initializing Socket with URL: $socketUrl');

    _socket = IO.io(
        socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({'Connection': 'upgrade', 'Upgrade': 'websocket'})
            .enableAutoConnect()
            .enableForceNew()
            .setReconnectionAttempts(10)
            .setReconnectionDelay(2000)
            .build());

    _socket!.onConnect((_) {
      print('✅ Socket connected successfully to $socketUrl');
    });

    _socket!.onConnectError((data) {
      print('❌ Socket Connect Error: $data');
      // If Render fails, maybe try local if on emulator?
      if (socketUrl.contains('onrender.com')) {
        print(
            '💡 Hint: If you are testing locally, ensure the app points to your local IP or 10.0.2.2');
      }
    });

    // _socket!.onConnectTimeout((data) => print('⏳ Socket Connect Timeout: $data'));
    _socket!.onError((data) => print('⚠️ Socket Error: $data'));
    _socket!.onReconnect((_) => print('🔄 Socket Reconnecting...'));

    _socket!.onDisconnect((_) => print('🔌 Socket disconnected'));

    // Listen to notification events
    _socket!.on('new-signalement', (data) {
      print('🔔 New Signalement received: $data');
      final notification = AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: '',
        message: data['message'] ?? 'Un nouveau signalement a été créé.',
        timestamp: DateTime.now(),
        type: 'SIGNALEMENT',
        data: data,
      );
      NotificationService.saveAndShow(notification);
    });

    _socket!.on('notification', (data) {
      print('🔔 General notification received: $data');
      final notification = AppNotification.fromJson(data);
      NotificationService.saveAndShow(notification);
    });
  }

  static void joinUserRoom(String userId) {
    final cleanId = userId.trim();
    if (_socket == null) return;

    if (_socket!.connected) {
      print('Joining user room: user-$cleanId');
      _socket!.emit('join-user', cleanId);
    } else {
      _socket!.once('connect', (_) => _socket!.emit('join-user', cleanId));
    }
  }

  static void joinFonctionRoom(String fonctionId) {
    final cleanId = fonctionId.trim();
    if (_socket == null) return;

    if (_socket!.connected) {
      print('Joining fonction room: fonction-$cleanId');
      _socket!.emit('join-fonction', cleanId);
    } else {
      _socket!.once('connect', (_) => _socket!.emit('join-fonction', cleanId));
    }
  }

  static void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
