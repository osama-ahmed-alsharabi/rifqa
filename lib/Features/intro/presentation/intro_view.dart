import 'package:flutter/material.dart';
import 'package:rifqa/Features/intro/presentation/widgets/body_intro_view_widget.dart';

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: BodyIntroViewWidget(),
      ),
    );
  }
}
