import 'package:comet_chat/message_screen.dart';
import 'package:cometchat_chat_uikit/cometchat_chat_uikit.dart';
import 'package:flutter/material.dart';

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  void _showUserSearchDialog(BuildContext context) {
    final TextEditingController userIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start New Chat'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter the username of the person you want to chat with:',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: userIdController,
                decoration: const InputDecoration(
                  hintText: 'Enter username...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final userId = userIdController.text.trim();
                if (userId.isNotEmpty) {
                  Navigator.of(context).pop();

                  CometChat.getUser(
                    userId,
                    onSuccess: (User user) {
                      // Navigate to messages screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MessagesScreen(user: user, group: null),
                        ),
                      );
                    },
                    onError: (CometChatException e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'User "$userId" not found. Make sure they have logged in at least once.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                }
              },
              child: const Text('Start Chat'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await CometChatUIKit.logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: CometChatConversations(
          showBackButton: false,
          onItemTap: (conversation) {
            final target = conversation.conversationWith;

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MessagesScreen(
                  user: target is User ? target : null,
                  group: target is Group ? target : null,
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserSearchDialog(context),
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add_comment, color: Colors.white),
      ),
    );
  }
}
