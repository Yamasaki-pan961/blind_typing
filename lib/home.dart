import 'package:blind_typing/features/typing/typing_game.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TypingGame(),
    );
  }
}
