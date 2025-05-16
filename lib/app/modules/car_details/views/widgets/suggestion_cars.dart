// import 'package:flutter/material.dart';
// import 'package:pazar/app/modules/home/views/widgets/car_card.dart';

// class SuggestionCars extends StatelessWidget {
//   const SuggestionCars({super.key});

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     double screenHeight = MediaQuery.of(context).size.height;

//     return SizedBox(
//       height: screenHeight * 0.3, // 30% of screen height (adaptive)
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 24.0),
//         itemCount: dummyAdvertisementList.length,
//         itemBuilder: (context, index) {
//           final car = dummyAdvertisementList[index];
//           return Padding(
//             padding:
//                 EdgeInsets.only(left: screenWidth * 0.02), // 3% of screen width
//             child: SizedBox(
//               width: screenWidth * 0.45, // 40% of screen width
//               child: CarCard(
//                 car: car,
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
