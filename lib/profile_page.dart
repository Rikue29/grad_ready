import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      backgroundColor: const Color(0xFFFF6F00),
      body: SafeArea(
        child: Column(
          children: [_buildHeader(), Expanded(child: _buildProfileDetails())],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF10182F),
      width: double.infinity,
      child: const Center(
        child: Text(
          'Profile',
          style: TextStyle(
            color: Colors.orange,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileDetails() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/img/profile.jpg', // Make sure to add your image in the assets folder
              ), // Make sure you add this
            ),
            const SizedBox(height: 8),
            const Text(
              'Alpha Dog',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatsRow(),
            const Divider(color: Colors.white, thickness: 5, height: 15),
            _buildPersonalInfo(),
            const Divider(color: Colors.white, thickness: 5, height: 15),
            _buildSkills(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfo() {
    return Container(
      color: const Color(0xFF10182F),
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _InfoRow(icon: Icons.email, text: 'sarah.johnson@email.com'),
          SizedBox(height: 8),
          _InfoRow(icon: Icons.cake, text: 'Born June 15, 1995'),
          SizedBox(height: 8),
          _InfoRow(icon: Icons.location_on, text: 'San Francisco, CA'),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _StatItem(title: '24', label: 'Interviews'),
          _StatItem(title: '18', label: 'Presentations'),
          _StatItem(title: '92%', label: 'Fluency Rate'),
        ],
      ),
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

    return Container(
      color: const Color(0xFF10182F),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skills',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                skills.map((skill) {
                  final isOrange =
                      skill == 'Leadership' || skill == 'Team Management';
                  return Chip(
                    backgroundColor:
                        isOrange ? Colors.orange : Colors.blueGrey[100],
                    label: Text(
                      skill,
                      style: TextStyle(
                        color:
                            isOrange
                                ? Colors.white
                                : const Color.fromARGB(248, 0, 0, 0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
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
            color: Color.fromARGB(255, 224, 180, 115),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color.fromARGB(237, 3, 3, 3),
            fontWeight: FontWeight.bold,
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
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
