enum MType { initial, chatting }

const Map<MType, String> mTypeMap = {
  MType.initial: 'initial',
  MType.chatting: 'chatting',
};

const Map<String, MType> strTomTypeMap = {
  'initial' : MType.initial,
  'chatting' : MType.chatting,
};


class Message {
  final String? from;
  final String? to;
  final String? message;
  final MType? messageType;

  Message({
    required this.from,
    required this.to,
    required this.message,
    required this.messageType
  });

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'message': message,
      'messageType': mTypeMap[messageType]
    };
  }

  factory Message.fromJson(Map json) {
    return Message(
        from: json['from'],
        to: json['to'],
        message: json['message'],
        messageType: strTomTypeMap[json['messageType']]);
  }

}