import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Menu extends ConsumerWidget {
  const Menu({Key? key}) : super(key: key);

  void _onPressed(BuildContext context) {
    Navigator.pushNamed(context, '/game');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () => _onPressed(context),
      child: const Text('Start'),
    );
  }
}
