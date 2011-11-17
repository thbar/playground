I wanted to see if it's possible to sync a music track with a given BPM (beats per minute) with a three.js animation.

It works (currently on Chrome) - here are the key points:

* `audio.currentTime` returns the audio position in seconds
* I use that and the precomputed BPM to guess the current beat index
* three.js is used for rendering
* the jQuery easing functions are used to bounce the cubes

Follow the author on Twitter! [thibaut_barrere](http://www.twitter.com/thibaut_barrere)