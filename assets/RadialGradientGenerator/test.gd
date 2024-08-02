extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var start = Time.get_ticks_usec()
	var gradient = GradientGenerator.new(Vector2(1024, 1024), 1337)
	var end = Time.get_ticks_usec()
	print(str((end-start)/1000000.0)+"s")
	
	#var img = Image.create(1024, 1024, false, Image.FORMAT_RGB8)
	#for x in range(gradient._size.x):
		#for y in range(gradient._size.y):
			#var c = gradient.data[x][y]
			#img.set_pixel(x, y, Color(c, c, c))
	#img.save_png("C:\\Users\\craft\\Documents\\test.png")
	
	pass # Replace with function body.

