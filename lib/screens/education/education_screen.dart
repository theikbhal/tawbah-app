import 'package:flutter/material.dart';
import '../../core/design_system.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Why Astaghfirullah?'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStoryCard(),
            const SizedBox(height: 30),
            const Text('The Benefits', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildBenefitItem('Increase in Rizq', 'Allah promised that seeking forgiveness opens the doors of provision.', Icons.monetization_on_outlined),
            _buildBenefitItem('Heart Purification', 'Every Astaghfirullah removes a black spot from the spiritual heart.', Icons.favorite_border),
            _buildBenefitItem('Solving Problems', 'It is a key to relief from distress and every difficulty.', Icons.lightbulb_outline),
            _buildBenefitItem('Closeness to Allah', 'Seeking forgiveness is the path of the humble and beloved.', Icons.auto_awesome),
            const SizedBox(height: 30),
            const Text('Listen & Learn', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildVideoPlaceholder(),
            const SizedBox(height: 30),
            _buildHadisSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard() {
    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'The Legacy of Abu Huraira (RA)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          const Text(
            'It is reported that Abu Huraira (RA) had a thread with 12,000 knots. He would not go to sleep until he had made tasbih on each of those knots.',
            style: TextStyle(height: 1.5),
          ),
          const SizedBox(height: 12),
          Text(
            'If a companion of the Prophet ﷺ found such benefit in 12k daily, imagine the transformation it can bring to our lives.',
            style: TextStyle(color: AppColors.textSecondary, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String title, String desc, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(24),
        image: const DecorationImage(
          image: NetworkImage('https://img.youtube.com/vi/placeholder/0.jpg'), // Placeholder
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: const Center(
        child: Icon(Icons.play_circle_fill, color: Colors.white, size: 64),
      ),
    );
  }

  Widget _buildHadisSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
      ),
      child: const Column(
        children: [
          Text(
            '"If anyone constantly seeks pardon (from Allah), Allah will appoint for him a way out of every distress and a relief from every anxiety, and will provide sustenance for him from where he expects not."',
            textAlign: TextAlign.center,
            style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          Text('- Sunan Abu Dawood', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
