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
library shooter;

// Imports
import 'dart:html';
import 'package:yaml/yaml.dart';
import 'dart:async';
import 'dart:web_audio';
import 'dart:math';
import 'dart:collection';
import 'package:json_object/json_object.dart';

// Game Files
part 'toolbox.dart';
part 'audio.dart';
part 'texture.dart';
part 'gui.dart';
part 'entity.dart';
part 'level.dart';
part 'game.dart';

void main() {
   final CanvasElement canvas = querySelector(GameData.canvasIdentifier);
   canvas.focus();
   scheduleMicrotask(new GameHost(canvas, canvas.getContext('2d')).run);
   GameData.loadVersion();
}

class GameData {
   static const String canvasIdentifier = "#game-canvas";
   static String version = "unknown";

   static void loadVersion() {
      HttpRequest.getString('../pubspec.yaml').then((String yaml){
         YamlMap map = loadYaml(yaml);
         version = "debug." + map['version'];
      }).catchError((Error error) {
         HttpRequest.getString('data.yaml').then((String yaml){
            YamlMap map = loadYaml(yaml);
            version = map['version'];
         });
      });
   }
}
