extends Label

@onready var lookingAt: LookingAt = $"../../../CharacterBody3D/Camera3D/LookingAt"

func _ready() -> void:
	lookingAt.changed.connect(_update)

func _update():
	if lookingAt.targetExists():
		if lookingAt.getTarget() is Item:
			self.text = "%s x%d" % [lookingAt.getTarget().itemName, lookingAt.getTarget().amount]
		elif lookingAt.getTarget() is IObject:
			self.text = "%s" % lookingAt.getTarget().object_name
	else:
		self.text = ""
