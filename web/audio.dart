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

class AudioMaster {
	static final AudioContext audioContext = new AudioContext();

	static Sound sfx_shieldDown;
	static Sound sfx_lose;
	static Sound sfx_smash;
	static Sound sfx_laser2;

	static bool _muted = false;

	AudioMaster() {
		sfx_shieldDown = new Sound("sfx_shieldDown.ogg");
		sfx_lose = new Sound("sfx_lose.ogg");
		sfx_smash = new Sound("sfx_smash.ogg");
		sfx_laser2 = new Sound("sfx_laser2.ogg");
	}

	static void setMuted(bool mute) {
		_muted = mute;
	}

	static bool isMuted() {
		return _muted;
	}
}

class Sound {
	String _file;

	Sound(this._file);

	void play() {
		if (AudioMaster.isMuted()) return;
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
