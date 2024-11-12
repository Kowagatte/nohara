extends Node
class_name Item

@export var itemName: String
@export var amount: int = 1

func getTexture() -> TextureRect:
	return $Texture

#func _init(itemName: String, amount: int = 1):
	#self.itemName = itemName
	#self.amount = amount
