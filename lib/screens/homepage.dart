// Adding these exports at the top of the file so they can be imported from login.dart
export 'homepage.dart' show HomePageStateful, HomePageStatefulState;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_navbar.dart';
import '../screens/profile_page.dart';
import '../screens/settings_page.dart';
import '../screens/presentation_homepage.dart';
import '../screens/interview_role.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import './gcp_test.dart';
import './gemini_test.dart';
import 'package:gradready_interview/screens/gemini_test_page.dart';

class HomePageStateful extends StatefulWidget {
  const HomePageStateful({super.key});

  @override
  State<HomePageStateful> createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<HomePageStateful>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 1; // Start with Home tab selected
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFFF6B00), // Orange background to match login page
      appBar: AppBar(
        backgroundColor:
            const Color(0xFF1C2632), // Keeping the original dark color
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school,
                  color: Colors.white,
                  size: 32), // Changed icon color to white for better contrast
              SizedBox(width: 8),
              Text(
                "GradReady",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud, color: Colors.white),
            tooltip: 'GCP Test',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GCPTestPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.psychology, color: Colors.white),
            tooltip: 'Gemini AI Test',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GeminiTestPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background with texture overlay, matching login page style
          Positioned.fill(
            child: Image.asset(
              'assets/images/texture.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.1), // Adjust opacity
            ),
          ),
          // Home content with animations
          FadeTransition(
            opacity: _fadeAnimation,
            child: const HomeContent(),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Handle navigation based on index
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
                break;
              case 1:
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePageStateful()),
                  (route) => false,
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
                break;
            }
          });
        },
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: AnimationLimiter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            childAnimationBuilder: (widget) => SlideAnimation(
              horizontalOffset: 50.0,
              child: FadeInAnimation(child: widget),
            ),
            children: [
              _buildTopBar(),
              const SizedBox(height: 16),
              _buildWeekTracker(),
              const SizedBox(height: 20), // Keep the reduced spacing here
              _buildHeaderTitle(),
              const SizedBox(height: 24), // Revert back to original spacing
              _buildModeSelection(context),
              const Spacer(),
              _buildTipCard(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.psychology_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            "Choose Your Mode",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E2C3D),
            const Color(0xFF10182F),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOTAL XP',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xFFFF6B00),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '7,176 XP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF6B00),
                  Color(0xFFFF9248),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B00).withOpacity(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                )
              ],
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 6),
                Text(
                  '2 days',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
      Icons.check_circle,
      Icons.check_circle,
      Icons.check_circle,
      Icons.check_circle,
      Icons.check_circle,
      Icons.circle_outlined,
      Icons.circle_outlined,
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E2C3D),
            const Color(0xFF10182F),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(0, 4),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 8),
            child: Text(
              'Weekly Progress',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final isComplete = index < 5;
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isComplete
                          ? const Color(0xFFFF6B00).withOpacity(0.2)
                          : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icons[index],
                      color: isComplete
                          ? const Color(0xFFFF6B00)
                          : Colors.white.withOpacity(0.4),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    days[index],
                    style: TextStyle(
                      color: isComplete
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildModeCard(
              "Presentation Mode",
              "Master your presentation skills",
              Icons.slideshow_rounded,
              'assets/img/presentation.jpg',
              context,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildModeCard(
              "Interview Mode",
              "Practice interview skills",
              Icons.record_voice_over_rounded,
              'assets/img/interviewperson.jpg',
              context,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard(
    String title,
    String subtitle,
    IconData icon,
    String imagePath,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        if (title.contains("Presentation")) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PresentationHomePage()),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InterviewRoleScreen()),
          );
        }
      },
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8), // Reduced vertical margin from 16
      padding: const EdgeInsets.symmetric(
          vertical: 16, horizontal: 20), // Reduced vertical padding from 20
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E2C3D),
            const Color(0xFF10182F),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B00).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.tips_and_updates_rounded,
              color: Color(0xFFFF6B00),
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Today's Tip",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B00).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "NEW",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B00),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Spend 15 minutes daily practicing your skills. Consistency is key to mastering interviews and presentations!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
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
