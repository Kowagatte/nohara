extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var _pos = self.get_parent().get_parent().position
	self.text = "X: " + ("%.2f" % _pos.x) + " Y: " + ("%.2f" % _pos.y) + " Z: " + ("%.2f" % _pos.z)
