import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flame/timer.dart';

import 'my_crate.dart';

class MyGame extends FlameGame with HasCollisionDetection, TapDetector {
  final double gravity = 0;
  final double jumpForce = 150;
  final double pushForce = 55;
  //Skater skater = Skater();
  bool initialFall = false;
  Timer interval = Timer(0.6, repeat: true);
  late double tileSize;
  MyCrate crate = MyCrate();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final screenWidth = size[0];
    final screenHeight = size[1];
    tileSize = screenWidth / 10;
    crate.size = Vector2(tileSize * 10, tileSize * 10);
    add(MyCrate());
  }

  @override
  onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    if (info.eventPosition.game.y < 100) {
      if (crate.velocity.y == 0) {
        crate.velocity.y = -jumpForce;
        crate.isJumping = true;
        print('jump');
      }
    }
    // tap on left side of screen to move left
    if (info.eventPosition.game.x < 100) {
      if (crate.velocity.x > 0) {
        crate.velocity.x = -pushForce;
      }
      print('left');
    }
    // tap on right side of screen to move right
    if (info.eventPosition.game.x > size[0] - 100) {
      if (crate.velocity.x < 0) {
        crate.velocity.x = crate.velocity.x + pushForce;
      }
      print('right');
    }
  }
}
