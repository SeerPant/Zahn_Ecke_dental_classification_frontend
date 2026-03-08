import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top mission statement
            const Center(
              child: Text(
                'Developed as an academic project, the goal of this application is to provide accessible ways to take care of your teeth for all.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A73E8),
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Why us? section
            const Text(
              'Why us?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A73E8),
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoBox('Our model is trained with over 5000 dental images.'),
            const SizedBox(height: 16),
            _buildInfoBox(
                'Your dental data is not shared without explicit consent.'),

            // Spacer pushes tagline to bottom
            const Spacer(),

            // Bottom tagline
            const Center(
              child: Text(
                'AI powered dental information,\nProviding accessible ways to track your dental health',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A73E8),
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }
}
