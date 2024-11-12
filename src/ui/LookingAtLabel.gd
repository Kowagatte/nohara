extends Label

@onready var lookingAt: LookingAt = $"../../../CharacterBody3D/Camera3D/LookingAt"

func _ready() -> void:
	lookingAt.changed.connect(_update)

func _update():
	if lookingAt.item != null:
		self.text = "%s x%d" % [lookingAt.item.itemName, lookingAt.item.amount]
	else:
		self.text = ""
