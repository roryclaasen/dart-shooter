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

class Keyboard {
   static final HashSet<int> _keys = new HashSet<int>();

   Keyboard() {
      window.onKeyDown.listen((final KeyboardEvent e) {
         _keys.add(e.keyCode);
      });

      window.onKeyUp.listen((final KeyboardEvent e) {
         _keys.remove(e.keyCode);
      });
   }

   static isPressed(int keyCode) => _keys.contains(keyCode);
}

class JSONRequest {
   String _prefix = "assets/";
   String _file;
   JsonObject  _jsonObject;

   JSONRequest(this._file) {
      var req = new HttpRequest();
      req.onLoad.listen((e) => _onDataLoaded(req.responseText));
      req.open('GET', _prefix + _file, async: false);
      req.send();
   }

   void _onDataLoaded(String responseText) {
      _jsonObject = new JsonObject.fromJsonString(responseText);
   }

   Object get(String key) {
      if (_jsonObject == null) {
         print("file '"+ _file + "' has not yet been loaded");
         return null;
      }
      if (_jsonObject.containsKey(key)) {
         return _jsonObject[key];
      }
      print("No key '" + key + "' found in file '"+ _file + "'");
      return null;
   }

   bool hasKey(String key) {
      if (_jsonObject == null) {
         print("file '"+ _file + "' has not yet been loaded");
         return false;
      }
      return _jsonObject.containsKey(key);
   }
}

class TextUtil {
   static String _shadowColor = 'rgba(75, 75, 75,  0.8)';
   static String _color = '#fff';

   static void _initContext(CanvasRenderingContext2D context) {
      context..fillStyle = _color
      ..font = "20pt squares";
   }

   static void _addShaddow(CanvasRenderingContext2D context) {
      context..shadowOffsetX = 2
      ..shadowOffsetY = 2
      ..shadowBlur = 0
      ..shadowColor = _shadowColor;
   }

   static void _removeShaddow(CanvasRenderingContext2D context) {
      context..shadowOffsetX = 0
      ..shadowOffsetY = 0
      ..shadowBlur = 0
      ..shadowColor = 'rgba(255, 255, 255,  1)';
   }

   static void drawString(CanvasRenderingContext2D context, String text, int x, int y, {bool useFontAwesome}) {
      _initContext(context);
      if (useFontAwesome != null) {
         if (useFontAwesome) {
            context.font = "20pt FontAwesome";
         }
      }
      _addShaddow(context);
      context.fillText(text, x, y);
      _removeShaddow(context);
   }

   static void drawCenteredString(CanvasRenderingContext2D context, String text, int x, int y, {bool useFontAwesome}) {
      drawStringAligned(context, text, x, y, "center", useFontAwesome:useFontAwesome);
   }

   static void drawStringAligned(CanvasRenderingContext2D context, String text, int x, int y, String align, {bool useFontAwesome}) {
      context.textAlign = align;
      drawString(context, text, x, y, useFontAwesome:useFontAwesome);
      context.textAlign = "left";
   }

   static void drawStringFloatRight(CanvasRenderingContext2D context, String text, int x, int y, {bool useFontAwesome}) {
      _initContext(context);
      drawString(context, text, (x - context.measureText(text).width).round(), y, useFontAwesome:useFontAwesome);
   }

   static void wrapText(context, text, x, y, maxWidth, lineHeight) {
      _initContext(context);
      var words = text.split(" ");
      var line = "";
      for(var n = 0; n < words.length; n++) {
         var testLine = '${line}${words[n]} ';
         var metrics = context.measureText(testLine);
         var testWidth = metrics.width;
         if(testWidth > maxWidth) {
            context.fillText(line, x, y);
            line = '${words[n]} ';
            y += lineHeight;
         }
         else { line = testLine; }
      }
      context.fillText(line, x, y);
   }

   static void dark() {
      _shadowColor = 'rgba(40, 40, 40,  0.8)';
      _color = '#000';
   }

   static void light() {
      _shadowColor = 'rgba(75, 75, 75,  0.8)';
      _color = '#fff';
   }
}
