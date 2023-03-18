import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:skeleton_desktop/ws/timer_helper.dart';
import 'package:skeleton_desktop/ws/proto.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'connection_status.dart';

typedef EventHandler = void Function(Proto);

class WebSocket with TimerHelper {
  WebSocket({
    required this.baseUrl,
    required this.token,
    required this.gameId,
    this.handler,
    Logger? logger,
    this.reconnectionMonitorInterval = 10,
    this.healthCheckInterval = 20,
    this.reconnectionMonitorTimeout = 40,
  }) : _logger = logger {
    statusController.stream.listen((status) {
      _logger?.info('WebSocket connection status: $status');
      connectionStatus = status;
    });
  }

  final statusController = StreamController<ConnectionStatus>();

  ConnectionStatus connectionStatus = ConnectionStatus.disconnected;

  final String baseUrl;
  final String token;
  final String gameId;

  /// Interval of the reconnection monitor timer
  /// This checks that it received a new event in the last
  /// [reconnectionMonitorTimeout] seconds, otherwise it considers the
  /// connection unhealthy and reconnects the WS
  final int reconnectionMonitorInterval;

  /// Interval of the health event sending timer
  /// This sends a health event every [healthCheckInterval] seconds in order to
  /// make the server aware that the client is still listening
  final int healthCheckInterval;

  /// The timeout that uses the reconnection monitor timer to consider the
  /// connection unhealthy
  final int reconnectionMonitorTimeout;

  final Logger? _logger;

  /// Functions that will be called every time a new event is received from the
  /// connection
  final EventHandler? handler;

  WebSocketChannel? _webSocketChannel;

  void _initWebSocketChannel(Uri uri) {
    if (_webSocketChannel != null) {
      _closeWebSocketChannel();
    }
    statusController.add(ConnectionStatus.connecting);
    _webSocketChannel = WebSocketChannel.connect(uri);
    _subscribeToWebSocketChannel();
  }

  void _subscribeToWebSocketChannel() {
    _webSocketChannel?.stream.listen(
      _onDataReceived,
      onError: _onConnectionError,
      onDone: _onConnectionClosed,
    );
  }

  void _onConnectionError(error, [stacktrace]) {
    _logger?.warning('Error occurred', error, stacktrace);
    statusController.add(ConnectionStatus.disconnected);
  }

  void _onConnectionClosed() {
    _logger?.warning('Connection closed');
    statusController.add(ConnectionStatus.disconnected);
  }

  void _onDataReceived(dynamic data) {
    Proto? p;
    try {
      p = Proto.fromJson(json.decode(data));
    } catch (e, stk) {
      _logger?.warning('Error parsing an event: $e');
      _logger?.warning('Stack trace: $stk');
    }
    if (p == null) return;
    _logger?.info('Event received: ${p.op}');
    return handler?.call(p);
  }

  void _closeWebSocketChannel() {
    if (_webSocketChannel != null) {
      _webSocketChannel?.sink.close();
      _webSocketChannel = null;
    }
  }

  void send(Proto data) {
    _webSocketChannel?.sink.add(data.toJsonString());
  }

  /// Connect the WS using the parameters passed in the constructor
  void connect() {
    disconnect();
    try {
      final uri =
          Uri.parse('$baseUrl?token=$token&game_id=$gameId');
      _initWebSocketChannel(uri);
      statusController.add(ConnectionStatus.connected);
    } catch (e, stk) {
      _onConnectionError(e, stk);
    }
  }

  /// Disconnects the WS and releases eventual resources
  void disconnect() {
    if (connectionStatus == ConnectionStatus.disconnected) return;

    statusController.add(ConnectionStatus.disconnected);

    _logger?.info('Disconnecting web-socket connection');

    _closeWebSocketChannel();
  }
}
