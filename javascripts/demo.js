(function() {
  var Engine, animate, engine;

  Engine = (function() {

    function Engine() {
      this.container = document.body;
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
      return this.container.appendChild(this.renderer.domElement);
    };

    Engine.prototype.setupMeshes = function() {
      var geometry, material;
      geometry = new THREE.CubeGeometry(200, 200, 200);
      material = new THREE.MeshBasicMaterial({
        color: 0xff0000,
        wireframe: true
      });
      this.mesh = new THREE.Mesh(geometry, material);
      return this.scene.add(this.mesh);
    };

    Engine.prototype.setupStats = function() {
      this.stats = new Stats;
      this.stats.domElement.style.position = 'absolute';
      this.stats.domElement.style.top = '0px';
      this.stats.domElement.style.zIndex = 100;
      return this.container.appendChild(this.stats.domElement);
    };

    Engine.prototype.render = function() {
      this.mesh.rotation.x += 0.01;
      this.mesh.rotation.y += 0.02;
      this.renderer.render(this.scene, this.camera);
      if (this.stats) return this.stats.update();
    };

    return Engine;

  })();

  engine = new Engine;

  engine.setupStats();

  animate = function() {
    requestAnimationFrame(animate);
    return engine.render();
  };

  animate();

}).call(this);
