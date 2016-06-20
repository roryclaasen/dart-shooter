library shooter;

// Imports
import 'dart:html';
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
   final CanvasElement canvas = querySelector("#game");
   canvas.focus();
   scheduleMicrotask(new GameHost(canvas, canvas.getContext('2d')).run);
}
