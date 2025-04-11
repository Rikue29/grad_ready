import 'package:flutter/material.dart';
import 'login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 249, 115, 22), // Orange background color
      body: Stack(
        children: [
          // Background texture image
          Positioned.fill(
            child: Image.asset(
              'assets/img/texture.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.1), // Adjust opacity
            ),
          ),
          // Center the content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min, // Minimize the column size
              children: [
                Image.asset(
                  'assets/img/graduation.png', // Replace with your image path
                  height: 300,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Welcome to\nGradReady!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins', // Use the Poppins font family
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "\"Step Up with Confidence, from\nClassroom to Career\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF002147,
                    ), // Navy blue button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                  ),
                  child: const Text(
                    "Get Started  >",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
