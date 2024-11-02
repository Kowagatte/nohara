extends Node
class_name Islands

# Contains the island information, islands are indexed based on their position
# in the array.
var islands = []

# Dictionary for all chunks containing an island. The value at any given
# key is the index of the island the chunk is part of.
var chunks = {}

func _init():
	instantiateWorldMap()
	#createIsland(Vector2(0, 0), 4)
	#islands[0] = createSpawnIsland()

func instantiateWorldMap():
	var maxRadius = getIslandSizeInChunks(IslandSize.HUGE) + 1
	var worldSize = Vector2(1001, 1001)
	#var origin = Vector2(floor(worldSize.x / 2), floor(worldSize.y / 2))
	var origin = Vector2(0, 0)
	var poisson = Poisson.new(1337, false, maxRadius, worldSize, origin)
	var data = poisson.data
	print(data.size())
	
	# Convert poisson coords to world coords
	
	for point in poisson.data:
		createIsland(point, randi_range(0, 4))
	
	print(islands)

func getIsland(key):
	if chunks.has(key):
		return islands[chunks.get(key)]
	else:
		return null

func chunkIsIsland(x, z):
	return chunks.has(Chunk.getChunkKey(x, z))

func createIsland(position, size):
	var sizeInChunks = getIslandSizeInChunks(size)
	for x in range(sizeInChunks):
		for z in range(sizeInChunks):
			var key = Chunk.getChunkKey(x + position.x, z + position.y)
			if chunks.has(key):
				return 1
			else:
				chunks[key] = islands.size()
	
	var data = null#createGradient(size)
	
	var island = {
		"position": {
			"x": position.x,
			"z": position.y
		},
		"size": size,
		"span": {
			"x": (position.x + (sizeInChunks - 1)),
			"z": (position.y + (sizeInChunks - 1))
		},
		"data": data
	}
	
	islands.append(island)

func generateIslandData(chunkKey):
	if chunks.has(chunkKey):
		var island = islands[chunks.get(chunkKey)]
		var islandSize = island["size"]
		var gradient = createGradient(islandSize)
		island["data"] = gradient

func createGradient(size):
	var sizeInMeters = getIslandSize(size) + 1
	var gradient = GradientGenerator.new(Vector2(sizeInMeters, sizeInMeters), randi())
	return gradient.data

# An Islands selected chunks is a perfect square, this returns the length in chunks.
# size = IslandSize or int represnting the size (1-4)
func getIslandSizeInChunks(size):
	return (size * 256) / 64#(size * 4)

# An Islands selected chunks is a perfect square, this returns the length in meters.
# size = IslandSize or int represnting the size (1-4)
func getIslandSize(size):
	return size * 256

# Enum for Island sizes
# SMALL = 256m or 4x4 chunks
# MEDIUM = 512m or 8x8 chunks
# LARGE = 768m or 12x12 chunks
# HUGE = 1024m or 16x16 chunks
enum IslandSize {SMALL = 1, MEDIUM = 2, LARGE = 3, HUGE = 4}
