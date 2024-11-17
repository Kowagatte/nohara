extends RayCast3D
class_name LookingAt

signal changed

var item: Item = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if item != null:
			PlayerState.getInventory().addItem(item)
			item.queue_free()

func _physics_process(_delta):
	if self.is_colliding():
		if self.get_collider().get_parent() is Item:
			item = self.get_collider().get_parent()
		else:
			item = null
	else:
		item = null
	changed.emit()
