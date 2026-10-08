/// HTTP-Einstieg: `GET /health` und WebSocket unter `/ws`.
library;

import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'connection.dart';
import 'rooms.dart';

/// Shelf-Handler für den Mordakte-Server.
Handler createHandler(RoomManager rooms, {Duration pingInterval = const Duration(seconds: 20)}) {
  var connections = 0;
  return (Request request) {
    switch (request.url.path) {
      case 'health':
        return Response.ok('ok rooms=${rooms.roomCount} players=${rooms.onlineCount}\n');
      case 'ws':
        final label = '#${++connections} ${_remoteAddress(request)}';
        return webSocketHandler(
          (WebSocketChannel channel, String? _) => Connection(channel, rooms, label: label).start(),
          pingInterval: pingInterval,
        )(request);
      case '':
        return Response.ok('Mordakte-Server – WebSocket: /ws, Status: /health\n');
      default:
        return Response.notFound('not found\n');
    }
  };
}

/// Startet den HTTP-Server auf allen Interfaces. [port] 0 = freier Port.
Future<HttpServer> serveMordakte(RoomManager rooms, {int port = 8080, Duration? pingInterval}) =>
    shelf_io.serve(
      pingInterval == null ? createHandler(rooms) : createHandler(rooms, pingInterval: pingInterval),
      InternetAddress.anyIPv4,
      port,
    );

String _remoteAddress(Request request) {
  final forwarded = request.headers['x-forwarded-for'];
  if (forwarded != null && forwarded.isNotEmpty) return forwarded.split(',').first.trim();
  final info = request.context['shelf.io.connection_info'];
  return info is HttpConnectionInfo ? info.remoteAddress.address : '?';
}
