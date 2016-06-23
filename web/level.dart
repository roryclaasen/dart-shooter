/*
Copyright 2016 Rory Claasen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
part of shooter;

class Level {
   var _guiButtonClick = new EventStreamProvider<CustomEvent>("guiButtonClick");
   GUIButton _play, _resume, _menu;
   GUIButton _sfx;

   Player _player;

   List<Enemy> _enemies = new List<Enemy>();
   List<Projectile> _projectile = new List<Projectile>();

   bool _playing = false;
   bool _pause = false;
   bool _gameOver = false;

   double _time = 0.0;

   Level(CanvasElement canvas) {
      _init(canvas);
      reset();
   }

   void _init(CanvasElement canvas) {
      _play = new GUIButton((GameHost.width / 2).round(), (GameHost.height / 2).round(), "PLAY", canvas);
      _resume = new GUIButton((GameHost.width / 2).round(), (GameHost.height / 2).round() - 40, "RESUME", canvas);
      _menu = new GUIButton((GameHost.width / 2).round(), (GameHost.height / 2).round() + 40, "MENU", canvas);
      _sfx = new GUIToggleButton(30, GameHost.height - 30, "sound", canvas, "\uf028", "\uf026", isSmall:true, fa:true);

      _player = new Player(this);

      _guiButtonClick.forTarget(window).listen((e) {
         if (e.detail == _play.detail) play();
         if (e.detail == _resume.detail) setPause(false);
         if (e.detail == _menu.detail) reset();
         if (e.detail == _sfx.detail) {
            GUIToggleButton sfx = _sfx;
            sfx.toggle();
            AudioMaster.setMuted(!sfx.isOn());
         }
         AudioMaster.sfx_shieldDown.play();
      });
      window.onClick.listen((e) {
         if (e.target.id != canvas.id) {
            if (_playing) setPause(true);
         }
      });
   }

   void render(CanvasRenderingContext2D context) {
      _enemies.forEach((enemy) {
         enemy.render(context);
      });
      _projectile.forEach((projectile) {
         projectile.render(context);
      });
      if (!_player.isRemoved()) _player.render(context);
      if (_playing) {
         if (_pause) {
            context..fillStyle = "rgba(0, 0, 0, 0.25)"
            ..beginPath()
            ..rect(0, 0, GameHost.width, GameHost.height)
            ..fill();
            if (_gameOver) {
               TextUtil.drawCenteredString(context, "GAME OVER", (GameHost.width / 2).round(), (GameHost.height / 3).round());
               TextUtil.drawCenteredString(context, _formatScore(_player.getScore()), (GameHost.width / 2).round(), (GameHost.height / 3).round() + 30);
            } else {
               TextUtil.drawCenteredString(context, "PAUSE", (GameHost.width / 2).round(), (GameHost.height / 3).round());
               _resume.render(context);
            }
            _sfx.render(context);
            _menu.render(context);
         }
         if (!_gameOver) {
            TextUtil.drawString(context, "${_player.getHealth()} hp", 10, 30);
            TextUtil.drawStringFloatRight(context, _formatScore(_player.getScore()), GameHost.width - 10, 30);
         }
      } else {
         _play.render(context);
         _sfx.render(context);
         TextUtil.drawStringFloatRight(context, "${GameData.version}", GameHost.width - 10, 30);
      }
   }

   String _formatScore(int score) {
      String formatScore = "$score";
      int length = 7;
      int spaces = length - formatScore.length;
      if (spaces < 0) {
         formatScore = "";
         for (int i = 0; i < length; i++) {
            formatScore += "9";
         }
         return formatScore;
      }
      for (int i = 0; i < spaces; i++) {
         formatScore = "0" + formatScore;
      }
      return formatScore;
   }

   void update(final double elapsed) {
      if (_playing) {
         if (Keyboard.isPressed(KeyCode.ESC)) {
            setPause(true);
         }
         if(!_pause || _gameOver) {
            _time += elapsed;
            // Enemy
            List<Entity> toRemove = new List<Entity>();
            _enemies.forEach((enemy) {
               enemy.update(elapsed);
               if (enemy.collide(_player, doSmall: true)) {
                  _player.damage(1);
                  enemy.destroyEnemy(sound:true);
               }
               if (enemy.isRemoved()) toRemove.add(enemy);
            });
            toRemove.forEach((enemy) {
               _enemies.remove(enemy);
            });
            // Projectile
            toRemove.clear();
            _projectile.forEach((projectile) {
               projectile.update(elapsed);
               if (projectile.getPosition().y > 0){
                  Entity hit = projectile.collideWith(_enemies, doSmall: true);
                  if (hit != null) {
                     projectile.hit(hit);
                     if (hit is Enemy) {
                        Enemy enemy = hit;
                        enemy.destroyEnemy(sound:true);
                        _player.addScore(100 + random.nextInt(100));
                     } else if (hit is Player) {
                        Player player = hit;
                        player.damage(projectile.getDamage());
                     }
                  }
               }
               if (projectile.isRemoved()) toRemove.add(projectile);
            });
            toRemove.forEach((projectile) {
               _projectile.remove(projectile);
            });
            // Everything else
            if (!_gameOver) {
               if (_time >= 1.0) {
                  _player.addScore(1);
                  _genEnemy();
                  _time = 0.0;
               }
               _player.update(elapsed);
               if (_player.isRemoved()) {
                  _gameOver = true;
                  AudioMaster.sfx_lose.play();
                  setPause(true);
               }
            }
         }
      } else {

      }
   }

   void add(Entity entity) {
      if (entity is Enemy) {
         _enemies.add(entity);
      } else if (entity is Projectile){
         _projectile.add(entity);
      } else {
         print("Unknown entity type!");
      }
   }

   void reset() {
      _playing = _pause = _gameOver = false;
      setPause(false);
      _play.setVisible(true);

      _player.setPosition(new Point((GameHost.width / 2), (GameHost.height - _player.getHeight()) - 50.0));
      _player.reset();
      _enemies.clear();
      _projectile.clear();
      _time = 0.0;
   }

   void play() {
      setPause(false);
      _play.setVisible(false);
      _playing = true;
      _gameOver = false;
   }

   void setPause(bool pause) {
      _pause = pause;
      if (!_gameOver) _resume.setVisible(pause);
      _menu.setVisible(pause);
      if (GameHost.getBackground() != null) {
         GameHost.getBackground().setIsMoving(!pause);
         if (_gameOver) GameHost.getBackground().setIsMoving(true);
      }
   }

   void _genEnemy() {
      _enemies.add(new Meteor());
   }

   bool isPaused() {
      return _pause;
   }

   bool isOver() {
      return _gameOver;
   }
}
