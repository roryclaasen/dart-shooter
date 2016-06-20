part of shooter;

class Level {
   var guiButtonClickStreamProvider = new EventStreamProvider<CustomEvent>("guiButtonClick");
   final CanvasElement _canvas;
   final Keyboard _keyboard;
   GUIButton _play, _resume, _menu;

   Entity player;

   TextUtil _textUtil;

   bool _playing = false;
   bool _pause = false;

   Level(this._canvas, this._keyboard) {
      _init();
   }

   void _init() {
      _textUtil = new TextUtil();
      _play = new GUIButton((_canvas.width / 2).round(), (_canvas.height / 2).round(), "PLAY", _canvas);
      _resume = new GUIButton((_canvas.width / 2).round(), (_canvas.height / 2).round() - 40, "RESUME", _canvas);
      _menu = new GUIButton((_canvas.width / 2).round(), (_canvas.height / 2).round() + 40, "MENU", _canvas);

      player = new Player(_keyboard);

      guiButtonClickStreamProvider.forTarget(window).listen((e) {
         if (e.detail == _play.detail) _playing = true;
         if (e.detail == _resume.detail) _pause = false;
         if (e.detail == _menu.detail) reset();
      });

      reset();
   }

   void render(CanvasRenderingContext2D context) {
      player.render(context);
      if (_playing) {
         if (_pause) {
            context..fillStyle = "rgba(0, 0, 0, 0.25)"
            ..beginPath()
            ..rect(0, 0, _canvas.width, _canvas.height)
            ..fill();
            _textUtil.drawCenteredString(context, "PAUSE", (_canvas.width / 2).round(), (_canvas.height / 3).round());
            _resume.render(context);
            _menu.render(context);
         }
         _textUtil.drawString(context, "${player.getHealth()} hp", 10, 30);
         _textUtil.drawStringFloatRight(context, "00000", _canvas.width - 10, 30);
      } else {
         _play.render(context);
      }
   }

   void update(final double elapsed) {
      if (_playing) {
         if(_keyboard.isPressed(KeyCode.ESC)) {
            _pause = true;
         }
         if(!_pause) {
            player.update(_canvas, elapsed);
         }
      } else {
         _play.update(_canvas);
      }
   }

   void reset() {
      _playing = _pause = false;
      player.setPosition(new Point((_canvas.width / 2) - (player.getWidth() / 2), (_canvas.height - player.getHeight()) - 50.0));

   }
}
