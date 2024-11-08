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
	var poisson = Poisson.new(rng.randi(), true, 384, _size)
	#print(poisson.data)
	#poisson.getImage().save_png("C:\\Users\\craft\\Documents\\poisson.png")
	return poisson.data
	
	#var points = []
	#var min = (_size.x/256)
	#points.resize(rng.randi_range(min, min+1))
	#for p in range(points.size()):
		#points[p] = Vector2(rng.randi_range(_size.x/5, (_size.x-1)-(_size.x/5)), rng.randi_range(_size.y/5, (_size.y-1)-(_size.y/5)))
	#return points

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
	
	var start = Time.get_ticks_usec()
	var points2d = generate_points()
	var end = Time.get_ticks_usec()
	print("generate points: "+str((end-start)/1000000.0)+"s")
	
	
	var points = []
	start = Time.get_ticks_usec()
	for point in points2d:
		var radius = calculateMinRadius(point)
		points.append(Vector3(point.x, point.y, radius))
	end = Time.get_ticks_usec()
	print("Calculate radius': "+str((end-start)/1000000.0)+"s")
	
	start = Time.get_ticks_usec()
	data = []
	for i in range(_size.x):
		data.append([])
		for j in range(_size.y):
			data[i].append(1.0)
	end = Time.get_ticks_usec()
	print("Array instantialization': "+str((end-start)/1000000.0)+"s")
	
	start = Time.get_ticks_usec()
	for x in range(_size.x):
		for y in range(_size.y):
			for p in points:
				var dist = Vector2(x, y).distance_to(Vector2(p.x, p.y))
				if dist <= p.z:
					var darkness = _gradient.sample(dist / p.z).r
					data[x][y] = data[x][y] * (1.0 - ( 1.0 - (darkness)))
	end = Time.get_ticks_usec()
	print("darkness calculation': "+str((end-start)/1000000.0)+"s")

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

func createImage():
	var img = Image.create(_size.x, _size.y, false, Image.FORMAT_RGB8)
	for x in range(_size.x):
		for y in range(_size.y):
			var c = data[x][y]
			img.set_pixel(x, y, Color(c, c, c))
	img.save_png("C:\\Users\\craft\\Documents\\test.png")
