import 'package:flutter/material.dart';
import 'package:hj_core/hj_core.dart';

import '../../../shared/widgets/cosmic_background.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CosmicBackground(
        child: Center(
          // Scrollable so a short viewport (small landscape phone) can't
          // overflow the fixed logo column.
          child: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DiyaLogo(size: 96),
              const SizedBox(height: 24),
              Text('Hindustani Jyotish', style: AppTextStyles.display(size: 20)),
              const SizedBox(height: 6),
              Text('Astrologer', style: AppTextStyles.label(color: AppColors.copperLight)),
              const SizedBox(height: 32),
              const SizedBox(
                width: 26, height: 26,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.saffron),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}
