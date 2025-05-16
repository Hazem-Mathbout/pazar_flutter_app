import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/advertisement_model.dart'; // Import car model
import 'package:pazar/app/data/models/seller_model.dart';

import '../controllers/conversation_controller.dart';
// Import widgets
import 'widgets/message_bubble.dart';
import 'widgets/message_input_bar.dart';

class ConversationScreen extends GetView<ConversationController> {
  const ConversationScreen({super.key});
  // Access carInfo from Get.arguments
  SellerModel? get seller => Get.arguments?['seller'] as SellerModel?;
  // CarInfoModel? get carInfo => Get.arguments?['carInfo'] as CarInfoModel?;

  @override
  Widget build(BuildContext context) {
    // Check if carInfo is passed
    // print("Car Info: ${carInfo?.name}");

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.borderDefault,
                  width: 1.0,
                ),
              ),
            ),
            child: AppBar(
              title: Transform.translate(
                offset: const Offset(12.0, 0),
                child: Row(
                  children: [
                    // CircleAvatar, bringing it closer to the leading button
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(seller!.imageUrl),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 12),
                    Text(seller!.name),
                  ],
                ),
              ),
              leading: IconButton(
                iconSize: 24,
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  textDirection: TextDirection.ltr,
                ),
                onPressed: () => Get.back(),
              ),
              centerTitle: false,
              elevation: 0.0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  reverse: false,
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return MessageBubble(message: message);
                  },
                ),
              ),
            ),
            MessageInputBar(
              controller: controller.messageController,
              onSendPressed: controller.sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
