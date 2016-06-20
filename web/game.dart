part of shooter;

class GameHost {
   final CanvasElement _canvas;
   final CanvasRenderingContext2D _context;
   final Keyboard keyboard = new Keyboard();
   final AudioMaster audio = new AudioMaster();

   int _lastTimestamp = 0;
   int _backgroundPos = 0;

   Level _level;
   Texture _background;

   static int width, height;

   GameHost(this._canvas, this._context) {
      _background = new Texture("background.png");
      _level = new Level(_canvas);

      width = _canvas.width;
      height = _canvas.height;
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
      if (_lastTimestamp != 0) elapsed = (time - _lastTimestamp) / 1000.0;
      _lastTimestamp = time;
      return elapsed;
   }

   void _update(final double elapsed) {
      _level.update(elapsed);
   }

   void _render() {
      _drawBackground();
      _level.render(_context);
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
