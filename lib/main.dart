import 'package:comet_chat/constant/cometChatConfig.dart';
import 'package:comet_chat/home.dart';
import 'package:comet_chat/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CometChat Demo',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {'/': (context) => const LoginScreen()},
    );
  }
}
