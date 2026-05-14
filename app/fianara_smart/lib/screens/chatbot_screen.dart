import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // Message de bienvenue
    _messages.add({
      'isUser': false,
      'message':
          'Bonjour ! Je suis l\'assistant virtuel de Fianara Smart City. Comment puis-je vous aider ?',
      'time': DateTime.now(),
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _messages.add({
      'isUser': true,
      'message': userMessage,
      'time': DateTime.now(),
    });
    _messageController.clear();
    _scrollToBottom();
    setState(() {});

    // Simuler la réponse du chatbot
    _simulateResponse(userMessage);
  }

  void _simulateResponse(String userMessage) {
    setState(() {
      _isTyping = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      String response = _getResponse(userMessage);
      setState(() {
        _messages.add({
          'isUser': false,
          'message': response,
          'time': DateTime.now(),
        });
        _isTyping = false;
        _scrollToBottom();
      });
    });
  }

  String _getResponse(String message) {
    final msg = message.toLowerCase();

    if (msg.contains('bonjour') || msg.contains('salut')) {
      return 'Bonjour ! Comment puis-je vous aider aujourd\'hui ?';
    } else if (msg.contains('signalement') || msg.contains('probleme')) {
      return 'Pour signaler un problème, allez dans l\'onglet "Signalements" et cliquez sur le bouton +. Vous pourrez décrire le problème et ajouter une photo.';
    } else if (msg.contains('annonce') || msg.contains('info')) {
      return 'Consultez l\'onglet "Annonces" pour voir toutes les actualités et informations importantes de la ville.';
    } else if (msg.contains('carte') || msg.contains('localisation')) {
      return 'La carte interactive vous permet de voir tous les signalements près de chez vous. Vous pouvez aussi y ajouter votre position.';
    } else if (msg.contains('profil') || msg.contains('compte')) {
      return 'Dans votre profil, vous pouvez modifier vos informations personnelles et voir l\'historique de vos signalements.';
    } else if (msg.contains('merci')) {
      return 'Avec plaisir ! N\'hésitez pas si vous avez d\'autres questions.';
    } else if (msg.contains('aide') || msg.contains('help')) {
      return 'Voici ce que je peux faire :\n• Vous aider à signaler un problème\n• Vous informer sur les annonces\n• Vous guider sur la carte\n• Répondre à vos questions sur le profil\nQue souhaitez-vous savoir ?';
    } else {
      return 'Je n\'ai pas bien compris votre demande. Voici ce que je peux faire :\n• Aide pour les signalements\n• Informations sur les annonces\n• Utilisation de la carte\n• Gestion du profil\nPouvez-vous reformuler votre question ?';
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text('Assistant Virtuel'),
          ],
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                final message = _messages[index];
                return _buildMessageBubble(
                  message: message['message'],
                  isUser: message['isUser'],
                  time: message['time'],
                );
              },
            ),
          ),

          // Zone de saisie
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Écrivez votre message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required String message,
    required bool isUser,
    required DateTime time,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight:
                isUser ? const Radius.circular(4) : const Radius.circular(16),
            bottomLeft:
                !isUser ? const Radius.circular(4) : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(
                color: isUser ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${time.hour}:${time.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: isUser ? Colors.white70 : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTypingDot(0),
            const SizedBox(width: 4),
            _buildTypingDot(1),
            const SizedBox(width: 4),
            _buildTypingDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
