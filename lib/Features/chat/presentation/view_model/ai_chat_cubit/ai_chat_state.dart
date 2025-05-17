part of 'ai_chat_cubit.dart';

class ChatMessage extends Equatable {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  @override
  List<Object> get props => [text, isUser, timestamp];

  @override
  String toString() {
    return 'ChatMessage($text, $isUser, $timestamp)';
  }
}

abstract class AiChatState extends Equatable {
  final List<ChatMessage> messages;
  final bool isStreaming;

  const AiChatState({
    required this.messages,
    this.isStreaming = false,
  });

  @override
  List<Object> get props => [messages, isStreaming];

  @override
  String toString() {
    return '$runtimeType($messages, $isStreaming)';
  }
}

class AiChatInitial extends AiChatState {
  const AiChatInitial() : super(messages: const []);
}

class AiChatLoading extends AiChatState {
  const AiChatLoading() : super(messages: const []);
}

class AiChatLoaded extends AiChatState {
  const AiChatLoaded({
    required super.messages,
    super.isStreaming = false,
  });

  AiChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isStreaming,
  }) {
    return AiChatLoaded(
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}

class AiChatError extends AiChatState {
  final String message;
  final String errorDetails;
  final AiChatLoaded? previousState;

  AiChatError({
    required this.message,
    required this.errorDetails,
    this.previousState,
  }) : super(
          messages: previousState?.messages ?? const [],
          isStreaming: false,
        );

  @override
  List<Object> get props => [message, errorDetails, ...super.props];
}
