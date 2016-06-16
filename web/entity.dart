part of shooter;

final double velocity = 128.0;

class Entity {
	Texture texture;
	AnimatedTexture animTexture;
	double x, y;
	int width, height;

	Entity(this.x, this.y, String texturePath) {
		texture = new Texture(texturePath);
		width = 32;
		height = 32;
	}

	void render(CanvasRenderingContext2D context) {
		if (texture != null) context.drawImage(texture.getTexture(), getBounds().left, getBounds().top);
	}

	void update(final CanvasElement canvas, final double elapsed) {}

	Rectangle getBounds() {
		return new Rectangle(x, y, width, height);
	}
}

class Player extends Entity {
	Keyboard _keyboard;
	Player(Keyboard keyboard) : super(0.0, 0.0, "player.png"){
		_keyboard = keyboard;
	}

	void update(final CanvasElement canvas, final double elapsed){
		if (_keyboard.isPressed(KeyCode.A)) x -= velocity * elapsed;
		if (_keyboard.isPressed(KeyCode.D)) x += velocity * elapsed;
		if (_keyboard.isPressed(KeyCode.W)) y -= velocity * elapsed;
		if (_keyboard.isPressed(KeyCode.S)) y += velocity * elapsed;
		if (getBounds().left < 0) x = 0.0;
		if (getBounds().right > canvas.width) x = 0.0 + canvas.width - width;
		if (getBounds().top < 0) y = 0.0;
		if (getBounds().bottom > canvas.height) y = canvas.height - height + 0.0;
	}
}
