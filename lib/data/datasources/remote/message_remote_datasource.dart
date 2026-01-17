import '../../../core/network/api_client.dart';

class MessageRemoteDatasource {
  final ApiClient _apiClient;

  MessageRemoteDatasource(this._apiClient);

  /// Send a message to a user via HTTP endpoint
  /// Note: The backend also supports WebSocket, but for admin web panel, HTTP is simpler
  Future<Map<String, dynamic>> sendMessage({
    required int recipientId,
    required String messageText,
  }) async {
    try {
      final response = await _apiClient.post(
        '/messages/ws',
        data: {
          'type': 'send_message',
          'recipient_id': recipientId,
          'message_text': messageText,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      rethrow;
    }
  }

  /// Get all conversations (list of users the admin has messaged)
  Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final response = await _apiClient.get('/messages');
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>? ?? responseData;
      final conversations = data['conversations'] as List<dynamic>? ?? [];
      return conversations.map((c) => c as Map<String, dynamic>).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Get conversation with a specific user
  Future<List<Map<String, dynamic>>> getConversationWithUser(int userId) async {
    try {
      final response = await _apiClient.get('/messages/$userId');
      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>? ?? responseData;
      final messages = data['messages'] as List<dynamic>? ?? [];
      return messages.map((m) => m as Map<String, dynamic>).toList();
    } catch (e) {
      rethrow;
    }
  }
}
