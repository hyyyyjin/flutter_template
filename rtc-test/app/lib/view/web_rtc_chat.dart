import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:web_socket_channel/io.dart';

class WebRTCChat extends StatefulWidget {
  @override
  _WebRTCChatState createState() => _WebRTCChatState();
}

class _WebRTCChatState extends State<WebRTCChat> {
  final _localDataChannel = RTCDataChannelInit();
  late RTCPeerConnection _peerConnection;
  late RTCDataChannel _dataChannel;
  final _channel = IOWebSocketChannel.connect('ws://10.250.188.165:3000');
  final _sdpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _createPeerConnection().then((pc) {
      _peerConnection = pc;
      _createDataChannel();
    });
    _channel.stream.listen((message) {

      // 바이트 배열을 문자열로 변환
      String messageString;
      if (message is String) {
        messageString = message;
      } else if (message is List<int>) {
        messageString = String.fromCharCodes(message);
      } else {
        print('Unknown data type received: ${message.runtimeType}');
        return;
      }

      print ('message:::: ${messageString}');
      var parsedMessage = json.decode(messageString);
      switch (parsedMessage['type']) {
        case 'offer':
          _setRemoteDescription(parsedMessage);
          _createAnswer();
          break;
        case 'answer':
          _setRemoteDescription(parsedMessage);
          break;
        case 'candidate':
          _addCandidate(parsedMessage);
          break;
        default:
          print('Unknown type ${parsedMessage['type']}');
      }
    });
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"url": "stun:stun.l.google.com:19302"},
      ]
    };

    final Map<String, dynamic> constraints = {
      'mandatory': {
        'OfferToReceiveAudio': false, // 오디오 수신 비활성화
        'OfferToReceiveVideo': false, // 비디오 수신 비활성화
      },
      'optional': [],
    };

    final peerConnection = await createPeerConnection(configuration, constraints);
    peerConnection.onIceCandidate = (candidate) {
      _channel.sink.add(json.encode({
        'type': 'candidate',
        'candidate': {
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
          'candidate': candidate.candidate,
        }
      }));
    };

    return peerConnection;
  }

  void _createDataChannel() async {
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit();
    _dataChannel = await _peerConnection.createDataChannel(
      'textDataChannel',
      dataChannelDict,
    );
    _dataChannel.onMessage = (RTCDataChannelMessage message) {
      setState(() {
        print('_createDataChannel :: ${message.text}');
      });
    };
  }

  void _createOffer() async {
    RTCSessionDescription description = await _peerConnection.createOffer({});
    _peerConnection.setLocalDescription(description);
    _channel.sink.add(json.encode({
      'type': 'offer',
      'sdp': description.sdp
    }));
  }

  void _createAnswer() async {
    RTCSessionDescription description = await _peerConnection.createAnswer({});
    _peerConnection.setLocalDescription(description);
    _channel.sink.add(json.encode({
      'type': 'answer',
      'sdp': description.sdp
    }));
  }

  void _setRemoteDescription(dynamic message) async {
    String sdp = message['sdp'];
    RTCSessionDescription description = RTCSessionDescription(sdp, message['type']);
    await _peerConnection.setRemoteDescription(description);
  }

  void _addCandidate(dynamic message) async {
    dynamic candidate = message['candidate'];
    RTCIceCandidate iceCandidate = RTCIceCandidate(
      candidate['candidate'],
      candidate['sdpMid'],
      candidate['sdpMLineIndex'],
    );
    await _peerConnection.addCandidate(iceCandidate);
  }

  void _sendMessage(String text) {
    if (_dataChannel != null) {
      _dataChannel.send(RTCDataChannelMessage(text));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebRTC Text Chat'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _sdpController,
              decoration: InputDecoration(labelText: 'Send a message'),
            ),
          ),
          ElevatedButton(
            onPressed: () => _sendMessage(_sdpController.text),
            child: Text('Send Message'),
          ),
          ElevatedButton(
            onPressed: _createOffer,
            child: Text('Create Offer'),
          ),
          ElevatedButton(
            onPressed: _createAnswer,
            child: Text('Create Answer'),
          ),
        ],
      ),
    );
  }
}