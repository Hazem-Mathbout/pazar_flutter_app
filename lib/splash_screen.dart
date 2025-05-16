// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class CustomSplashScreen extends StatefulWidget {
//   const CustomSplashScreen({super.key});

//   @override
//   State<CustomSplashScreen> createState() => _CustomSplashScreenState();
// }

// class _CustomSplashScreenState extends State<CustomSplashScreen> {
//   final List<String> messages = [
//     '🚗 أفضل مكان لشراء سيارتك القادمة.',
//     '🛠 بع سيارتك بسهولة وأمان.',
//     '💼 استكشف آلاف السيارات المعروضة الآن.',
//   ];

//   int _currentIndex = 0;
//   late Timer _timer;

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
//       setState(() {
//         _currentIndex = (_currentIndex + 1) % messages.length;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       backgroundColor: isDark ? Colors.black : Colors.white,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final logoSize = screenWidth * 0.4;
//           final lottieSize = screenWidth * 0.5;
//           final textFontSize = screenHeight * 0.02;

//           return Center(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Image.asset(
//                     'assets/images/splash_logo.png',
//                     width: logoSize.clamp(100.0, 220.0),
//                   ),
//                   SizedBox(height: screenHeight * 0.03),
//                   SizedBox(
//                     height: lottieSize.clamp(120.0, 260.0),
//                     width: lottieSize.clamp(120.0, 260.0),
//                     child: Lottie.asset(
//                       'assets/lottie/car.json',
//                       repeat: true,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.04),
//                   AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 300),
//                     transitionBuilder: (child, animation) =>
//                         FadeTransition(opacity: animation, child: child),
//                     child: Text(
//                       messages[_currentIndex],
//                       key: ValueKey(_currentIndex),
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: textFontSize.clamp(14.0, 20.0),
//                         color: isDark ? Colors.white : Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Rubik', // or 'Cairo' for Arabic
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomSplashScreen extends StatefulWidget {
  const CustomSplashScreen({super.key});

  @override
  State<CustomSplashScreen> createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            'assets/images/splash_logo.png',
            width: screenWidth * 0.45,
          ),
        ),
      ),
    );
  }
}
