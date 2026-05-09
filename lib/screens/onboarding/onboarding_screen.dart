import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/design_system.dart';
import '../../providers/user_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final TextEditingController _nameController = TextEditingController();
  String _selectedRole = 'Myself';

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Welcome to Tawbah',
      'description': 'Tawbah means returning to Allah. This app helps you perform 12,000 Istighfar daily, following the Sunnah of Abu Huraira (RA).',
      'image': '📿',
    },
    {
      'title': 'Sunnah of Abu Huraira (RA)',
      'description': 'Abu Huraira (RA) used to perform 12,000 Astaghfirullah every single day.',
      'image': '📜',
    },
    {
      'title': 'Incremental Growth',
      'description': 'Start with 3,000 daily and grow to 12,000 by the end of the year.',
      'image': '📈',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemCount: _onboardingData.length + 1,
                itemBuilder: (context, index) {
                  if (index < _onboardingData.length) {
                    return _buildOnboardingPage(_onboardingData[index]);
                  } else {
                    return _buildProfileSetupPage();
                  }
                },
              ),
            ),
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(Map<String, String> data) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(data['image']!, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 40),
          Text(
            data['title']!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 20),
          Text(
            data['description']!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSetupPage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Who is tracking?',
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(height: 30),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Your Role:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: ['Myself', 'Wife', 'Son', 'Daughter'].map((role) {
              final isSelected = _selectedRole == role;
              return ChoiceChip(
                label: Text(role),
                selected: isSelected,
                onSelected: (val) => setState(() => _selectedRole = role),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(
              _onboardingData.length + 1,
              (index) => Container(
                margin: const EdgeInsets.only(right: 8),
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? AppColors.primary : AppColors.primary.withOpacity(0.2),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_currentPage < _onboardingData.length) {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                _finishOnboarding();
              }
            },
            child: Text(_currentPage == _onboardingData.length ? 'Get Started' : 'Next'),
          ),
        ],
      ),
    );
  }

  void _finishOnboarding() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }
    
    context.read<UserProvider>().addUser(name, _selectedRole);
  }
}
