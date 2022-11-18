import 'package:appchat/screens/Home.screen.dart';
import 'package:appchat/screens/chat/Chat.screen.dart';
import 'package:appchat/screens/Notification.screen.dart';
import 'package:appchat/screens/People.screen.dart';
import 'package:appchat/screens/Profile.screen.dart';
import 'package:appchat/stores/AuthStore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  static const id = 'AppScreen';

  const App({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  int _selectedIndex = 2;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black);
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final uid = AuthStore.user!.uid;
    if (state == AppLifecycleState.resumed) {
      print('\n\nOnline');
      await FirebaseDatabase.instance
          .ref('/users/user-$uid/isOnline')
          .set(true);
    } else {
      print('\n\nOffline');
      await FirebaseDatabase.instance
          .ref('/users/user-$uid/isOnline')
          .set(false);
    }
  }

  static const List<Widget> _widgetOptions = <Widget>[
    ChatScreen(),
    PeopleScreen(),
    HomeScreen(),
    NotificationScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('BottomNavigationBar Sample'),
      // ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'People',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.blue,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
