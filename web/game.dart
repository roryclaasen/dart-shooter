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
      width = _canvas.width;
      height = _canvas.height;

      _background = new Texture("background.png");
      _level = new Level(_canvas);

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
      _drawBackground(!_level.isPaused());
      _level.render(_context);
   }

   void _drawBackground(bool moving) {
      ImageElement image = _background.getTexture();
      if (moving) {
         _backgroundPos++;
         if (_backgroundPos >= 0) _backgroundPos = -image.height;
      }
      for(int x = 0; x < 2; x++) {
         for(int y = 0; y < 5; y++) {
            _context.drawImage(_background.getTexture(), x * image.width, (y * image.height) + _backgroundPos);
         }
      }
   }
}
