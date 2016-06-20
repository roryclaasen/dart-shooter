part of shooter;

final double velocity = 128.0;

Random random = new Random();

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

	void update(final double elapsed) {
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
	int _score = 0;
	Player() : super(0.0, 0.0, width: 79, height: 55) {
		loadData("player.json");
	}

	void update(final double elapsed) {
		super.update(elapsed);
		double pVelocity = velocity * 1.25;
		if (Keyboard.isPressed(KeyCode.A)) _x -= pVelocity * elapsed;
		if (Keyboard.isPressed(KeyCode.D)) _x += pVelocity * elapsed;
		if (Keyboard.isPressed(KeyCode.W)) _y -= pVelocity * elapsed;
		if (Keyboard.isPressed(KeyCode.S)) _y += pVelocity * elapsed;
		if (getBounds().left < 0) _x = 0.0;
		if (getBounds().right > GameHost.width) _x = 0.0 + GameHost.width - _width;
		if (getBounds().top < 40) _y = 40.0; // To not get to0 close to the text at the top
		if (getBounds().bottom > GameHost.height) _y = GameHost.height - _height + 0.0;
	}

	void setScore(int score) {
		_score = score;
	}

	void addScore(int score) {
		_score += score;
	}

	int getScore() {
		return _score;
	}
}

class Enemy extends Entity {
	final String _type;
	bool _remove = false;

	Enemy(this._type) : super(0.0, 0.0) {
		loadData("${_type}.json");
		randomPosition(-10);
	}

	void randomPosition(int y) {
		int width = GameHost.width;
		_x = 0.0 + random.nextInt(width);
	}

	void remove() {
		_remove = true;
	}

	bool isRemoved() {
		return _remove;
	}
}
