// Represents a single message within a conversation
import 'package:pazar/app/data/models/advertisement_model.dart';

class ChatMessageModel {
  final String id; // Unique message ID
  final String text;
  final String senderId; // ID of the user who sent the message
  final int timestamp; // Unix timestamp (milliseconds since epoch)
  final Advertisement?
      carInfo; // Nullable field to hold the CarInfoModel instance

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.timestamp,
    this.carInfo, // Optional CarInfoModel (may be null)
  });

  // Example factory to create dummy messages (can be expanded)
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] ??
          DateTime.now()
              .millisecondsSinceEpoch
              .toString(), // Simple ID generation
      text: json['text'] ?? '',
      senderId: json['senderId'] ?? 'unknown',
      timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
      carInfo: json['carInfo'] != null
          ? Advertisement.fromJson(json['carInfo'])
          : null, // Deserialize carInfo if available
    );
  }

  // Helper to check if the message was sent by the current user
  // (We'll assume 'currentUser' is the ID for the local user for now)
  bool get isSentByMe => senderId == 'currentUser';
}
