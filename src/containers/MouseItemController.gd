extends Control
class_name MouseItemController

@onready var image: TextureRect = $image
@onready var amount: Label = $image/amount

func _update(item: Item) -> void:
	if item != null:
		image.texture = item.getTexture().texture
		amount.text = "%d" % item.amount
		self.visible = true
	else:
		self.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		self.position = event.position
