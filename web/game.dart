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

   static Background _background;

   int _lastTimestamp = 0;

   Level _level;

   static int width, height;

   GameHost(this._canvas, this._context) {
      width = _canvas.width;
      height = _canvas.height;

      _level = new Level(_canvas);

      _background = new Background("background.png");
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
      _background.update(elapsed);
      _level.update(elapsed);
   }

   void _render() {
      _background.render(_context);
      _level.render(_context);
   }

   static Background getBackground(){
      return _background;
   }
}
