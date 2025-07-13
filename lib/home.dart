import 'package:comet_chat/constant/cometChatConfig.dart';
import 'package:comet_chat/conversationpage.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final String nickName;
  const Home({required this.nickName, super.key});

  Future<void> _initializeAndLogin() async {
    final settings = UIKitSettingsBuilder()
      ..subscriptionType = CometChatSubscriptionType.allUsers
      ..autoEstablishSocketConnection = true
      ..appId = CometChatConfig.appId
      ..region = CometChatConfig.region
      ..authKey = CometChatConfig.authKey
      ..extensions =
          CometChatUIKitChatExtensions.getDefaultExtensions(); //Replace this with empty array, if you want to disable all extensions

    await CometChatUIKit.init(uiKitSettings: settings.build());
    await CometChatUIKit.createUser(User(uid: nickName, name: nickName));
    await CometChatUIKit.login(
      nickName,
      onSuccess: (_) => debugPrint('✅ Login Successful'),
      onError: (err) => throw Exception('Login Failed: $err'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeAndLogin(),
      builder: (ctx, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: SafeArea(child: Center(child: CircularProgressIndicator())),
          );
        }
        if (snap.hasError) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Text(
                  'Error starting app:\n${snap.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        return const ConversationsPage();
      },
    );
  }
}
