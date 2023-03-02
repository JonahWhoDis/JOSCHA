import 'package:first_flame/my_game.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';

class PauseMenu extends FlameGame with TapDetector {
  final JoschaGame gameRef;

  PauseMenu(this.gameRef);
  static const String description = '''
    In this example we show how the overlays system can be used.\n\n
    If you tap the canvas the game will start and if you tap it again it will
    pause.
  ''';

  @override
  Future<void> onLoad() async {
    final animation = await loadSpriteAnimation(
      'animations/chopper.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        textureSize: Vector2.all(48),
        stepTime: 0.15,
      ),
    );

    add(
      SpriteAnimationComponent(
        animation: animation,
      )
        ..position.y = size.y / 2
        ..position.x = 100
        ..anchor = Anchor.center
        ..size = Vector2.all(100),
    );
  }

  @override
  void onTap() {
    if (overlays.isActive('PauseMenu')) {
      overlays.remove('PauseMenu');
      resumeEngine();
    } else {
      overlays.add('PauseMenu');
      pauseEngine();
    }
  }
}
