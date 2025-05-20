import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/view_constants.dart';
import '../core/theme/light.dart';
import '../viewmodels/chat_viewmodel.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user2Id, required this.user2Name});
  final String user2Id;
  final String user2Name;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ChatViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.initialize(widget.user2Id);
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Consumer<ChatViewModel>(
        builder: (context, viewModel, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: Text(
                  widget.user2Name,
                  style: TextStyle(
                    color: LightTheme.appBarText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                backgroundColor: LightTheme.appBarBackground,
                elevation: 8,
              ),
              body: SafeArea(
                child:
                    viewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : Padding(
                          padding: const EdgeInsets.all(AppConstants.gap16Px),
                          child: Column(
                            children: [
                              Expanded(
                                child:
                                    viewModel.chatId != null
                                        ? StreamBuilder<QuerySnapshot>(
                                          stream: viewModel.repository
                                              .getChatMessages(
                                                viewModel.chatId!,
                                              ),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            if (!snapshot.hasData ||
                                                snapshot.data!.docs.isEmpty) {
                                              return const Center(
                                                child: Text(
                                                  ViewConstants.noMessages,
                                                ),
                                              );
                                            }
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) {
                                                  viewModel.scrollToBottom();
                                                });
                                            return ListView.builder(
                                              controller:
                                                  viewModel.scrollController,
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                              itemBuilder: (context, index) {
                                                if (snapshot
                                                        .data!
                                                        .docs[index]['sender'] ==
                                                    viewModel.currentUserId) {
                                                  return _buildMessageBubble(
                                                    snapshot
                                                            .data!
                                                            .docs[index]['text']
                                                        as String,
                                                    true,
                                                  );
                                                } else {
                                                  return _buildMessageBubble(
                                                    snapshot
                                                            .data!
                                                            .docs[index]['text']
                                                        as String,
                                                    false,
                                                  );
                                                }
                                              },
                                            );
                                          },
                                        )
                                        : const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      onTap: viewModel.scrollToBottom,
                                      controller: viewModel.textController,
                                      decoration: InputDecoration(
                                        hintText: ViewConstants.typeMessage,
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed:
                                        () => viewModel.sendMessage(
                                          widget.user2Id,
                                        ),
                                    icon: const Icon(Icons.send),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(String text, bool isMe) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.gap8Px,
        vertical: AppConstants.gap4Px,
      ),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          decoration: BoxDecoration(
            color: isMe ? LightTheme.primaryBlue : LightTheme.messageBubbleGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
              bottomLeft: Radius.circular(isMe ? 26 : 1),
              bottomRight: Radius.circular(isMe ? 1 : 26),
            ),
            boxShadow: [BoxShadow(blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.gap16Px,
              vertical: AppConstants.gap12Px,
            ),
            child: Text(
              text,
              style: TextStyle(
                color: isMe ? LightTheme.textWhite : LightTheme.textBlack,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
