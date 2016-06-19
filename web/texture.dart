part of shooter;

class Texture {
	ImageElement _image;
	String _source;

	Texture(String source) {
		_source = source;
		load();
	}

	void load() {
		_image = new ImageElement(src: 'assets/' + _source);
	}

	ImageElement getTexture() {
		return _image;
	}
}

class AnimatedTexture {
	List _list;
	int _index = 0;
	int _time = 0;
	int _interval;

	AnimatedTexture(this._interval, List files) {
		_list = new List();
		for (int i = 0; i < files.length; i++){
			_list.add(new Texture(files[i]));
		}
		_time = 0;
	}

	void update(final double elapsed) {
		_time++;
		if(_time >= _interval) next();
	}

	void next() {
		_time = 0;
		_index++;
		if (_index >= _list.length) _index = 0;
	}

	Texture getCurrent() {
		return _list[_index];
	}
}
