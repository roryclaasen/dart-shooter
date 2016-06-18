part of shooter;

class Level {
   final CanvasElement canvas;
	Entity player;

	Level(this.canvas, Keyboard _keyboard) {
		player = new Player(_keyboard);
      player.setPosition(new Point((canvas.width / 2) - (player.getWidth() / 2), (canvas.height - player.getHeight()) - 50.0));
	}

	void render(CanvasRenderingContext2D context) {
		player.render(context);
	}

	void update(final double elapsed) {
		player.update(canvas, elapsed);
	}
}
