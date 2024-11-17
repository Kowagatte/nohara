extends Control

@onready var inventory: ItemContainer = PlayerState.getInventory()
@onready var inventoryControl: Control = $Inventory


func _ready() -> void:
	$"Inventory/Panel/VBoxContainer/MarginContainer2/ContainerViewer".setContainer(inventory)

func _input(event: InputEvent) -> void:
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_X:
				var logItem = preload("res://src/items/Log.tscn").instantiate() as Item
				inventory.addItem(logItem)
	
	if event.is_action_pressed("toggle_inventory"):
		inventoryControl.visible = not inventoryControl.visible
		if inventoryControl.visible:
			PlayerState.setInMenu(true)
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			PlayerState.setInMenu(false)
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("toggle_options"):
		print("2")
		
