extends Node3D

# Island Size TODO create a size map for small, medium, large islands.
const SIZE = 256 * 2
const HEIGHT_AMPLITUDE = 60

# For chunking system
var noise: FastNoiseLite
# Size in meters for each chunk
const CHUNK_SIZE = 64
# Number of chunks to load at a time
const CHUNK_AMOUNT = 16#16

var chunks = {}
var unready_chunks = {}
var thread: Thread

var islands: Islands


func _ready():
	
	islands = Islands.new()
	
	noise = FastNoiseLite.new()
	#noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.seed = 1337 #randi()
	noise.fractal_octaves = 2
	noise.fractal_lacunarity = 2
	noise.fractal_gain = 0.7
	noise.frequency = 0.008
	
	thread = Thread.new()

func addChunk(x, z):
	var key = Chunk.getChunkKey(x, z)
	if chunks.has(key) or unready_chunks.has(key):
		return
	
	var island = islands.getIsland(key)
	
	if not thread.is_started():
		thread.start(Callable(self, "loadChunk").bind(thread, x, z, key, island))
		unready_chunks[key] = 1

func loadChunk(_thread, x, z, key, island):
	
	if island != null:
		if island["data"] == null:
			islands.generateIslandData(key)
	
	var chunk = Chunk.new(noise, x * CHUNK_SIZE, z * CHUNK_SIZE, CHUNK_SIZE, island)
	chunk.visible = false
	chunk.name = key
	chunk.set_position(Vector3(x * CHUNK_SIZE, 0, z * CHUNK_SIZE))
	
	call_deferred("loadDone", chunk, _thread, key)

func loadDone(chunk, _thread, key):
	chunk.visible = true
	$Chunks.add_child(chunk)
	chunks[key] = chunk
	unready_chunks.erase(key)
	_thread.wait_to_finish()

func getChunk(x, z):
	var key = str(x)+","+str(z)
	if chunks.has(key):
		return chunks.get(key)
	else:
		return null

func _process(_delta):
	updateChunks()
	cleanChunks()
	resetChunks()

func updateChunks():
	var _position = ($Observer as FreeLookCamera).position
	var px = _position.x / CHUNK_SIZE
	var pz = _position.z / CHUNK_SIZE
	
	for x in range(px - CHUNK_AMOUNT * 0.5, px + CHUNK_AMOUNT * 0.5):
		for z in range(pz - CHUNK_AMOUNT * 0.5, pz + CHUNK_AMOUNT * 0.5):
			addChunk(x, z)
			var chunk = getChunk(x, z)
			if chunk != null:
				chunk.shouldUnload = false

func cleanChunks():
	for key in chunks:
		var chunk = chunks[key]
		if chunk.shouldUnload:
			chunk.visible = false
			chunk.queue_free()
			chunks.erase(key)
	pass

func resetChunks():
	for key in chunks:
		chunks[key].shouldUnload = true


