extends Node
class_name Islands

var islands = []
var chunks = {}

func _init():
	createIsland(Vector2(0, 0), 2)
	#islands[0] = createSpawnIsland()

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
	
	var data = createGradient(size)
	
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

#func createSpawnIsland():
	#var data = createGradient(1)
	#return {
	#"position": {
		#"x": 0,
		#"z": 0
	#},
	#"size": 1,
	#"span": {
		#"x": 3,
		#"z": 3
	#},
	#"data": data
#}

func createGradient(size):
	var sizeInMeters = getIslandSize(size) + 1
	var gradient = RadialGradientGenerator.new()
	gradient._size = Vector2(sizeInMeters, sizeInMeters)
	gradient.create()
	gradient._image.save_png("c:\\Users\\craft\\Desktop\\test.png")
	return gradient._image

# An Islands selected chunks is a perfect square, this returns the length in chunks.
# size = IslandSize or int represnting the size (1-4)
func getIslandSizeInChunks(size):
	return (size * 4)

# An Islands selected chunks is a perfect square, this returns the length in meters.
# size = IslandSize or int represnting the size (1-4)
func getIslandSize(size):
	return size * 256

# Enum for Island sizes
# SMALL = 256m or 4x4 chunks
# MEDIUM = 512m or 8x8 chunks
# LARGE = 1024m or 16x16 chunks
# HUGE = 2048m or 32x32 chunks
enum IslandSize {SMALL = 1, MEDIUM = 2, LARGE = 3, HUGE = 4}
