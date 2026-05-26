import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../theme/colors/app_colors.dart';
import '../../../core/network/api_client.dart';
import '../../../constants/api_constants.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _addWelcome();
  }

  void _addWelcome() {
    _messages.add(_ChatMessage(
      text: '¡Hola! Soy el asistente de Mission Code. Puedo ayudarte con:\n\n• Tu progreso y puntos\n• Conceptos de Ingeniería de Software\n• Misiones disponibles\n• Dudas académicas\n\n¿En qué puedo ayudarte hoy?',
      isUser: false,
    ));
  }

  Future<void> _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, isUser: true));
      _msgCtrl.clear();
      _sending = true;
    });
    _scrollToBottom();

    try {
      final response = await ApiClient.instance.post(
        ApiConstants.enviarMensaje,
        data: {'mensaje': text},
      );
      final respuesta = response.data['respuesta_asistente'] ?? '';
      setState(() {
        _messages.add(_ChatMessage(text: respuesta, isUser: false));
        _sending = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(
          text: 'Error al contactar el asistente. Intenta de nuevo.',
          isUser: false,
          isError: true,
        ));
        _sending = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg800,
      appBar: AppBar(
        backgroundColor: AppColors.bg900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
        title: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.neonPurple.withOpacity(0.2),
            ),
            child: const Icon(Icons.smart_toy_outlined, color: AppColors.neonPurple, size: 20),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Asistente Mission Code', style: TextStyle(
                color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600,
              )),
              Text('IA académica', style: TextStyle(
                color: AppColors.textMuted, fontSize: 11,
              )),
            ],
          ),
        ]),
      ),
      body: Column(
        children: [
          // Mensajes
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_sending ? 1 : 0),
              itemBuilder: (context, i) {
                if (_sending && i == _messages.length) {
                  return _TypingIndicator();
                }
                return _ChatBubble(
                  message: _messages[i],
                  index: i,
                );
              },
            ),
          ),
          // Input
          _buildInput(),
        ],
      ),
    );
  }

  Widget _buildInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.bg900,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _msgCtrl,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            onSubmitted: (_) => _sendMessage(),
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Escribe tu mensaje...',
              hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
              filled: true,
              fillColor: AppColors.surface600,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.neonPurple, width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _sendMessage,
          child: Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.neonPurple, AppColors.neonBlue],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.send_outlined, color: Colors.white, size: 20),
          ),
        ),
      ]),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final bool isError;
  _ChatMessage({required this.text, required this.isUser, this.isError = false});
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  final int index;
  const _ChatBubble({required this.message, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neonPurple.withOpacity(0.2),
              ),
              child: const Icon(Icons.smart_toy_outlined, color: AppColors.neonPurple, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.neonPurple.withOpacity(0.2)
                    : message.isError
                        ? AppColors.danger.withOpacity(0.1)
                        : AppColors.surface600,
                borderRadius: BorderRadius.only(
                  topLeft:     const Radius.circular(16),
                  topRight:    const Radius.circular(16),
                  bottomLeft:  Radius.circular(message.isUser ? 16 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 16),
                ),
                border: Border.all(
                  color: message.isUser
                      ? AppColors.neonPurple.withOpacity(0.3)
                      : AppColors.border,
                ),
              ),
              child: Text(message.text, style: TextStyle(
                color: message.isError ? AppColors.danger : AppColors.textPrimary,
                fontSize: 13, height: 1.6,
              )),
            ),
          ),
        ],
      ),
    ).animate(delay: Duration(milliseconds: 50 * index.clamp(0, 10))).fadeIn().slideY(begin: 0.1);
  }
}

class _TypingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.neonPurple.withOpacity(0.2),
            ),
            child: const Icon(Icons.smart_toy_outlined, color: AppColors.neonPurple, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface600,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: List.generate(3, (i) =>
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                width: 6, height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.textMuted, shape: BoxShape.circle,
                ),
              ).animate(onPlay: (c) => c.repeat())
               .fadeIn(delay: Duration(milliseconds: 200 * i))
               .then().fadeOut(delay: 300.ms),
            )),
          ),
        ],
      ),
    );
  }
}