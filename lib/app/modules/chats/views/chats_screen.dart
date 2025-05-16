import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/data/models/chat_preview_model.dart'; // Import the model
import 'package:pazar/app/modules/chats/views/widgets/chat_list_item.dart'; // Import the list item widget

import '../controllers/chats_controller.dart';

class ChatsScreen extends GetView<ChatsController> {
  const ChatsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('المحادثات'), // Title from the image
        titleTextStyle: const TextStyle(
          fontFamily: 'Rubik',
          fontWeight: FontWeight.w500,
          fontSize: 14,
          height:
              1.42857, // 20px / 14px = 1.42857 (line-height in Flutter is a multiplier)
          letterSpacing: 0.0,
          color: Colors.black,
        ),
        centerTitle: false, // Center title as in the image
        elevation: 0.0, // Slight shadow like the image
        backgroundColor: Colors.white, // White background
        foregroundColor: Colors.black, // Black text/icons
      ),
      // Use ListView.builder to display the list of chats
      body: ListView.builder(
        itemCount: ChatPreviewModel.getDummyPreviews().length,
        itemBuilder: (context, index) {
          final chatPreview = ChatPreviewModel.getDummyPreviews()[index];
          return ChatListItem(chatPreview: chatPreview);
        },
      ),
    );
  }
}
