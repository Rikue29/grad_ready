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
      backgroundColor: const Color(0xFFFF6B00), // Orange background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2632),
        title: const Text(
          'Mock Interview',
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Background image
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/texture.png',
                    fit: BoxFit.cover,
                    color: Colors.white.withOpacity(0.2), // Adjust opacity (1.0 for solid white)
                    colorBlendMode: BlendMode.srcOut, // Blend mode to apply the white color
                  ),
                ),
                // Main content
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Type in job role to get started',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White text
                          ),
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          value: selectedField,
                          items: fields.map((field) {
                            return DropdownMenuItem(
                              value: field,
                              child: Text(
                                field,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.black, // Black text for better readability
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedField = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Select Field',
                            labelStyle: TextStyle(color: Colors.black), // White label
                            filled: true,
                            fillColor: Colors.white, // Fill with white
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black), // Black outline
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black), // Black outline when enabled
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0), // Thicker black outline when focused
                            ),
                          ),
                          dropdownColor: Colors.white, // White dropdown background for contrast
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: roleController,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(color: Colors.black), // Black input text
                          decoration: const InputDecoration(
                            hintText: 'Enter a specific job role (e.g., UI Designer)',
                            hintStyle: TextStyle(color: Colors.black54), // Black hint text
                            filled: true,
                            fillColor: Colors.white, // Fill with white
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black), // Black outline
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black), // Black outline when enabled
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width: 2.0), // Thicker black outline when focused
                            ),
                            labelText: 'Job Role',
                            labelStyle: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            final jobRole = roleController.text.trim();
                            if (jobRole.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InterviewMockScreen(jobRole: jobRole),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please enter a job role')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White button
                            foregroundColor: const Color(0xFFFF6B00), // Orange text
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            textStyle: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Rounded corners
                            ),
                          ),
                          child: const Text('Get Started!'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomNavBar(
            currentIndex: 0,
            onTap: (index) {
              // Handle navigation logic here
            },
          ),
        ],
      ),
    );
  }
}
