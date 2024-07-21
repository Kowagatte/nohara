@tool
extends Node

var _size: Vector2:
	set(value):
		_size = value
		_image = generate_image()
var _image: Image
var _check:bool:
	set(_value):
		_image = generate_image()
var _points:Array[Vector2]:
	get:
		return _points
	set(value):
		_points = value
		_image = generate_image()
		notify_property_list_changed()

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
					distance[d] = clamp(distanceToPoint / (_size.x/2), 0, 1)
				
				var average = 1.0
				for d in range(distance.size()):
					average -= (1 - distance[d]) ** 2.5
				
				var total = average #1 - (average - distance.min()) #
				
				image.set_pixel(x, y, Color(total, total, total))
				
	
	#ResourceSaver.save(image, "res://assets/island_generation/RadialGradient2.tres")
	
	return image

func _get_property_list():
	var properties = []
	
	properties.append({
		"name": "_check",
		"type": TYPE_BOOL,
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
		"name": "_image",
		"type": TYPE_OBJECT,
	})

	
	return properties
