import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'ai_chat_state.dart';

class AiChatCubit extends Cubit<AiChatState> {
  static GenerativeModel? _model;
  ChatSession? _chat;
  StreamSubscription<GenerateContentResponse>? _streamSubscription;
  final List<ChatMessage> _messages = [];
  String? _currentLocation;

  AiChatCubit() : super(const AiChatInitial()) {
    _initializeModel();
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  Future<void> _initializeModel() async {
    if (_model != null) return;

    try {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: "AIzaSyABFrlnMHPpt2e94WWFqhfyM0K6FVl_QqI",
      );
    } catch (e) {
      emit(AiChatError(
        message: "Model initialization failed",
        errorDetails: e.toString(),
      ));
    }
  }

  Future<void> initializeChat(String userLocation) async {
    if (_model == null) {
      await _initializeModel();
    }

    if (_currentLocation != userLocation || _chat == null) {
      _currentLocation = userLocation;
      _messages.clear();
      _chat = _model?.startChat();

      _messages.add(ChatMessage(
        text:
            "مرحباً بك في $userLocation! أنا مساعدك السياحي. من فضلك تحدث معي باللغة العربية وسأرد عليك بنفس اللغة. كيف يمكنني مساعدتك اليوم؟",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    }

    emit(AiChatLoaded(
      messages: List.from(_messages),
      isStreaming: false,
    ));
  }

  Future<void> sendMessage(String message) async {
    if (_chat == null) return;

    final userMessage = ChatMessage(
      text: message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    final typingMessage = ChatMessage(
      text: "جارٍ الرد...",
      isUser: false,
      timestamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _messages.add(typingMessage);

    emit(AiChatLoaded(
      messages: List.from(_messages),
      isStreaming: true,
    ));

    try {
      String fullResponse = '';
      final typingIndex = _messages.indexOf(typingMessage);

      _streamSubscription?.cancel();
      final stream = _chat!.sendMessageStream(Content.text(message));

      _streamSubscription = stream.listen(
        (response) {
          final newText = response.text ?? '';
          if (newText.isNotEmpty) {
            fullResponse += newText;
            _messages[typingIndex] = ChatMessage(
              text: fullResponse,
              isUser: false,
              timestamp: typingMessage.timestamp,
            );
            emit(AiChatLoaded(
              messages: List.from(_messages),
              isStreaming: true,
            ));
          }
        },
        onDone: () {
          emit(AiChatLoaded(
            messages: List.from(_messages),
            isStreaming: false,
          ));
        },
        onError: (e) {
          _messages.remove(typingMessage);
          emit(AiChatError(
            message: "Error sending message",
            errorDetails: e.toString(),
            previousState: AiChatLoaded(
              messages: List.from(_messages),
              isStreaming: false,
            ),
          ));
        },
      );
    } catch (e) {
      _messages.remove(typingMessage);
      emit(AiChatError(
        message: "Exception occurred",
        errorDetails: e.toString(),
        previousState: AiChatLoaded(
          messages: List.from(_messages),
          isStreaming: false,
        ),
      ));
    }
  }
}
