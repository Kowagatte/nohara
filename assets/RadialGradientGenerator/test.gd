extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var start = Time.get_ticks_usec()
	var gradient = GradientGenerator.new(Vector2(1024, 1024), 1337)
	var end = Time.get_ticks_usec()
	print("Total time: "+str((end-start)/1000000.0)+"s")
	
	gradient.createImage()
	
	
	pass # Replace with function body.

