import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pazar/app/core/values/colors.dart';
import 'package:pazar/app/data/models/seller_model.dart';
import 'package:pazar/app/routes/app_pages.dart';

import 'package:pazar/app/data/models/chat_preview_model.dart';

class ChatListItem extends StatelessWidget {
  final ChatPreviewModel chatPreview;

  const ChatListItem({
    super.key,
    required this.chatPreview,
  });

  @override
  Widget build(BuildContext context) {
    // Determine text style based on read status
    final messageStyle = TextStyle(
      fontSize: 14,
      color: chatPreview.isRead ? AppColors.foregroundHint : Colors.black87,
      fontWeight: chatPreview.isRead ? FontWeight.normal : FontWeight.bold,
    );
    final nameStyle = TextStyle(
      fontSize: 14,
      fontWeight: chatPreview.isRead ? FontWeight.w500 : FontWeight.bold,
      color: AppColors.foregroundPrimary,
    );

    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.CONVERSATION,
          arguments: {
            'chatId': chatPreview.chatId,
            'seller': SellerModel.dummy(),
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(chatPreview.avatarUrl),
              onBackgroundImageError: (exception, stackTrace) {
                print('Error loading avatar: $exception');
              },
              backgroundColor: Colors.grey[200],
            ),

            // Name, message and timestamp
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and timestamp row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            chatPreview.senderName,
                            style: nameStyle,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          chatPreview.timestamp,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.foregroundHint,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Last message
                    Text(
                      chatPreview.lastMessage,
                      style: messageStyle,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
