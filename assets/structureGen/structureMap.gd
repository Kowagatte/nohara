extends Control

@onready var display: TextureRect = $TextureRect
var rng = RandomNumberGenerator.new() as RandomNumberGenerator
@export var seed = 1337

const _size = Vector2(256, 256)

# Minimum distance two given points can be from each other
var r = 15

# The number of times we try to generate new points from an origin point
# before giving up.
const k = 30

var grid = []
var active = []

var w = r / sqrt(2)

# Called when the node enters the scene tree for the first time.
func _ready():
	var img = Image.create(_size.x, _size.y, false, Image.FORMAT_RGB8)
	img.fill(Color(255, 255, 255))
	
	# Set up random number generator with a given seed.
	rng.seed = seed
	
	# set up the size of the map
	var width = _size.x
	var height = _size.y
	
	# Calculate the rows and columns for the background grid
	var cols = floor(width / w)
	var rows = floor(height / w)
	
	# Initialize the background grid to -1
	grid.resize(cols*rows)
	grid.fill(-1)
	#for i in range(cols*rows):
	#	grid[i] = -1
	
	# Step 1 - select random point
	#var point = Vector2(rng.randi_range(0, width-1), rng.randi_range(0, height-1))
	var point = Vector2(0, 0)
	var i = floor(point.x/w)
	var j = floor(point.y/w)
	grid[i + j * cols] = point

	active.push_back(point)
	
	# Step 2
	
	while not active.is_empty():
		var index = floor(rng.randi_range(0, active.size()-1))
		point = active[index]
		var found = false
		for p in range(k):
			var angle = rng.randf_range(0, 2.0 * PI)
			var sample = Vector2(cos(angle), sin(angle))
			sample *= rng.randf_range(r, 2*r)
			sample += point
			sample = Vector2(ceil(sample.x), ceil(sample.y))
			
			var col = floor(sample.x / w)
			var row = floor(sample.y / w)
			
			if ( col >= 0) and (col < cols) and (row >= 0) and (row < rows):	
				if typeof(grid[col + row * cols]) == TYPE_INT:
					var valid = true
					# Must check 2 chunks in each direction since the diagonal
					# of a given chunk is r not the width.
					for n in range(-2, 3):
						for m in range(-2, 3):
							var neighborIndex = (col + n) + (row + m) * cols
							if (neighborIndex >= 0) and (neighborIndex < grid.size()):
								var neighbor = grid[neighborIndex]
								if typeof(neighbor) == TYPE_VECTOR2:
									var distance = floor(sample.distance_to(neighbor))
									if distance < r:
										valid = false
					if valid:
						found = true
						grid[col + row * cols] = sample
						active.push_back(sample)
						break
		if not found:
			active.remove_at(index)
	
	for pixel in grid:
		if typeof(pixel) == TYPE_VECTOR2:
			img.set_pixel(pixel.x, pixel.y, Color(0, 0, 0))
	
	display.texture = ImageTexture.create_from_image(img)
	
	#img.save_png("C:\\Users\\craft\\Desktop\\BlueNoise.png")
	#display.texture = ImageTexture.create_from_image(img)