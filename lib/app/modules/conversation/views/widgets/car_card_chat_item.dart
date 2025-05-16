import 'package:flutter/material.dart';
import 'package:pazar/app/data/models/advertisement_model.dart';
import 'package:pazar/app/modules/home/views/widgets/car_card.dart'; // Import the car model

class CarCardChatItem extends StatelessWidget {
  final Advertisement carInfo;

  const CarCardChatItem({
    super.key,
    required this.carInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 40.0, vertical: 8.0), // Indent like a message bubble
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white, // White background for the card
        borderRadius: BorderRadius.circular(16.0), // Rounded corners
        border: Border.all(color: Colors.red),
      ),
      child: CarCard(
        advertisement: carInfo,
      ),
    );
  }
}
