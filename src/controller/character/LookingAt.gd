extends RayCast3D
class_name LookingAt

signal changed

var item: Item = null

func _physics_process(_delta):
	if self.is_colliding():
		if self.get_collider().get_parent() is Item:
			item = self.get_collider().get_parent()
		else:
			item = null
	else:
		item = null
	changed.emit()
