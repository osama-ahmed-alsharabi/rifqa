import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final String time;
  final bool isTyping;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isUser,
    required this.time,
    this.isTyping = false,
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
              color: isUser ? const Color(0xFF166787) : Colors.grey[200],
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
                    textDirection: TextDirection.rtl,
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
          _buildDot(100),
          _buildDot(200),
        ],
      ),
    );
  }

  Widget _buildDot(int delay) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: 0.5,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        child: Container(),
      ),
    );
  }
}
