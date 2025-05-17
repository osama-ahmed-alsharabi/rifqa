import 'package:flutter/material.dart';
import 'package:rifqa/Features/Splash/presentation/widgets/body_splash_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: BodySplashView(),
      ),
    );
  }
}
