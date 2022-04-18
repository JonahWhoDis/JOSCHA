import 'package:first_flame/my_game.dart';
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
    final player = SpriteComponent(size: size, sprite: sprite);
    // screen coordinates
    player.position = Vector2(0.0,
        0.0); // Vector2(0.0, 0.0) by default, can also be set in the constructor
    player.angle = 0; // 0 by default, can also be set in the constructor
    add(player); // Adds the component
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
      x += velocity.x * dt;
    }
    // move to left if not at the left edge
    if (x < gameRef.size.x - width && velocity.x >= 0) {
      x += velocity.x * dt;
    }
  }

  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    position = gameSize / 2;
    size = gameSize / 10;
  }
}
