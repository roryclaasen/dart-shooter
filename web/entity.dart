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
part of shooter;

final double velocity = 128.0;

Random random = new Random();

class Entity {
	Texture _texture;
	AnimatedTexture _animTexture;
	AnimatedTexture _damage;
	double _x = 0.0, _y = 0.0;
	int _width, _height;
	int _health, _maxHealth;
	int _shadowOffset = 5;
	double _scale = 1.0;
	bool _remove = false;

	Entity(this._x, this._y, {String texturePath, int width, int height}) {
		if (texturePath != null) _texture = new Texture(texturePath);
		if (width == null) _width = 32;
		else _width = width;
		if (height == null) _height = 32;
		else _height = height;
	}

	void loadData(String josnFile) {
		JSONRequest req = new JSONRequest(josnFile);
		if (req.hasKey("texture")) {
			JsonObject texture = req.get("texture");
			List files = texture.files;
			if (files.length > 1) {
				if (texture.containsKey("random")) {
					if (texture.random) _texture = new Texture(files[random.nextInt(files.length)]);
					else _animTexture = new AnimatedTexture(texture.interval, files);
				} else _animTexture = new AnimatedTexture(texture.interval, files);
			} else {
				_texture = new Texture(files[0]);
			}
			if (texture.containsKey("damage")) _damage = new AnimatedTexture(null, texture.damage);
			if (texture.containsKey("shadow")) _shadowOffset = texture.shadow;
			if (texture.containsKey("scale")) _scale = texture.scale;
		}
		if (req.hasKey("entity")) {
			JsonObject entity = req.get("entity");

			if(entity.containsKey("health")) _health = entity.health;
			else _health = 1;
			_maxHealth = _health;
		}

		if (_texture != null) {
			_texture.getTexture().onLoad.listen((e) {
				_width = _texture.getTexture().width;
				_height = _texture.getTexture().height;
			});
		}
	}

	void render(CanvasRenderingContext2D context) {
		if (_texture != null) {
			context..shadowOffsetX = 0
			..shadowOffsetY = _shadowOffset
			..shadowBlur = _shadowOffset / 2
			..shadowColor = 'rgba(0, 0, 0,  0.5)';
			context.drawImageScaled(_texture.getTexture(), getBounds().left, getBounds().top, getBounds().width, getBounds().height);
			context..shadowOffsetX = 0
			..shadowOffsetY = 0
			..shadowBlur = 0
			..shadowColor = 'rgba(255, 255, 255,  1)';
			if (_damage != null) {
				if (_health <= 0) _health = 0;
				double steps =  _maxHealth / (_damage.size() + 1);
				int index = (_damage.size() + 1) - ((_health / _maxHealth) * steps).round() - 1;
				if (index > 0) {
					_damage.setCurrent(index - 1);
					context.drawImageScaled(_damage.getCurrent().getTexture(), getBounds().left, getBounds().top, getBounds().width, getBounds().height);
				}
			}
		}
	}

	void update(final double elapsed) {
		if (_animTexture != null) {
			_animTexture.update(elapsed);
			_texture = _animTexture.getCurrent();
		}
	}

	Rectangle getBounds({bool small}) {
		double scale = _scale;
		if (small != null) {
			if (small) {
				scale /= 1.75;
			}
		}
		double width =  _width * scale;
		double height =  _height * scale;
		return new Rectangle(_x - (width / 2), _y - (height / 2), width, height);
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

	void resetHealth() {
		_health = _maxHealth;
	}

	void remove() {
		_remove = true;
	}

	bool isRemoved() {
		return _remove;
	}

	void damage(int damage) {
		_health -= damage;
		if (_health <= 0) remove();
	}

	bool collide(Entity entity, {bool point, bool doSmall}) {
		if (entity == null) return false;
		if (point != null) {
			if (point)  return getBounds().containsPoint(entity.getPosition());
		}
		if (doSmall != null) {
			return getBounds(small: doSmall).intersects(entity.getBounds());
		}
		return getBounds().intersects(entity.getBounds());
	}
}

class Player extends Entity {
	int _score = 0;
	Player() : super(0.0, 0.0, width: 79, height: 55) {
		loadData("player.json");
	}

	void update(final double elapsed) {
		super.update(elapsed);
		if(!_remove) {
			double pVelocity = velocity * 1.25;
			if (Keyboard.isPressed(KeyCode.A) || Keyboard.isPressed(KeyCode.LEFT)) _x -= pVelocity * elapsed;
			if (Keyboard.isPressed(KeyCode.D) || Keyboard.isPressed(KeyCode.RIGHT)) _x += pVelocity * elapsed;
			if (Keyboard.isPressed(KeyCode.W) || Keyboard.isPressed(KeyCode.UP)) _y -= pVelocity * elapsed;
			if (Keyboard.isPressed(KeyCode.S) || Keyboard.isPressed(KeyCode.DOWN)) _y += pVelocity * elapsed;
			if (getBounds().left < 0) _x = getBounds().width / 2;
			if (getBounds().right > GameHost.width) _x = 0.0 + GameHost.width - (getBounds().width / 2);
			if (getBounds().top < 40) _y = (getBounds().height / 2) + 40.0; // To not get to close to the text at the top
			if (getBounds().bottom > GameHost.height) _y = GameHost.height - (getBounds().height / 2);
		}
		if (_health <= 0) remove();
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

	void reset() {
		_score = 0;
		_remove = false;
		resetHealth();
	}
}

class Enemy extends Entity {
	final String _type;

	Enemy(this._type) : super(0.0, 0.0) {
		loadData("${_type}.json");
		randomPosition(y:-100.0);
	}

	void randomPosition({double y}) {
		int width = GameHost.width;
		if (_texture != null) width -= (_texture.getTexture().width * 0.8).round();
		_x = 0.0 + random.nextInt(width);
		if (y == null) y = 0.0;
		_y = y;
	}
	
	void update(final double elapsed) {
		super.update(elapsed);
		if (_y +  _texture.getTexture().height > GameHost.height) destroyEnemy();
	}
	
	void destroyEnemy() {
		// TODO Break/Death animation
		enemy.remove();
	}
}

class Meteor extends Enemy {
	double _speedMul = 0.0;
	Meteor() : super("meteor") {
		_speedMul = 1.0 + random.nextDouble();
		if (_speedMul < 1.0) _speedMul = 1.0;
		if (_speedMul > 1.5) _speedMul = 1.5;
	}

	void update(final double elapsed) {
		super.update(elapsed);
		_y += elapsed * (velocity * _speedMul);
	}
}
