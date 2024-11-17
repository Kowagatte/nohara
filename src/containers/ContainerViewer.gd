extends GridContainer
class_name ContainerViewer

var container: ItemContainer:
	set(value):
		container = value
		_setup_container()

var itemframe = preload("res://src/containers/ItemFrame.tscn")

# Called when the node enters the scene tree for the first time.
func _setup_container() -> void:
	self.columns = container.columns
	for i in container.rows:
		for j in container.columns:
			var _if = itemframe.instantiate() as ItemFrame
			_if.name = "%d,%d" % [i, j]
			self.add_child(_if)


func _update():
	for i in container.rows:
		for j in container.columns:
			var ispot = self.get_node("%d,%d" % [i, j]) as ItemFrame
			if container.contents[i][j] == null:
				ispot.setContent(null)
				ispot.setAmount(0)
			else:
				var item = container.contents[i][j] as Item
				ispot.setContent(item.getTexture())
				ispot.setAmount(item.amount)
