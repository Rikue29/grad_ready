import 'package:flutter/material.dart';
import '../widgets/custom_navbar.dart';
import 'interview_mock.dart';

class InterviewRoleScreen extends StatefulWidget {
  const InterviewRoleScreen({super.key});

  @override
  State<InterviewRoleScreen> createState() => _InterviewRoleScreenState();
}

class _InterviewRoleScreenState extends State<InterviewRoleScreen> {
  final TextEditingController roleController = TextEditingController();
  String selectedField = 'Computer Science';
  final List<String> fields = ['Computer Science', 'Education', 'Accounting'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF1C2632), // Dark background like InterviewMockScreen
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2632),
        title: const Text(
          'Mock Interview',
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
          color: Colors.white,
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildInstructionCard(),
              const SizedBox(height: 24),
              _buildSelectionCard(),
              const SizedBox(height: 100), // Space for the bottom navigation
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex:
            1, // Set to 1 as we consider this part of the home navigation
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/profile');
          } else if (index == 1) {
            // Navigate to Home Page
            Navigator.pushNamedAndRemoveUntil(
                context, 'home', (route) => false);
          } else if (index == 2) {
            Navigator.pushNamed(context, '/settings');
          }
        },
      ),
    );
  }

  Widget _buildInstructionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B00).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF6B00).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Get Started',
            style: TextStyle(
              color: Color(0xFFFF6B00),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Type in the job role you want to practice interviewing for. Select your field of interest to get more relevant questions.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interview Details',
            style: TextStyle(
              color: Color(0xFFFF6B00),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: const Color(0xFF2A3543), // Dropdown menu background
            ),
            child: DropdownButtonFormField<String>(
              value: selectedField,
              items: fields.map((field) {
                return DropdownMenuItem(
                  value: field,
                  child: Text(
                    field,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedField = value!;
                });
              },
              dropdownColor: const Color(0xFF2A3543),
              decoration: InputDecoration(
                labelText: 'Select Field',
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                filled: true,
                fillColor: const Color(0xFF2A3543),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFFFF6B00).withOpacity(0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: const Color(0xFFFF6B00).withOpacity(0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF6B00),
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: roleController,
            textInputAction: TextInputAction.done,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9), // White input text
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              hintText: 'Enter a specific job role (e.g., UI Designer)',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true,
              fillColor: const Color(0xFF2A3543),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFFFF6B00).withOpacity(0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: const Color(0xFFFF6B00).withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFFFF6B00),
                  width: 2.0,
                ),
              ),
              labelText: 'Job Role',
              labelStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final jobRole = roleController.text.trim();
                if (jobRole.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          InterviewMockScreen(jobRole: jobRole),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a job role')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B00), // Orange button
                foregroundColor: Colors.white, // White text
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
              ),
              child: const Text('Start Interview'),
            ),
          ),
        ],
      ),
    );
  }
}
