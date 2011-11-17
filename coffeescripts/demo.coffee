class Sound
  constructor: (audio, bpm) ->
    @audio = audio
    @bpm = bpm

  play: ->
    @audio.play()
    
  currentTime: -> @audio.currentTime
  
  currentFloatBeat: ->
    @audio.currentTime / (60.0 / @bpm)
    
  currentBeat: ->
    Math.floor(@.currentFloatBeat())
    
class Engine
  constructor: (container) ->
    @container = container
    @setupEngine()
    @setupMeshes()
    
  setupEngine: ->
    @scene = new THREE.Scene
    @camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000)
    @camera.position.z = 1000
    @scene.add(@camera)
    @renderer = new THREE.CanvasRenderer
    @renderer.setSize(window.innerWidth, window.innerHeight)
    @container.append(@renderer.domElement)

  setupMeshes: ->
    @group = new THREE.Object3D
    material = new THREE.MeshNormalMaterial
    geometry = new THREE.CubeGeometry(100, 100, 100)
    
    @meshes = []
    
    i = 0
    while i <= 20
      i += 1
      mesh = new THREE.Mesh(geometry, material)
      mesh.position.x = Math.random() * 1000 - 500
      mesh.position.y = Math.random() * 1000 - 500
      mesh.position.z = Math.random() * 1000 - 500
      mesh.rotation.x = Math.random() * 360 * (Math.PI / 180)
      mesh.rotation.y = Math.random() * 360 * (Math.PI / 180)
      @meshes.push(mesh) # TODO - use the group to iterate instead
      @group.add(mesh)
    
    @scene.add(@group)
    
  setupStats: ->
    @stats = new Stats
    @stats.domElement.style.position = 'absolute'
    @stats.domElement.style.top = '0px'
    @stats.domElement.style.zIndex = 100
    @container.appendChild(@stats.domElement)
  
  setupSound: (sound) ->
    @sound = sound
    
  render: ->
    currentBeat = @.sound.currentBeat()
    if currentBeat != @previousBeat
      @previousBeat = currentBeat
      
      pattern = 1 + Math.floor(currentBeat / 8)
      patternPos = 1 + currentBeat % 8
      
      $('#beatcount').html("#{pattern} / #{patternPos}")

    freq = 2
    currentTime = (@.sound.currentFloatBeat() % freq)
    odd = (@.sound.currentFloatBeat() % (freq * 2)) >= freq
  
    start = 0
    end = 0.5
    [start, end] = [end, start] if odd
    x = $.easing.easeOutBounce(null, currentTime, start, end - start, freq)

    for mesh in @meshes
      mesh.rotation.x = x
      mesh.rotation.y += 0.02
      mesh.rotation.z = 3 * x
    
    @renderer.render(@scene, @camera)
    @stats.update() if @stats

$ ->
  engine = new Engine($('#container'))
  animate = ->
    requestAnimationFrame(animate)
    engine.render()

  sound = new Sound($('audio')[0], 130.4)
  sound.play()
  engine.setupSound(sound)
  animate()
