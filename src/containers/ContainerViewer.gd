extends GridContainer
class_name ContainerViewer

@export var inventory: ItemContainer
var itemframe = preload("res://src/containers/ItemFrame.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.columns = inventory.columns
	inventory.changed.connect(_update_view)
	for i in inventory.rows:
		for j in inventory.columns:
			var _if = itemframe.instantiate() as ItemFrame
			_if.name = "%d,%d" % [i, j]
			self.add_child(_if)


func _update_view():
	for i in inventory.rows:
		for j in inventory.columns:
			var ispot = self.get_node("%d,%d" % [i, j]) as ItemFrame
			if inventory.contents[i][j] == null:
				ispot.setContent(null)
				ispot.setAmount(0)
			else:
				var item = inventory.contents[i][j] as Item
				ispot.setContent(item.getTexture())
				ispot.setAmount(item.amount)
