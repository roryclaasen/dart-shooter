part of shooter;

class Level {
   var _guiButtonClick = new EventStreamProvider<CustomEvent>("guiButtonClick");
   GUIButton _play, _resume, _menu;

   Player _player;

   List<Enemy> _enemies = new List<Enemy>();

   bool _playing = false;
   bool _pause = false;

   double _time = 0.0;

   Level(CanvasElement canvas) {
      _init(canvas);
      reset();
   }

   void _init(CanvasElement canvas) {
      _play = new GUIButton((GameHost.width / 2).round(), (GameHost.height / 2).round(), "PLAY", canvas);
      _resume = new GUIButton((GameHost.width / 2).round(), (GameHost.height / 2).round() - 40, "RESUME", canvas);
      _menu = new GUIButton((GameHost.width / 2).round(), (GameHost.height / 2).round() + 40, "MENU", canvas);

      _player = new Player();

      _guiButtonClick.forTarget(window).listen((e) {
         AudioMaster.sfx_shieldDown.play();
         if (e.detail == _play.detail) play();
         if (e.detail == _resume.detail) setPause(false);
         if (e.detail == _menu.detail) reset();
      });
      window.onClick.listen((e) {
         if (e.target.id != "game") {
            if (_playing) setPause(true);
         }
      });
   }

   void render(CanvasRenderingContext2D context) {
      _enemies.forEach((enemy) {
         enemy.render(context);
      });
      _player.render(context);
      if (_playing) {
         if (_pause) {
            context..fillStyle = "rgba(0, 0, 0, 0.25)"
            ..beginPath()
            ..rect(0, 0, GameHost.width, GameHost.height)
            ..fill();
            TextUtil.drawCenteredString(context, "PAUSE", (GameHost.width / 2).round(), (GameHost.height / 3).round());
            _resume.render(context);
            _menu.render(context);
         }
         TextUtil.drawString(context, "${_player.getHealth()} hp", 10, 30);
         TextUtil.drawStringFloatRight(context, _formatScore(_player.getScore()), GameHost.width - 10, 30);
      } else {
         _play.render(context);
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
         if(!_pause) {
            _time += elapsed;
            if (_time >= 1.0) {
                _player.addScore(1);
               _genEnemy();
               _time = 0.0;
            }
            _enemies.forEach((enemy) {
               enemy.update(elapsed);
               if (enemy.isRemoved()) _enemies.remove(enemy);
            });
            _player.update(elapsed);
         }
      } else {
      }
   }

   void reset() {
      _playing = _pause = false;
      setPause(false);
      _play.setVisible(true);

      _player.setPosition(new Point((GameHost.width / 2) - (_player.getWidth() / 2), (GameHost.height - _player.getHeight()) - 50.0));
      _player.setScore(0);
      _enemies.clear();
      _time = 0.0;
   }

   void play() {
      setPause(false);
      _play.setVisible(false);
      _playing = true;
   }

   void setPause(bool pause) {
      _pause = pause;
      _resume.setVisible(pause);
      _menu.setVisible(pause);
   }

   void _genEnemy() {

   }
}
