import 'package:flutter/material.dart';
import 'package:grad_ready/main.dart';
import 'homepage.dart'; // Import your homepage.dart file
import 'profile_page.dart'; // Import your profile page
import 'settings_page.dart'; // Import your settings page

void main() {
  runApp(const MyApp());
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1; // Default to 'Home'

late final List<Widget> _pages;

@override
void initState() {
  super.initState();
  _pages = [
    const ProfilePage(), // Profile Page
    Container(), // HomePage content
    const SettingsPage(), // Settings Page
  ];
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6F00), // Orange background
      body: _currentIndex == 1
          ? SafeArea(
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
            )
          : _pages[_currentIndex], // Display Profile or Settings Page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the selected index
          });
        },
        backgroundColor: const Color(0xFF10182F),
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF10182F), // Dark blue background
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
                Icon(Icons.local_fire_department, color: Colors.white, size: 18),
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
    const days = ['o', 'T', 'W', 'T', 'F', 'S', 'S'];
    final icons = [
      Icons.ac_unit, // Blue snowflake
      Icons.flash_on, // Yellow lightning
      Icons.flash_on,
      null,
      null,
      null,
      null
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
                  color: icons[index] == Icons.ac_unit ? Colors.blue : Colors.yellow,
                )
              else
                const Icon(Icons.circle_outlined, color: Colors.grey),
              const SizedBox(height: 4),
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
            child: _buildModeCard("Presentation", "assets/presentation.png"),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildModeCard("Interview", "assets/interview.png"),
          ),
        ],
      ),
    );
  }

Widget _buildModeCard(String title, String imagePath) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.white, width: 2),
    ),
    child: Column(
      children: [
        Image.asset(
          imagePath,
          height: 80,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, color: Colors.red, size: 80);
          },
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
}