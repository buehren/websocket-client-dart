import 'dart:io';
import 'dart:async';
import 'package:args/args.dart';

late MyWebSocket _webSocket;
const urlParamName = 'url';

void main(List<String> arguments) {
  String _webSocketUrl = 'ws://echo.websocket.org/';

  exitCode = 0; // presume success
  final parser = ArgParser()
    ..addOption(urlParamName, defaultsTo : _webSocketUrl);

  var argResults = parser.parse(arguments);

  run(argResults[urlParamName]);
}

void run(String webSocketUrl) async {

  print(new DateTime.now().toString() + " Starting connection attempt to " +webSocketUrl + " ...");

  Future<WebSocket> futureWebSocket = WebSocket.connect(webSocketUrl);

  futureWebSocket.then((WebSocket ws) {
    _webSocket = ws;
    print(new DateTime.now().toString() + " WebSocket readyState: " + (_webSocket.readyState.toString()));

    _webSocket.listen((data) {
      print(new DateTime.now().toString() + " Received data: $data");
    }, onError: _error, onDone: _done);

    // send messages

    new Timer(const Duration(seconds: 1), () {
      print(new DateTime.now().toString() + " Sending 'hello'");
      _webSocket.add('hello');
    });

    new Timer(const Duration(seconds: 2), () {
      print(new DateTime.now().toString() + " Sending 'how are you?'");
      _webSocket.add('how are you');
    });

    new Timer(const Duration(seconds: 4), () {
      print(new DateTime.now().toString() + " Sending 'still there?'");
      _webSocket.add('still there?');
    });
  });
}

_error(err) async {
  print(new DateTime.now().toString() + " CONNECTION ERROR: $err");
}

_done() async {
  print(new DateTime.now().toString() + " CONNECTION DONE! \n" +
      "readyState=" + _webSocket.readyState.toString() + "\n" +
      "closeCode=" + _webSocket.closeCode.toString() + "\n" +
      "closeReason=" + _webSocket.closeReason.toString() + "\n");
}
