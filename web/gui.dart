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
	bool _useFontAwesome = false;

	GUIButton(int x, int y, this.detail, final CanvasElement canvas, {bool isSmall, bool fa}) : super(x, y) {
		_texture = new Texture("buttonBlue.png");
		_hover = new Texture("buttonRed.png");
		if (isSmall != null) {
			if (isSmall) {
				_texture = new Texture("buttonBlueSmall.png");
				_hover = new Texture("buttonRedSmall.png");
			}
		}
		if (fa != null) {
			if (fa) _useFontAwesome = true;
		}
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
			if (detail != null) {
				TextUtil.dark();
				TextUtil.drawCenteredString(context, detail, _x, _y + (_height / 4).round() - 1, useFontAwesome:_useFontAwesome);
				TextUtil.light();
			}
		}
	}

	Rectangle getBounds() {
		return new Rectangle(_x - (_width / 2), _y - (_height / 2), _width, _height);
	}
}

class GUIToggleButton extends GUIButton {
	String _on, _off, _current;
	GUIToggleButton(int x, int y, String detail, final CanvasElement canvas, this._on, this._off,{bool isSmall, bool fa}) : super(x, y, detail,canvas, isSmall:isSmall, fa:fa) {
		_current = _on;
	}

	void toggle() {
		if (isOn()) _current = _off;
		else _current = _on;
	}

	String getCurrent() {
		return _current;
	}

	bool isOn() {
		return _current == _on;
	}

	void render(CanvasRenderingContext2D context) {
		if (isVisible()) {
			if (_active != null) context.drawImage(_active.getTexture(), getBounds().left, getBounds().top);
			if (detail != null) {
				TextUtil.dark();
				TextUtil.drawCenteredString(context, _current, _x, _y + (_height / 4).round() - 2, useFontAwesome:_useFontAwesome);
				TextUtil.light();
			}
		}
	}
}

class Background extends GUIElement {
	String _baseImage;
	Texture _background, _stars;
	int _imgWidth = 0, _imgHeight = 0;
	bool _moving = true;
	double _backgroundPos = 0.0, _starsPos = 0.0;
	int _velocity = 100;

	Background(this._baseImage) : super(0, 0, width:GameHost.width, height:GameHost.height) {
		_background = new Texture(_baseImage);
		_background.getTexture().onLoad.listen((e) {
			_imgWidth = _background.getTexture().width;
			_imgHeight = _background.getTexture().height;
		});
		_stars = new Texture("stars.png");
	}

	void render(CanvasRenderingContext2D context) {
		if (_background.getTexture() == null) return;
		try {
			for(int x = 0; x < (_width / _imgWidth).ceil(); x++) {
				for(int y = 0; y < (_height / _imgHeight).ceil() + 1; y++) {
					context.drawImage(_background.getTexture(), x * _imgWidth, (y * _imgHeight) + _backgroundPos.round());
				}
			}
			for(int x = 0; x < (_width / _imgWidth).ceil(); x++) {
				for(int y = 0; y < (_height / _imgHeight).ceil() + 1; y++) {
					context.drawImage(_stars.getTexture(), x * _imgWidth, (y * _imgHeight) + _starsPos.round());
				}
			}
		} catch(exception) {}
	}

	void update(final double elapsed) {
		if (_background.getTexture() == null) return;
		if (_moving) {
			_backgroundPos += elapsed * (_velocity / 1.75);
			if (_backgroundPos >= 0) _backgroundPos = 0.0 -_imgHeight;

			_starsPos += elapsed * _velocity;
			if (_starsPos >= 0) _starsPos = 0.0 -_imgHeight;
		}
	}

	bool isMoving() {
		return _moving;
	}

	void setIsMoving(bool moving) {
		_moving = moving;
	}
}
