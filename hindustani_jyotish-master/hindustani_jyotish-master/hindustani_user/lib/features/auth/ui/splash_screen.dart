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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const DiyaLogo(size: 96),
              const SizedBox(height: 28),
              Text('हिन्दुस्तानी ज्योतिष', style: AppTextStyles.devanagari(size: 24)),
              const SizedBox(height: 8),
              Text('Hindustani Jyotish', style: AppTextStyles.display(size: 20)),
              const SizedBox(height: 36),
              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.saffron),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
