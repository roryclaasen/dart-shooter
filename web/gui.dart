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

class GUIElement {
	int _x, _y;
	int _width = 0, _height = 0;
	bool _visible = true;

	GUIElement(this._x, this._y, {int width, int height}) {
		if (width != null) _width = width;
		if (height != null) _height = height;
	}

	Rectangle getBounds() {
		return new Rectangle(_x, _y, _width, _height);
	}

	void render(CanvasRenderingContext2D context) {}

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

	void setVisible(bool visible) {
		_visible = visible;
	}

	bool isVisible() {
		return _visible;
	}
}

class GUIButton extends GUIElement {
	Texture _texture, _hover, _active;
	final String detail;

	GUIButton(int x, int y, this.detail, final CanvasElement canvas) : super(x, y){
		_texture = new Texture("buttonBlue.png");
		_hover = new Texture("buttonRed.png");
		_active = _texture;
		_texture.getTexture().onLoad.listen((e) {
			_width = _active.getTexture().width;
			_height = _active.getTexture().height;
		});
		canvas.onMouseMove.listen((e) {
			if (isVisible()) {
				_active = _texture;
				if (canvas.getBoundingClientRect().containsPoint(e.client)) {
					if (getBounds().containsPoint(e.offset)) {
						_active = _hover;
					}
				}
			}
		});
		canvas.onMouseUp.listen((e) {
			if (isVisible()) {
				if (canvas.getBoundingClientRect().containsPoint(e.client)) {
					if (getBounds().containsPoint(e.offset)) {
						window.dispatchEvent(new CustomEvent('guiButtonClick', detail: this.detail));
					}
				}
			}
		});
	}

	void render(CanvasRenderingContext2D context) {
		if (isVisible()) {
			if (_active != null) context.drawImage(_active.getTexture(), getBounds().left, getBounds().top);
			TextUtil.dark();
			TextUtil.drawCenteredString(context, detail, _x, _y + (_height / 4).round() - 2);
			TextUtil.light();
		}
	}

	Rectangle getBounds() {
		return new Rectangle(_x - (_width / 2), _y - (_height / 2), _width, _height);
	}
}
