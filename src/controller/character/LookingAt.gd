extends RayCast3D
class_name LookingAt

signal changed

var target = null

func targetExists() -> bool:
	return target != null

func getTarget():
	return target

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		if targetExists():
			if target is Item:
				PlayerState.getInventory().addItem(target)
				target.queue_free()
			elif target is IObject:
				target.interact()

func _physics_process(_delta):
	if self.is_colliding():
		if self.get_collider().get_parent() is Item:
			target = self.get_collider().get_parent()
			changed.emit()
			return
		elif self.get_collider().get_parent() is IObject:
			target = self.get_collider().get_parent()
			changed.emit()
			return
	target = null
	changed.emit()
