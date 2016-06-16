part of shooter;

class Level {
   final CanvasElement canvas;
	Entity player;

	Level(this.canvas, Keyboard _keyboard) {
		player = new Player(_keyboard);
		player.x = (canvas.width / 2) + (player.width / 2);
      print(player.x);
		player.y = (canvas.height - player.height) - 50.0;
	}

	void render(CanvasRenderingContext2D context) {
		player.render(context);
	}

	void update(final double elapsed) {
		player.update(canvas, elapsed);
	}
}
