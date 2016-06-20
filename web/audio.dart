part of shooter;

class AudioMaster {
	static final AudioContext audioContext = new AudioContext();

	static Sound sfx_shieldDown;
	static Sound sfx_lose;

	AudioMaster() {
		sfx_shieldDown = new Sound("sfx_shieldDown.ogg");
		sfx_lose = new Sound("sfx_lose.ogg");
	}
}

class Sound {
	String _file;

	Sound(this._file);

	void play() {
		HttpRequest.request("assets/" + _file, responseType: "arraybuffer").then((HttpRequest request) {
			return AudioMaster.audioContext.decodeAudioData(request.response).then((AudioBuffer buffer) {
				AudioBufferSourceNode  source = AudioMaster.audioContext.createBufferSource();
				source.buffer = buffer;
				source.connectNode(AudioMaster.audioContext.destination);
				source.start(AudioMaster.audioContext.currentTime);
			});
		});
	}
}
