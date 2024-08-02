extends Node
class_name GradientGenerator

var rng = RandomNumberGenerator.new() as RandomNumberGenerator
var _size: Vector2
static var _gradient: Gradient = preload("res://assets/RadialGradientGenerator/StandardGradient.tres")
var data = []

func _init(_size: Vector2, _seed: int):
	self._size = _size
	self.rng.seed = _seed
	generate()
	#blur()

func generate_points():
	var points = []
	var min = (_size.x/256)
	points.resize(rng.randi_range(min, min+3))
	for p in range(points.size()):
		points[p] = Vector2(rng.randi_range(_size.x/5, (_size.x-1)-(_size.x/5)), rng.randi_range(_size.y/5, (_size.y-1)-(_size.y/5)))
	return points

func calculateMinRadius(point: Vector2):
	var distances = []
	# top_edge
	distances.append(point.distance_to(Vector2(point.x, 0)))
	# bottom_edge
	distances.append(point.distance_to(Vector2(point.x, _size.y-1)))
	# left_edge
	distances.append(point.distance_to(Vector2(0, point.y)))
	# right_edge
	distances.append(point.distance_to(Vector2(_size.x-1, point.y)))
	
	distances.sort()
	
	return distances[0]

func generate():
	
	var points2d = generate_points()
	var points = []
	for point in points2d:
		var radius = calculateMinRadius(point)
		points.append(Vector3(point.x, point.y, radius))
		
	#var image = Image.create(_size.x, _size.y, false, Image.FORMAT_RGBA8)
	#image.fill(Color(255, 255, 255))
	
	#var ratio = _size.x / _size.y
	
	data = []
	for i in range(_size.x):
		data.append([])
		for j in range(_size.y):
			data[i].append(1.0)
	
	for x in range(_size.x):
		for y in range(_size.y):
			
			for p in points:
				var dist = Vector2(x, y).distance_to(Vector2(p.x, p.y))
				var color = _gradient.sample(dist / p.z)
				data[x][y] = data[x][y] * (1.0 - (1.0 - color.r))
				#pixels[x][y] = pixels[x][y].darkened(1 - color.r)
			
			#image.set_pixel(x, y, pixels[x][y])
	

func blur():
	# loop through all pixels in image
	for i in range(_size.x):
		for j in range(_size.y):
			var pixel = data[i][j]
			# If the pixel is white ignore it.
			if pixel != 1.0:
				# loop through neighbors
				var average = 0.0
				var count = 0
				for x in range(-1, 2):
					for y in range(-1, 2):
						if (i+x) >= 0 and (j+y) >= 0 and (i+x) < _size.x and (j+y) < _size.y:
							var neighbor = data[i+x][j+y]
							average += neighbor
							count += 1
							pass
				average = average / count
				data[i][j] = average
