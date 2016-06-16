part of shooter;

class Entity {
	final double velocity = 128.0;
	ImageElement image;
	double x, y;

	Entity(this.x, this.y, String texture) {
		image = new ImageElement(src: 'assets/' + texture);
	}

	void render(CanvasRenderingContext2D context) {
		if(image != null) {
			context.drawImage(image, x, y);
		}
	}

	void update(final double elapsed) {}

	void setTexture(String texture) {
		this.image = new ImageElement(src: 'assets/' + texture);
	}

	void setImageElement(ImageElement image) {
		this.image = image;
	}

	ImageElement getImageElement(){
		return image;
	}

	double getX() {
		return x;
	}

	double getY() {
		return y;
	}

	void setX(double x){
		this.x = x;
	}

	void setY(double y){
		this.y = y;
	}
}

class Player extends Entity {
	Keyboard _keyboard;
	Player(Keyboard keyboard) : super(0.0, 0.0, "player.png"){
		_keyboard = keyboard;
	}

	void update(final double elapsed){
		if (_keyboard.isPressed(KeyCode.A)) x -= velocity * elapsed;
		if (_keyboard.isPressed(KeyCode.D)) x += velocity * elapsed;
		if (_keyboard.isPressed(KeyCode.W)) y -= velocity * elapsed;
		if (_keyboard.isPressed(KeyCode.S)) y += velocity * elapsed;
	}
}
