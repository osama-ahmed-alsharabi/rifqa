import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rifqa/Features/chat/presentation/view_model/ai_chat_cubit/ai_chat_cubit.dart';
import 'package:rifqa/cores/cubit/theme_app_cubit.dart';

class AiChatScreen extends StatefulWidget {
  final String userLocation;

  const AiChatScreen({super.key, required this.userLocation});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<AiChatCubit>().initializeChat(widget.userLocation);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newLocation = widget.userLocation;
    context.read<AiChatCubit>().initializeChat(newLocation);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = context.read<ThemeAppCubit>().kprimayColor;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'مرشد ${widget.userLocation} السياحي',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<AiChatCubit, AiChatState>(
              listener: (context, state) {
                if (state is AiChatLoaded) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is AiChatInitial || state is AiChatLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  );
                }

                if (state is AiChatError) {
                  return Column(
                    children: [
                      Expanded(
                        child: _buildMessageList(state.messages, primaryColor),
                      ),
                      _buildErrorBanner(state),
                    ],
                  );
                }

                if (state is AiChatLoaded) {
                  return _buildMessageList(state.messages, primaryColor);
                }

                return const SizedBox.shrink();
              },
            ),
          ),
          _buildMessageInput(primaryColor),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages, Color primaryColor) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ChatBubble(
          message: message.text,
          isUser: message.isUser,
          time: DateFormat('hh:mm a').format(message.timestamp),
          isTyping: message.text == "جارٍ الرد...",
          primaryColor: primaryColor,
        );
      },
    );
  }

  Widget _buildErrorBanner(AiChatError state) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.red[100],
      child: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.message),
                Text(
                  state.errorDetails,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<AiChatCubit>().initializeChat(widget.userLocation);
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'اكتب رسالتك هنا...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: primaryColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: primaryColor),
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    context.read<AiChatCubit>().sendMessage(message);
    _messageController.clear();
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String time;
  final bool isTyping;
  final Color primaryColor;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.time,
    this.isTyping = false,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Align(
        alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isUser ? primaryColor : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isUser ? 0 : 16),
                bottomRight: Radius.circular(isUser ? 16 : 0),
              ),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isTyping)
                  const TypingIndicator()
                else
                  Text(
                    message,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: isUser ? Colors.white70 : Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDot(0),
          _buildDot(200),
          _buildDot(400),
        ],
      ),
    );
  }

  Widget _buildDot(int delay) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
      curve: Curves.easeInOut,
    );
  }
}
