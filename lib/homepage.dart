import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profile_page.dart';
import 'settings_page.dart';

Widget build(BuildContext context) {
  // Set status bar color and icon brightness
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xFF10182F), // Match header color
      statusBarIconBrightness: Brightness.light,
    ),
  );

  return const HomePageStateful(); // Use the stateful widget for the homepage
}

class HomePageStateful extends StatefulWidget {
  const HomePageStateful({super.key});

  @override
  State<HomePageStateful> createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<HomePageStateful> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: const Center(child: Text('Welcome to the Home Page!')),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTopBar(),
          const SizedBox(height: 16),
          _buildWeekTracker(),
          const SizedBox(height: 90),
          const Center(
            child: Text(
              "Choose Your Mode:",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildModeSelection(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF10182F),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'TOTAL XP\n7,176 XP',
            style: TextStyle(color: Colors.orange, fontSize: 18),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 6),
                Text('2 days', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekTracker() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final icons = [
      Icons.flash_on,
      Icons.flash_on,
      Icons.flash_on,
      null,
      null,
      null,
      null,
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF10182F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(days.length, (index) {
          return Column(
            children: [
              if (icons[index] != null)
                Icon(
                  icons[index],
                  color:
                      icons[index] == Icons.ac_unit
                          ? Colors.blue
                          : Colors.yellow,
                )
              else
                const Icon(Icons.circle_outlined, color: Colors.grey),
              const SizedBox(height: 8),
              Text(days[index], style: const TextStyle(color: Colors.white)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildModeSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildModeCard(
              "Presentation",
              imagePath: 'assets/img/presentation.jpg', // Correct image path
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: _buildModeCard(
              "Interview",
              imagePath: 'assets/img/interviewperson.jpg', // Correct image path
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard(String title, {String? imagePath}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Your onTap logic here
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display image as the icon for the mode
              imagePath != null
                  ? Image.asset(
                    imagePath,
                    height: 80,
                    width: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.error,
                        size: 60,
                        color: Colors.red,
                      );
                    },
                  )
                  : const Icon(Icons.error, size: 60, color: Colors.red),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
