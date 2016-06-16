library shooter;

import 'dart:html';
import 'dart:async';
import 'dart:collection';

part 'control.dart';
part 'texture.dart';
part 'entity.dart';
part 'level.dart';
part 'game.dart';

void main() {
  final CanvasElement canvas = querySelector("#game");
  canvas.focus();
  scheduleMicrotask(new GameHost(canvas, canvas.getContext('2d')).run);
}
