import 'package:appchat/stores/ChatStore.dart';
import 'package:appchat/utils/timePassed.dart';
import 'package:appchat/widgets/ChatItem.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var instance = null;
  String searchName = '';
  String onlineFilter = '';
  @override
  void initState() {
    super.initState();
    print('------------------initStateFetchChatItems');

    instance = context.read<ChatManager>();
    instance.fetchChatItems();
  }

  @override
  void dispose() {
    super.dispose();
    instance.disposeFetchChatItems();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragDown: (details) =>
            FocusScope.of(context).requestFocus(new FocusNode()),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            title: TextField(
              decoration: const InputDecoration.collapsed(
                hintText: 'Search',
              ),
              onChanged: filterName,
            ),
            actions: <Widget>[
              buildFiltterButton(),
            ],
          ),
          body: Consumer<ChatManager>(builder: (ctx, chatItemsManager, child) {
            // List<ChatManager> filter = chatItemsManager.filterByName('vinh');
            var chatItems =
                context.read<ChatManager>().filterByName(searchName);
            chatItems.retainWhere((chatItem) {
              if (onlineFilter == 'online') {
                return chatItem.isOnline == true;
              } else if (onlineFilter == 'offline') {
                return chatItem.isOnline == false;
              }

              return true;
            });
            // chatItemsManager.filterByName('vinh');
            return ListView.builder(
              itemCount: chatItems.length,
              itemBuilder: (ctx, i) {
                DateTime tempDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                    .parse(chatItems[i].time);
                // chatItemsManager.items[i]
                return ChatItem(
                  chatItemId: chatItems[i].chatItemId,
                  avatar: chatItems[i].avatar,
                  name: chatItems[i].name,
                  isOnline: chatItems[i].isOnline,
                  counter: chatItems[i].counter,
                  lastMsg: chatItems[i].lastMsg,
                  lastSentUser: chatItems[i].lastSentUser,
                  time: timePassed(tempDate),
                );
              },
            );
          }),
        ));
  }

  void filterName(String query) {
    setState(() {
      searchName = query;
    });
  }

  buildFiltterButton() {
    const List<String> list = <String>[
      'Online',
      'Offline',
    ];
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        value: "All",
        onTap: () => setState(() => onlineFilter = 'all'),
        child: const Text("All"),
      ),
      DropdownMenuItem(
        value: "online",
        onTap: () => setState(() => onlineFilter = 'online'),
        child: const Text("Online"),
      ),
      DropdownMenuItem(
        value: "offline",
        onTap: () => setState(() => onlineFilter = 'offline'),
        child: const Text("Offline"),
      ),
    ];
    // String dropdownValue = list.first;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            icon: const Icon(
              Icons.filter_list,
              color: Colors.black,
            ),
            elevation: 16,
            onChanged: (String? value) {},
            items: menuItems,
          ),
        ));
  }
}
