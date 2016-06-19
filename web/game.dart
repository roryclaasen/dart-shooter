part of shooter;

class GameHost {
   final CanvasElement _canvas;
   final CanvasRenderingContext2D _context;
   int _lastTimestamp = 0;
   static final Keyboard _keyboard = new Keyboard();
   Level level;

   Texture _background;
   int _backgroundPos = 0;

   GameHost(this._canvas, this._context) {
      _background = new Texture("background.png");
      level = new Level(_canvas, _keyboard);
   }

   run() {
      window.requestAnimationFrame(_gameLoop);
   }

   void _gameLoop(double _) {
      _update(_getElapsed());
      _render();
      window.requestAnimationFrame(_gameLoop);
   }

   double _getElapsed() {
      final int time = new DateTime.now().millisecondsSinceEpoch;

      double elapsed = 0.0;
      if (_lastTimestamp != 0) {
         elapsed = (time - _lastTimestamp) / 1000.0;
      }

      _lastTimestamp = time;
      return elapsed;
   }

   void _update(final double elapsed) {
      level.update(elapsed);
   }

   void _render() {
      _drawBackground();
      level.render(_context);
   }

   void _drawBackground() {
      ImageElement image = _background.getTexture();
      _backgroundPos++;
      if (_backgroundPos >= 0) _backgroundPos = -image.height;
      for(int x = 0; x < 2; x++) {
         for(int y = 0; y < 5; y++) {
            _context.drawImage(_background.getTexture(), x * image.width, (y * image.height) + _backgroundPos);
         }
      }
   }
}
