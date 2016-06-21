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
		if (interval == null) interval = 1000;
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
