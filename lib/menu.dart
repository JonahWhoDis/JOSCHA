import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  const Menu({Key? key}) : super(key: key);

  void _onPressed(BuildContext context) {
    Navigator.pushNamed(context, '/game');
  }

  @override
  Widget build(BuildContext context) {
    // Play Button then navigate to myGame
    return ElevatedButton(
      onPressed: () => _onPressed(context),
      child: const Text("Play"),
    );
  }
}
