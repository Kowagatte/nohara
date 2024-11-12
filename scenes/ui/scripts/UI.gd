extends Control

@onready var inventory: ItemContainer = $Inventory

func _input(event: InputEvent) -> void:
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_X:
				var log = preload("res://src/items/Log.tscn").instantiate() as Item
				inventory.setItemAtPosition(log, 0, 0)
	
	if event.is_action_pressed("toggle_inventory"):
		inventory.visible = not inventory.visible
		if inventory.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("toggle_options"):
		print("2")
		


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
