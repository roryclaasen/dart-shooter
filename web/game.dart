part of shooter;

class GameHost {
   final CanvasElement _canvas;
   final CanvasRenderingContext2D _context;
   int _lastTimestamp = 0;
   static final Keyboard _keyboard = new Keyboard();
   Level level;

   GameHost(this._canvas, this._context){
      level = new Level(_keyboard);
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
      _context
      ..globalAlpha = 1
      ..fillStyle = "white"
      ..beginPath()
      ..rect(0, 0, _canvas.width, _canvas.height)
      ..fill();

      level.render(_context);
   }
}
