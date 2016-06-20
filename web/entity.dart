part of shooter;

final double velocity = 128.0;

class Entity {
	Texture _texture;
	AnimatedTexture _animTexture;
	double _x = 0.0, _y = 0.0;
	int _width, _height;
	int _health;

	Entity(this._x, this._y, {String texturePath, int width, int height}) {
		if (texturePath != null) _texture = new Texture(texturePath);
		if (width == null) _width = 32;
		else _width = width;
		if (height == null) _height = 32;
		else _height = height;
	}

	void loadData(String josnFile) {
		JSONRequest req = new JSONRequest("player.json");
		if (req.hasKey("texture")) {
			JsonObject texture = req.get("texture");
			List files = texture.files;
			if (files.length > 1) {
				_animTexture = new AnimatedTexture(texture.interval, files);
			} else {
				_texture = new Texture(files[0]);
			}
		}
		if (req.hasKey("entity")) {
			JsonObject entity = req.get("entity");

			if(entity.containsKey("health")) _health = entity.health;
			else _health = 1;
		}
	}

	void render(CanvasRenderingContext2D context) {
		if (_texture != null) context.drawImageScaled(_texture.getTexture(), getBounds().left, getBounds().top,getBounds().width,getBounds().height);
	}

	void update(final CanvasElement canvas, final double elapsed) {
		if (_animTexture != null) {
			_animTexture.update(elapsed);
			_texture = _animTexture.getCurrent();
		}
	}

	Rectangle getBounds() {
		return new Rectangle(_x, _y, _width, _height);
	}

	void setWidth(int width) {
		_width = width;
	}

	void setHeight(int height) {
		_height = height;
	}

	int getWidth() {
		return _width;
	}

	int getHeight() {
		return _height;
	}

	void setPosition(Point cords) {
		_x = cords.x;
		_y = cords.y;
	}

	Point getPosition() {
		return new Point(_x, _y);
	}

	int getHealth() {
		return _health;
	}
}

class Player extends Entity {
	Keyboard _keyboard;
	Player(Keyboard keyboard) : super(0.0, 0.0, width: 79, height: 55) {
		_keyboard = keyboard;
		loadData("player.json");
	}

	void update(final CanvasElement canvas, final double elapsed) {
		super.update(canvas, elapsed);

		if (_keyboard.isPressed(KeyCode.A)) _x -= velocity * elapsed;
		if (_keyboard.isPressed(KeyCode.D)) _x += velocity * elapsed;
		if (_keyboard.isPressed(KeyCode.W)) _y -= velocity * elapsed;
		if (_keyboard.isPressed(KeyCode.S)) _y += velocity * elapsed;
		if (getBounds().left < 0) _x = 0.0;
		if (getBounds().right > canvas.width) _x = 0.0 + canvas.width - _width;
		if (getBounds().top < 40) _y = 40.0; // To not get to0 close to the text at the top
		if (getBounds().bottom > canvas.height) _y = canvas.height - _height + 0.0;
	}
}
