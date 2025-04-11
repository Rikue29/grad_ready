import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF6B00), // Orange background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2632),
        title: const Text(
          "Settings",
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
              'assets/images/texture.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.all(16.0), // Add padding around the content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserTile(),
                  const SizedBox(height: 20),
                  _buildSection("Account Settings", [
                    _buildSettingItem(
                        Icons.person_outline, "Personal Information"),
                    _buildSettingItem(
                        Icons.security_outlined, "Privacy & Security"),
                    _buildSettingItem(
                        Icons.notifications_none, "Notifications"),
                  ]),
                  const SizedBox(height: 20),
                  _buildSection("Connected Accounts", [
                    _buildConnectedAccount(
                      "Google",
                      "Connected",
                      const Color.fromARGB(255, 12, 129, 16),
                    ),
                    _buildConnectedAccount(
                      "LinkedIn",
                      "Connect",
                      const Color.fromARGB(255, 15, 80, 133),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _buildSection("Support & Help", [
                    _buildSettingItem(Icons.help_outline, "Help Center"),
                    _buildSettingItem(
                        Icons.contact_mail_outlined, "Contact Support"),
                    _buildSettingItem(
                        Icons.description_outlined, "Terms & Privacy Policy"),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: 2, // Set to 2 for the settings page
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/profile');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/home');
          } else if (index == 2) {
            // Stay on the current page
          }
        },
      ),
    );
  }

  Widget _buildUserTile() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage("assets/img/profile.jpg"),
          radius: 26,
        ),
        title: const Text(
          "Alpha Dog",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: const Text("alphaD@email.com"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to profile details/edit
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Add navigation if needed
      },
    );
  }

  Widget _buildConnectedAccount(String platform, String status, Color color) {
    return ListTile(
      leading: _getPlatformIcon(platform),
      title: Text(
        platform,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Text(
        status,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      onTap: () {
        // Add action for linking/unlinking
      },
    );
  }

  Widget _getPlatformIcon(String platform) {
    switch (platform) {
      case "Google":
        return const Icon(Icons.g_mobiledata, color: Colors.red, size: 28);
      case "LinkedIn":
        return const Icon(Icons.link, color: Colors.blue, size: 20);
      default:
        return const Icon(Icons.device_unknown);
    }
  }
}
