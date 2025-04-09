import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 16),
            _buildUserTile(),
            const Divider(thickness: 1.3, color: Color(0xFF10182F)),
            _buildSectionTitle("Account Settings"),
            _buildSettingItem(Icons.person_outline, "Personal Information"),
            _buildSettingItem(Icons.security_outlined, "Privacy & Security"),
            _buildSettingItem(Icons.notifications_none, "Notifications"),
            const Divider(thickness: 1.3, color: Color(0xFF10182F)),
            _buildSectionTitle("Connected Accounts"),
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
            const Divider(thickness: 1.3, color: Color(0xFF10182F)),
            _buildSectionTitle("Support & Help"),
            _buildSettingItem(Icons.help_outline, "Help Center"),
            _buildSettingItem(Icons.contact_mail_outlined, "Contact Support"),
            _buildSettingItem(
              Icons.description_outlined,
              "Terms & Privacy Policy",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF10182F),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: const SafeArea(
        child: Center(
          child: Text(
            "Settings",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTile() {
    return ListTile(
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildSettingItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold), // <-- Bold here
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
        ), // <-- Bold platform
      ),
      trailing: Text(
        status,
        style: TextStyle(
          fontWeight: FontWeight.bold, // <-- Bold status
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
