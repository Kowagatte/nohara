extends RigidBody3D

func _ready() -> void:
	body_entered.connect(_collided)
	pass

func _collided(body):
	print("collided")
	pass
