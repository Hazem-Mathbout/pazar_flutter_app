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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // Background image (fills entire screen)
          SizedBox.expand(
            child: Image.asset(
              'assets/images/bg.png',
              fit: BoxFit.fill,
            ),
          ),
          // Centered animated logo
          Center(
            child: ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/images/logo_alone.png',
                width: screenWidth * 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
