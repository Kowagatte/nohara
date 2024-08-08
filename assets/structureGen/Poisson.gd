extends Node
class_name Poisson
# Fast Poisson Disk Sampling
# Implementation of this paper: https://www.cs.ubc.ca/~rbridson/docs/bridson-siggraph07-poissondisk.pdf
# Credits to Robert Bridson

# Misc
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Constants
const k: int = 60
var w: float
var isOriginRandomized: bool
var origin: Vector2

# Variables
var r: int
var _size: Vector2

# data
var data = []

# Constructor
func _init(_seed: int, randomized: bool, r: int = 4, _size = Vector2(64, 64), _origin = Vector2(0, 0)):
	self.rng.seed = _seed
	self.r = r
	self._size = _size
	self.w = r / sqrt(2)
	self.isOriginRandomized = randomized
	self.origin = _origin
	
	generate()

func generate():
	# set up the size of the map
	var width = _size.x
	var height = _size.y
	
	# Calculate the rows and columns for the background grid
	var cols = ceil(width / w)
	var rows = ceil(height / w)
	
	var active = []
	
	# Initialize the background grid to -1
	var grid = []
	grid.resize(cols*rows)
	grid.fill(-1)
	
	var point = origin
	
	# Step 1 - select origin (random point)
	if isOriginRandomized:
		var x = rng.randi_range(0, width-1)
		var y = rng.randi_range(0, height-1)
		point = Vector2(x, y)
	
	var i = floor(point.x/w)
	var j = floor(point.y/w)
	grid[(i * rows) + j] = point
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
			
			var row = floor(sample.x / w)
			var col = floor(sample.y / w)
			
			if (sample.x >= 0) and (sample.x < _size.x) and (sample.y >= 0) and (sample.y < _size.y):
			#if ( col >= 0) and (col < cols) and (row >= 0) and (row < rows):	
				if typeof(grid[(row * rows) + col]) == TYPE_INT:
					var valid = true
					# Must check 2 chunks in each direction since the diagonal
					# of a given chunk is r not the width.
					for n in range(-2, 3):
						for m in range(-2, 3):
							var neighborIndex = ((row + n) * rows ) + (col + m)
							if (neighborIndex >= 0) and (neighborIndex < grid.size()):
								var neighbor = grid[neighborIndex]
								if typeof(neighbor) == TYPE_VECTOR2:
									var distance = floor(sample.distance_to(neighbor))
									if distance < r:
										valid = false
					if valid:
						found = true
						grid[(row * rows) + col] = sample
						active.push_back(sample)
						break
		if not found:
			active.remove_at(index)
	
	for p in grid:
		if typeof(p) == TYPE_VECTOR2:
			data.append(p)

func getImage():
	var img = Image.create(_size.x, _size.y, false, Image.FORMAT_RGB8)
	img.fill(Color(255, 255, 255))
	for pos in data:
		img.set_pixel(pos.x, pos.y, Color(0, 0, 0))
	return img
