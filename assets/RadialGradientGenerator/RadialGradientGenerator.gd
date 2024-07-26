@tool
extends Node
class_name RadialGradientGenerator

var rng = RandomNumberGenerator.new() as RandomNumberGenerator

var _gradient: Gradient = Gradient.new():
	set(_value):
		_gradient = _value
		_image = generate_image()

var _size: Vector2 = Vector2(513, 513):
	set(value):
		_size = value
		#_image = generate_image()

var _image: Image

var _refresh:bool:
	set(_value):
		_image = generate_image()

var _seed:int = 0:
	set(_value):
		_seed = _value
		rng.seed = _value
		generate_points()
		notify_property_list_changed()

var _randomize:bool:
	set(_value):
		rng.randomize()
		_seed = rng.seed
		notify_property_list_changed()

var _points:Array[Vector2]:
	get:
		return _points
	set(value):
		_points = value
		_image = generate_image()
		notify_property_list_changed()

func create():
	rng.randomize()
	_seed = rng.seed
	return _image

func generate_points():
	var points: Array[Vector2] = []
	var min = (_size.x/256)
	points.resize(rng.randi_range(min, min+3))
	for p in range(points.size()):
		points[p] = Vector2(rng.randi_range(_size.x/5, (_size.x-1)-(_size.x/5)), rng.randi_range(_size.y/5, (_size.y-1)-(_size.y/5)))
	_points = points

func calculate_radius(point: Vector2):
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

func generate_image():
	
	var points = []
	for point in _points:
		var radius = calculate_radius(point)
		points.append(Vector3(point.x, point.y, radius))
	
	var image = Image.create(_size.x, _size.y, false, Image.FORMAT_RGBA8)
	image.fill(Color(255, 255, 255))
	
	#var ratio = _size.x / _size.y
	
	var pixels = []
	for i in range(_size.x):
		pixels.append([])
		for j in range(_size.y):
			pixels[i].append(Color(1.0, 1.0, 1.0))
	
	for x in range(_size.x):
		for y in range(_size.y):
			
			for p in points:
				var dist = Vector2(x, y).distance_to(Vector2(p.x, p.y))
				var color = _gradient.sample(dist / p.z)
				pixels[x][y] = pixels[x][y].darkened(1 - color.r)
			
			#image.set_pixel(x, y, pixels[x][y])
	
	blur_image(pixels, image)
	
	#ResourceSaver.save(image, "res://assets/island_generation/RadialGradient2.tres")
	#image.save_png("C:\\Users\\craft\\Desktop\\new_radial.png")
	
	return image

func get_neighbors(x, y, blur_amount = 1):
	var neighbors = []
	for x2 in range(x-blur_amount, x+blur_amount+1):
		for y2 in range(y-blur_amount, y+blur_amount+1):
			if x2 >= 0 and y2 >= 0 and x2 < _size.x and y2 < _size.y:
				neighbors.append(Vector2(x2, y2))
	return neighbors

func blur_image(pixels, image):
	for x in _size.x:
		for y in _size.y:
			var neighbors = get_neighbors(x, y, 1)
			var average = 0.0
			for n in neighbors:
				average += pixels[n.x][n.y].r
			average = average / neighbors.size()
			
			image.set_pixel(x, y, Color(average, average, average))

func _get_property_list():
	var properties = []
	
	properties.append({
		"name": "_refresh",
		"type": TYPE_BOOL,
	})
	
	properties.append({
		"name": "_randomize",
		"type": TYPE_BOOL,
	})
	
	properties.append({
		"name": "_seed",
		"type": TYPE_INT,
	})
	
	properties.append({
		"name": "_points",
		"type": TYPE_ARRAY,
	})
	
	properties.append({
		"name": "_size",
		"type": TYPE_VECTOR2,
	})
	
	properties.append({
		"name": "_gradient",
		"type": TYPE_OBJECT,
	})
	
	properties.append({
		"name": "_image",
		"type": TYPE_OBJECT,
	})
	
	return properties
