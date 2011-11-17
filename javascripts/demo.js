(function() {
  var Engine, Sound;

  Sound = (function() {

    function Sound(audio, bpm) {
      this.audio = audio;
      this.bpm = bpm;
    }

    Sound.prototype.play = function() {
      return this.audio.play();
    };

    Sound.prototype.currentTime = function() {
      return this.audio.currentTime;
    };

    Sound.prototype.currentFloatBeat = function() {
      return this.audio.currentTime / (60.0 / this.bpm);
    };

    Sound.prototype.currentBeat = function() {
      return Math.floor(this.currentFloatBeat());
    };

    return Sound;

  })();

  Engine = (function() {

    function Engine(container) {
      this.container = container;
      this.setupEngine();
      this.setupMeshes();
    }

    Engine.prototype.setupEngine = function() {
      this.scene = new THREE.Scene;
      this.camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000);
      this.camera.position.z = 1000;
      this.scene.add(this.camera);
      this.renderer = new THREE.CanvasRenderer;
      this.renderer.setSize(window.innerWidth, window.innerHeight);
      return this.container.append(this.renderer.domElement);
    };

    Engine.prototype.setupMeshes = function() {
      var geometry, i, material, mesh;
      this.group = new THREE.Object3D;
      material = new THREE.MeshNormalMaterial;
      geometry = new THREE.CubeGeometry(100, 100, 100);
      this.meshes = [];
      i = 0;
      while (i <= 20) {
        i += 1;
        mesh = new THREE.Mesh(geometry, material);
        mesh.position.x = Math.random() * 1000 - 500;
        mesh.position.y = Math.random() * 1000 - 500;
        mesh.position.z = Math.random() * 1000 - 500;
        mesh.rotation.x = Math.random() * 360 * (Math.PI / 180);
        mesh.rotation.y = Math.random() * 360 * (Math.PI / 180);
        this.meshes.push(mesh);
        this.group.add(mesh);
      }
      return this.scene.add(this.group);
    };

    Engine.prototype.setupStats = function() {
      this.stats = new Stats;
      this.stats.domElement.style.position = 'absolute';
      this.stats.domElement.style.top = '0px';
      this.stats.domElement.style.zIndex = 100;
      return this.container.appendChild(this.stats.domElement);
    };

    Engine.prototype.setupSound = function(sound) {
      return this.sound = sound;
    };

    Engine.prototype.render = function() {
      var currentBeat, currentTime, end, freq, mesh, odd, pattern, patternPos, start, x, _i, _len, _ref, _ref2;
      currentBeat = this.sound.currentBeat();
      if (currentBeat !== this.previousBeat) {
        this.previousBeat = currentBeat;
        pattern = 1 + Math.floor(currentBeat / 8);
        patternPos = 1 + currentBeat % 8;
        $('#beatcount').html("" + pattern + " / " + patternPos);
      }
      freq = 2;
      currentTime = this.sound.currentFloatBeat() % freq;
      odd = (this.sound.currentFloatBeat() % (freq * 2)) >= freq;
      start = 0;
      end = 0.5;
      if (odd) _ref = [end, start], start = _ref[0], end = _ref[1];
      x = $.easing.easeOutBounce(null, currentTime, start, end - start, freq);
      _ref2 = this.meshes;
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        mesh = _ref2[_i];
        mesh.rotation.x = x;
        mesh.rotation.y += 0.02;
        mesh.rotation.z = 3 * x;
      }
      this.renderer.render(this.scene, this.camera);
      if (this.stats) return this.stats.update();
    };

    return Engine;

  })();

  $(function() {
    var animate, engine, sound;
    engine = new Engine($('#container'));
    animate = function() {
      requestAnimationFrame(animate);
      return engine.render();
    };
    sound = new Sound($('audio')[0], 130.4);
    sound.play();
    engine.setupSound(sound);
    return animate();
  });

}).call(this);
