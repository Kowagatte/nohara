extends Node3D

@onready var character = $".."
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	character.jumping.connect(_jumping_anim)
	character.walking.connect(_walking_anim)
	character.walking_backwards.connect(_walking_backwards_anim)
	character.idle.connect(_idle_anim)
	character.running.connect(_running_anim)
	pass # Replace with function body.

func _running_anim():
	if animation_player.current_animation != "Jump":
		animation_player.play("Run")

func _idle_anim():
	if animation_player.current_animation != "Jump":
		animation_player.stop()
		animation_player.play("Idle")

func _jumping_anim():
	animation_player.stop()
	animation_player.play("Jump")

func _walking_anim():
	if animation_player.current_animation != "Jump":
		animation_player.play("Walk")

func _walking_backwards_anim():
	if animation_player.current_animation != "Jump":
		animation_player.play("WalkBackwards")
