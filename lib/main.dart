import 'package:appchat/App.dart';
import 'package:appchat/firebase_options.dart';
import 'package:appchat/screens/Auth.screen.dart';
import 'package:appchat/stores/ChatManager.dart';
import 'package:appchat/utils/themeConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatManager>(
          create: (ctx) => ChatManager(),
        ),
        // ChangeNotifierProvider(
        //   create: (ctx) => ChatManager(),
        // )
      ],
      child: MaterialApp(
        title: 'Fluttergram',
        debugShowCheckedModeBanner: false,
        theme: ThemeConfig.lightTheme,
        // home: const App(title: 'Fluttergram'),
        initialRoute: AuthScreen.id,
        routes: {
          App.id: (ctx) => const App(title: 'Fluttergram'),
          AuthScreen.id: (ctx) => AuthScreen(),
        },
      ),
    );
  }
}
