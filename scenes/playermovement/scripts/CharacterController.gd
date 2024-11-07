extends CharacterBody3D

# Signals
signal running
signal walking
signal walking_backwards
signal jumping
signal idle

var SPEED = 5.0
const WALKING_SPEED = 5.0
const RUNNING_SPEED = 8.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera = $Camera3D

@export_subgroup("Controller Specific")
@export_range(0.001, 1, 0.001) var look_sensitivity : float = 0.25

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * look_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * look_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(70))

func _physics_process(delta):
	camera.rotation.z = 0
	camera.rotation.y = 0
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		jumping.emit()
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("player_left", "player_right", "player_forward", "player_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if input_dir.y == 1:
		walking_backwards.emit()
		SPEED = WALKING_SPEED
	else:
		if Input.is_action_pressed("player_sprint"):
			running.emit()
			SPEED = RUNNING_SPEED
		else:
			walking.emit()
			SPEED = WALKING_SPEED
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if not velocity:
		idle.emit()

	move_and_slide()
