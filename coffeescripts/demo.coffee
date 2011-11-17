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
    
    @mesh.rotation.x = x
    @mesh.rotation.y += 0.02
    
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
