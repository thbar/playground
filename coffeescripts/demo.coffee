class Engine
  constructor: () ->
    @container = document.body
    @setupEngine()
    @setupMeshes()
    
  setupEngine: ->
    @scene = new THREE.Scene
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000)
    @camera.position.z = 1000
    @scene.add(@camera)
    @renderer = new THREE.CanvasRenderer
    @renderer.setSize(window.innerWidth, window.innerHeight)
    @container.appendChild(@renderer.domElement)

  setupMeshes: ->
    geometry = new THREE.CubeGeometry(200, 200, 200)
    material = new THREE.MeshBasicMaterial({color: 0xff0000, wireframe: true })

    @mesh = new THREE.Mesh(geometry, material)
    @scene.add(@mesh)

  setupStats: ->
    @stats = new Stats
    @stats.domElement.style.position = 'absolute'
    @stats.domElement.style.top = '0px'
    @stats.domElement.style.zIndex = 100
    @container.appendChild(@stats.domElement)
  
  render: ->
    @mesh.rotation.x += 0.01
    @mesh.rotation.y += 0.02
    
    @renderer.render(@scene, @camera)
    @stats.update() if @stats

engine = new Engine
engine.setupStats()

# cannot get to put this in the class while keeping it working
animate = ->
  requestAnimationFrame(animate)
  engine.render()

animate()