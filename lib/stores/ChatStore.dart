import 'package:appchat/utils/data.dart';
import 'package:appchat/widgets/ChatItem.dart';
import 'package:flutter/cupertino.dart';

class ChatManager with ChangeNotifier {
  final List<ChatItem> _chatItems = List.generate(
      30,
      (index) => ChatItem(
            conversationId: 'conver-${DateTime.now().toIso8601String()}',
            avatar: "assets/images/cm${random.nextInt(2) + 1}.jpg",
            name: names[random.nextInt(10)],
            time: "${random.nextInt(50)} min ago",
            lastMsg: messages[random.nextInt(10)],
            isOnline: random.nextBool(),
            counter: random.nextInt(20),
          ));

  // [
  //   ChatItem(
  //     conversationId: 'conver-${DateTime.now().toIso8601String()}',
  //     avatar: "assets/images/cm${random.nextInt(10)}.jpg",
  //     name: names[random.nextInt(10)],
  //     time: "${random.nextInt(50)} min ago",
  //     lastMsg: messages[random.nextInt(10)],
  //     isOnline: random.nextBool(),
  //     counter: random.nextInt(20),
  //   ),
  // ];

  int get count {
    return _chatItems.length;
  }

  List<ChatItem> get items {
    return [..._chatItems];
  }

  void addChat(List<ChatItem> chatItem) async {
    _chatItems.insert(
      0,
      ChatItem(
        conversationId: 'conver-${DateTime.now().toIso8601String()}',
        avatar: 'asdas',
        name: 'asdas',
        time: 'asdas',
        lastMsg: 'asdas',
        isOnline: true,
        counter: 12,
      ),
    );
    notifyListeners();
  }
}
