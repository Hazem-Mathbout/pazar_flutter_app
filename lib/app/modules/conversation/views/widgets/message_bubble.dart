import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl; // For formatting timestamp
import 'package:pazar/app/core/values/colors.dart'; // Assuming colors are defined here
import 'package:pazar/app/data/models/chat_message_model.dart';
import 'package:pazar/app/modules/cars/views/widgets/car_card.dart'; // Import the message model

class MessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSentByMe = message.isSentByMe;
    final alignment = isSentByMe ? Alignment.centerRight : Alignment.centerLeft;
    Color bubbleColor =
        isSentByMe ? AppColors.backgroundBrand : AppColors.backgroundDefault;

    bubbleColor = message.carInfo != null ? Colors.transparent : bubbleColor;
    final textColor = isSentByMe ? Colors.white : AppColors.foregroundSecondary;
    // Use different border radius for sent/received bubbles based on the image
    final borderRadius = isSentByMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(16), // Less rounded corner
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(16), // Less rounded corner
            bottomRight: Radius.circular(24),
          );

    // Format the timestamp (example: 11:31)
    final formattedTime = intl.DateFormat('HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(message.timestamp));

    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isSentByMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Padding(
            // Add padding to align time correctly under the bubble
            padding: EdgeInsets.only(
                left: isSentByMe ? 8 : 0, right: isSentByMe ? 0 : 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "محمد",
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    letterSpacing: 0.0,
                    color: AppColors.foregroundHint,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  formattedTime,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    letterSpacing: 0.0,
                    color: AppColors.foregroundHint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Container(
            clipBehavior: Clip.antiAlias,
            constraints: BoxConstraints(
              // Limit bubble width to prevent it taking full screen width
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: message.carInfo != null
                ? EdgeInsets.zero
                : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: borderRadius, // Same borderRadius for both
            ),
            child: message.carInfo != null
                ? Container(
                    padding: EdgeInsets.zero,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius, // Same as outer
                      border: Border.all(color: Colors.red),
                    ),
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: borderRadius,
                      child: CarCard(
                        advertisement: message.carInfo!,
                        // applyRadius: false,
                      ),
                    ),
                  )
                : Text(
                    message.text,
                    style: TextStyle(color: textColor, fontSize: 15),
                    textAlign: isSentByMe ? TextAlign.left : TextAlign.right,
                  ),
          )
        ],
      ),
    );
  }
}
