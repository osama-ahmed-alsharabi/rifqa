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
        // يمكن لاحقًا استخدام systemInstruction لو دعمت رسمياً
        // systemInstruction: Content.text(
        //   "أنت مساعد سياحي ذكي. أجب فقط على الأسئلة المتعلقة بالسفر والسياحة والمناطق السياحية والمطاعم والفنادق والأنشطة السياحية. تجاهل أي أسئلة خارج هذا السياق."
        // ),
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
      _chat = _model?.startChat(history: [
        Content.text(
          "أنت مساعد سياحي محترف، وظيفتك هي الرد فقط على الأسئلة المتعلقة بالسفر، السياحة، الفنادق، الأماكن السياحية، والمطاعم. لا تجب على أي أسئلة لا علاقة لها بالسياحة. المستخدم موجود في $userLocation.",
        ),
      ]);

      _messages.add(ChatMessage(
        text:
            "مرحباً بك في $userLocation! أنا مساعدك السياحي. من فضلك تحدث معي باللغة العربية وسأرد عليك بنفس اللغة. تذكر أنني أجيب فقط على الأسئلة المتعلقة بالسياحة.",
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
            message: "حدث خطأ أثناء إرسال الرسالة",
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
        message: "حدث استثناء غير متوقع",
        errorDetails: e.toString(),
        previousState: AiChatLoaded(
          messages: List.from(_messages),
          isStreaming: false,
        ),
      ));
    }
  }
}
