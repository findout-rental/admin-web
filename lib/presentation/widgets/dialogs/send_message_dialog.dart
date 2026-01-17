import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/datasources/remote/message_remote_datasource.dart';
import '../../../core/network/api_client.dart';

class SendMessageDialog extends StatefulWidget {
  final int recipientId;
  final String recipientName;

  const SendMessageDialog({
    Key? key,
    required this.recipientId,
    required this.recipientName,
  }) : super(key: key);

  @override
  State<SendMessageDialog> createState() => _SendMessageDialogState();
}

class _SendMessageDialogState extends State<SendMessageDialog> {
  final TextEditingController _messageController = TextEditingController();
  final MessageRemoteDatasource _messageDatasource = MessageRemoteDatasource(ApiClient());
  bool _isLoading = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    
    if (messageText.isEmpty) {
      Get.snackbar('error'.tr, 'message_cannot_be_empty'.tr);
      return;
    }

    if (messageText.length > 2000) {
      Get.snackbar('error'.tr, 'message_too_long'.tr);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _messageDatasource.sendMessage(
        recipientId: widget.recipientId,
        messageText: messageText,
      );

      if (mounted) {
        Get.back(); // Close dialog
        Get.snackbar('success'.tr, 'message_sent_successfully'.tr);
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'error'.tr,
          'failed_to_send_message'.tr + ': ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'send_message'.tr,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'to'.tr + ' ${widget.recipientName}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),

            // Message input
            TextField(
              controller: _messageController,
              maxLines: 8,
              maxLength: 2000,
              decoration: InputDecoration(
                hintText: 'type_your_message'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                labelText: 'message'.tr,
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isLoading ? null : () => Get.back(),
                  child: Text('cancel'.tr),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendMessage,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('send'.tr),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
