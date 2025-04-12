import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_navbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar color and icon brightness
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF10182F), // Match header color
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFF6B00),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10182F),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Change back button color to white
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.psychology, color: Colors.white),
            tooltip: 'Gemini AI Test',
            onPressed: () {
              Navigator.pushNamed(context, '/gemini-test');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background color and image
          Positioned.fill(
            child: Image.asset(
              'assets/images/texture.png', // Replace with your image path
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.1), // Overlay effect
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 20),
                    _buildStatsRow(),
                    const SizedBox(height: 20),
                    _buildSectionCard(
                        "Personal Information", _buildPersonalInfo()),
                    const SizedBox(height: 20),
                    _buildSectionCard("Skills", _buildSkills()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 0, // Set to 0 for the profile page
        onTap: (index) {
          if (index == 0) {
            // Stay on the current page
          } else if (index == 1) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/settings');
          }
        },
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/img/profile.jpg', // Make sure to add your image in the assets folder
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Alpha Dog',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'alphaD@email.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            _StatItem(title: '24', label: 'Interviews'),
            _StatItem(title: '18', label: 'Presentations'),
            _StatItem(title: '92%', label: 'Fluency Rate'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, Widget content) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _InfoRow(icon: Icons.email, text: 'sarah.johnson@email.com'),
        SizedBox(height: 8),
        _InfoRow(icon: Icons.cake, text: 'Born June 15, 1995'),
        SizedBox(height: 8),
        _InfoRow(icon: Icons.location_on, text: 'San Francisco, CA'),
      ],
    );
  }

  Widget _buildSkills() {
    final skills = [
      'Public Speaking',
      'Leadership',
      'Communication',
      'Problem Solving',
      'Team Management',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) {
        final isOrange = skill == 'Leadership' || skill == 'Team Management';
        return Chip(
          backgroundColor: isOrange ? Colors.orange : Colors.blueGrey[100],
          label: Text(
            skill,
            style: TextStyle(
              color: isOrange ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String label;

  const _StatItem({required this.title, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
