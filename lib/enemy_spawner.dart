import 'package:first_flame/my_game.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class EnemySpawner extends SpriteComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  late final int maxSpawnInterval = 3000;
  late final int minSpawnInterval = 700;
  late final int intervalChange = 3;
  late final int maxEnemies = 7;
  late int currentInterval;
  late int nextSpawn;

  @override
  onLoad() async {
    super.onLoad();
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval;
  }

  void killAllEnemies() {
    for (var enemy in gameRef.enemies) {
      enemy.isDead = true;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    int now = DateTime.now().millisecondsSinceEpoch;
    if (gameRef.enemies.length < maxEnemies && now >= nextSpawn) {
      gameRef.spawnEnemy();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * 0.1).toInt();
      }
      nextSpawn = now + currentInterval;
    }
  }
}
