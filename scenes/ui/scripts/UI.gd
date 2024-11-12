extends Control

@onready var inventory: ItemContainer = $Inventory

func _input(event: InputEvent) -> void:
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_X:
				var logItem = preload("res://src/items/Log.tscn").instantiate() as Item
				inventory.addItem(logItem)
	
	if event.is_action_pressed("toggle_inventory"):
		inventory.visible = not inventory.visible
		if inventory.visible:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("toggle_options"):
		print("2")
		
