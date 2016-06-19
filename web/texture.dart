part of shooter;

class Texture {
	ImageElement _image;
	String _source;

	Texture(this._source) {
		_image = new ImageElement(src: 'assets/' + _source);
	}

	ImageElement getTexture() {
		return _image;
	}

	String getSource() {
		return _source;
	}
}

class AnimatedTexture {
	List _list;
	int _interval;
	int _index = 0;
	double _time = 0.0;

	AnimatedTexture(int interval, List files) {
		_list = new List();
		_interval = (interval / 1000).round();
		for (int i = 0; i < files.length; i++){
			_list.add(new Texture(files[i]));
		}
		_time = 0.0;
	}

	void update(final double elapsed) {
		_time += elapsed;
		if(_time >= _interval) next();
	}

	void next() {
		_time = 0.0;
		_index++;
		if (_index >= _list.length) _index = 0;
	}

	Texture getCurrent() {
		return _list[_index];
	}
}
