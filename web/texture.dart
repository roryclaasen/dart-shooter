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
	//TODO Create class
}
