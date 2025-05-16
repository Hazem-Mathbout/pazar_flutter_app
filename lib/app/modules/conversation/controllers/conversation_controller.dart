import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/data/models/chat_message_model.dart';
// Import message and car models later when created
// import 'package:pazar/app/data/models/chat_message_model.dart';
// import 'package:pazar/app/data/models/car_info_model.dart';

class ConversationController extends GetxController {
  //TODO: Implement ConversationController

  // Example: Hold the list of messages
  var messages = <ChatMessageModel>[]
      .obs; // Use dynamic list to hold messages and potentially car card info
  // Example: Hold car info if passed via arguments
  var carInfo = Rxn<dynamic>(); // Placeholder for car info model
  // Example: Hold recipient info
  var recipientName = "User Name".obs; // Placeholder
  var recipientAvatar = "https://via.placeholder.com/150".obs; // Placeholder

  // Text controller for the input field
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Check arguments passed during navigation
    if (Get.arguments != null) {
      // Case 1: Coming from Car Details
      if (Get.arguments['carInfo'] != null) {
        carInfo.value = Get.arguments['carInfo']; // Store car info
        recipientName.value = Get.arguments['recipient']?['name'] ??
            "Seller"; // Get recipient name
        recipientAvatar.value = Get.arguments['recipient']?['avatarUrl'] ??
            "https://via.placeholder.com/150"; // Get recipient avatar

        // Add the car card and initial message to the list (using placeholders for now)
        messages.add(
          ChatMessageModel(
            id: "1",
            carInfo: null,
            text: "انا مهتم بسيارتك",
            senderId: "currentUser",
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );

        messages.add(
          ChatMessageModel(
            id: "2",
            carInfo: Get.arguments['carInfo'],
            text: "انا مهتم بسيارتك",
            senderId: "currentUser",
            timestamp: DateTime.now().millisecondsSinceEpoch,
          ),
        );

        // TODO: Load actual chat history if it exists for this user/car combo
      }
      // // Case 2: Coming from Chat List
      // else if (Get.arguments['chatId'] != null) {
      //   recipientName.value =
      //       Get.arguments['recipient']?['name'] ?? "User Name";
      //   recipientAvatar.value = Get.arguments['recipient']?['avatarUrl'] ??
      //       "https://via.placeholder.com/150";
      //   // TODO: Load existing messages for chatId
      //   _loadDummyMessages(); // Load dummy messages for now
      // }
      else {
        // Default case or error handling
        _loadDummyMessages();
      }
    } else {
      // Default: Load dummy messages if no arguments
      _loadDummyMessages();
    }
  }

  void _loadDummyMessages() {
    // Add some dummy messages for testing
    messages.addAll([
      ChatMessageModel.fromJson({
        'type': 'message',
        'text': "مرحبا",
        'senderId': 'otherUser',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 5))
            .millisecondsSinceEpoch
      }),
      ChatMessageModel.fromJson({
        'type': 'message',
        'text': "كيف يمكنني مساعدتك؟",
        'senderId': 'otherUser',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 4))
            .millisecondsSinceEpoch
      }),
      ChatMessageModel.fromJson({
        'type': 'message',
        'text': "لقد رأيت السيارة التي أدرجتها",
        'senderId': 'currentUser',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 2))
            .millisecondsSinceEpoch
      }),
      ChatMessageModel.fromJson({
        'type': 'message',
        'text': "كم تريد سعر هذه السيارة",
        'senderId': 'currentUser',
        'timestamp': DateTime.now()
            .subtract(const Duration(minutes: 1))
            .millisecondsSinceEpoch
      }),
    ]);
  }

  void sendMessage() {
    final text = messageController.text.trim();
    if (text.isNotEmpty) {
      // Add the new message to the list (assuming sender is currentUser)
      messages.add(ChatMessageModel.fromJson({
        'type': 'message',
        'text': text,
        'senderId': 'currentUser',
        'timestamp': DateTime.now().millisecondsSinceEpoch
      }));
      messageController.clear();
      // TODO: Implement actual sending logic (API call)
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}
