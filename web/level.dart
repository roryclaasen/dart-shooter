part of shooter;

class Level {
   var guiButtonClickStreamProvider = new EventStreamProvider<CustomEvent>("guiButtonClick");
   final CanvasElement _canvas;
   GUIButton _play, _resume, _menu;

   Entity player;

   List<Enemy> enemies = new List<Enemy>();

   bool _playing = false;
   bool _pause = false;

   Level(this._canvas) {
      _init();
      reset();
   }

   void _init() {
      _play = new GUIButton((_canvas.width / 2).round(), (_canvas.height / 2).round(), "PLAY", _canvas);
      _resume = new GUIButton((_canvas.width / 2).round(), (_canvas.height / 2).round() - 40, "RESUME", _canvas);
      _menu = new GUIButton((_canvas.width / 2).round(), (_canvas.height / 2).round() + 40, "MENU", _canvas);

      player = new Player();

      guiButtonClickStreamProvider.forTarget(window).listen((e) {
         if (e.detail == _play.detail) _playing = true;
         if (e.detail == _resume.detail) _pause = false;
         if (e.detail == _menu.detail) reset();
      });
      window.onClick.listen((e) {
         if (e.target.id != "game") {
            if (_playing) _pause = true;
         }
      });
   }

   void render(CanvasRenderingContext2D context) {
      player.render(context);
      if (_playing) {
         if (_pause) {
            context..fillStyle = "rgba(0, 0, 0, 0.25)"
            ..beginPath()
            ..rect(0, 0, _canvas.width, _canvas.height)
            ..fill();
            TextUtil.drawCenteredString(context, "PAUSE", (_canvas.width / 2).round(), (_canvas.height / 3).round());
            _resume.render(context);
            _menu.render(context);
         }
         TextUtil.drawString(context, "${player.getHealth()} hp", 10, 30);
         TextUtil.drawStringFloatRight(context, "00000", _canvas.width - 10, 30);
      } else {
         enemies.forEach((enemy) {
            enemy.render(context);
         });
         _play.render(context);
      }
   }

   void update(final double elapsed) {
      if (_playing) {
         if(Keyboard.isPressed(KeyCode.ESC)) {
            _pause = true;
         }
         if(!_pause) {
            enemies.forEach((enemy) {
               enemy.update(elapsed);
               if (enemy.isRemoved()) enemies.remove(enemy);
            });
            player.update(elapsed);
         }
      } else {
      }
   }

   void reset() {
      _playing = _pause = false;
      player.setPosition(new Point((_canvas.width / 2) - (player.getWidth() / 2), (_canvas.height - player.getHeight()) - 50.0));
      enemies.clear();
   }
}
