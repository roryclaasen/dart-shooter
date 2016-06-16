part of shooter;

class Level {
	Entity player;

	Level(Keyboard _keyboard) {
		player = new Player(_keyboard);
	}

	void render(CanvasRenderingContext2D context) {
		player.render(context);
	}

	void update(final double elapsed) {
		player.update(elapsed);
	}
}
