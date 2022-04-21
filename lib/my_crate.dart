/*import 'package:first_flame/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class MyCrate extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  // creates a component that renders the crate.png sprite, with size 16 x 16
  MyCrate() : super(size: Vector2.all(16), anchor: Anchor.topCenter);
  var velocity = Vector2(0, 1);
  bool isJumping = false;
  @override
  Future<void> onLoad() async {
    final sprite = await Sprite.load('crate.png');
    final size = Vector2.all(300.0);
    final crate =
        SpriteComponent(size: size, sprite: sprite); // screen coordinates
    crate.position = Vector2(0.0, 0.0);
    crate.angle = 0;
    add(crate);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (velocity.y != 0 || isJumping) {
      velocity.y += gameRef.gravity;
    }
    y += velocity.y * dt;
    // move to right if not at the right edge
    if (x > 0 && velocity.x <= 0) {
      x += velocity.x * 1;
    }
    // move to left if not at the left edge
    if (x < gameRef.size.x - width && velocity.x >= 0) {
      x += velocity.x * 1;
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    positionOffset = size / 2;
    size = size / 10;
  }
}
*/