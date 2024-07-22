@tool
extends Node

var rng = RandomNumberGenerator.new() as RandomNumberGenerator

var _size: Vector2 = Vector2(513, 513):
	set(value):
		_size = value
		_image = generate_image()

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
		generate_points()
		notify_property_list_changed()

var _points:Array[Vector2]:
	get:
		return _points
	set(value):
		_points = value
		_image = generate_image()
		notify_property_list_changed()

var _falloff_intensity: int = 2:
	set(_value):
		_falloff_intensity = _value
		_image = generate_image()
		notify_property_list_changed()

var _merge_intensity: float = 1.8:
	set(_value):
		_merge_intensity = _value
		_image = generate_image()
		notify_property_list_changed()

func generate_points():
	var points: Array[Vector2] = []
	points.resize(rng.randi_range(1, 7))
	for p in range(points.size()):
		points[p] = Vector2(rng.randi_range(0, _size.x), rng.randi_range(0, _size.y))
	_points = points

func generate_image():
	var image = Image.create(_size.x, _size.y, false, Image.FORMAT_RGBA8)
	image.fill(Color(255, 255, 255))
	
	if _points.size() > 0:
		var distance: Array[float] = []
		distance.resize(_points.size())
		distance.fill(0.0)
		
		for x in _size.x:
			for y in _size.y:
				
				for d in range(distance.size()):
					var dx = (_points[d].x - x) ** 2
					var dy = (_points[d].y - y) ** 2
					var distanceToPoint = sqrt(dx + dy)
					distance[d] = clamp(distanceToPoint / (_size.x / _falloff_intensity), 0, 1)
				
				var average = 1.0
				for d in range(distance.size()):
					average -= (1 - distance[d]) ** _merge_intensity
				
				var total = average #1 - (average - distance.min()) #
				
				image.set_pixel(x, y, Color(total, total, total))
				
	
	ResourceSaver.save(image, "res://assets/island_generation/RadialGradient2.tres")
	
	return image

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
		"name": "_falloff_intensity",
		"type": TYPE_INT,
	})
	
	properties.append({
		"name": "_merge_intensity",
		"type": TYPE_FLOAT,
	})
	
	properties.append({
		"name": "_image",
		"type": TYPE_OBJECT,
	})
	
	return properties
