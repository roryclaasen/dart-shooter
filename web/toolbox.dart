part of shooter;

class Keyboard {
   final HashSet<int> _keys = new HashSet<int>();

   Keyboard() {
      window.onKeyDown.listen((final KeyboardEvent e) {
         _keys.add(e.keyCode);
      });

      window.onKeyUp.listen((final KeyboardEvent e) {
         _keys.remove(e.keyCode);
      });
   }

   isPressed(int keyCode) => _keys.contains(keyCode);
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
      if (_jsonObject.containsKey(key)) {
         return _jsonObject[key];
      }
      print("No key '" + key + "' found in file '"+ _file + "'");
      return null;
   }
}
