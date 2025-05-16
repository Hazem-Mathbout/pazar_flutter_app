// Represents the data needed for a single chat preview item in the list
class ChatPreviewModel {
  final String senderName;
  final String lastMessage;
  final String timestamp; // Keep as String for simplicity with dummy data
  final String chatId;
  final String avatarUrl;
  final bool isRead;

  ChatPreviewModel({
    required this.chatId,
    required this.senderName,
    required this.lastMessage,
    required this.timestamp,
    required this.avatarUrl,
    this.isRead = true, // Default to read for dummy data
  });

  // Factory for creating a list of dummy chat previews
  static List<ChatPreviewModel> getDummyPreviews() {
    // Using the same avatar for simplicity, replace with varied URLs if needed
    const dummyAvatar = "https://via.placeholder.com/150";
    // Example data based on the image
    return [
      ChatPreviewModel(
        senderName: "احمد خالد",
        lastMessage: "أنت: كم تريد سعر هذه السيارة",
        chatId: '1',
        timestamp: "8:07 PM",
        avatarUrl: dummyAvatar,
      ),
      ChatPreviewModel(
        senderName: "احمد خالد",
        lastMessage: "أنت: كم تريد سعر هذه السيارة",
        chatId: '2',
        timestamp: "8:07 PM",
        avatarUrl: dummyAvatar,
        isRead: false, // Example of an unread message
      ),
      ChatPreviewModel(
        senderName: "احمد خالد",
        lastMessage: "أنت: كم تريد سعر هذه السيارة",
        chatId: '3',
        timestamp: "8:07 PM",
        avatarUrl: dummyAvatar,
      ),
      ChatPreviewModel(
        senderName: "احمد خالد",
        lastMessage: "أنت: كم تريد سعر هذه السيارة",
        chatId: '4',
        timestamp: "8:07 PM",
        avatarUrl: dummyAvatar,
      ),
      ChatPreviewModel(
        senderName: "محمد علي", // Different name example
        lastMessage: "شكراً جزيلاً!",
        chatId: '5',
        timestamp: "7:30 PM",
        avatarUrl: "https://via.placeholder.com/151", // Different avatar
      ),
      ChatPreviewModel(
        senderName: "سارة حسين", // Another name
        lastMessage: "تمام، سأكون هناك.",
        chatId: '6',
        timestamp: "Yesterday",
        avatarUrl: "https://via.placeholder.com/152",
      ),
    ];
  }
}
