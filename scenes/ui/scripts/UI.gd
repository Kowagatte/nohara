extends Control

@onready var inventory: ItemContainer = PlayerState.getInventory()
@onready var inventoryControl: ItemContainerController = $Inventory
@onready var containerView: Control = $ContainerView
@onready var chat: VBoxContainer = $Chat

func _ready() -> void:
	inventoryControl.setContainer(inventory)
	PlayerState.setContainerView(containerView)

func _input(event: InputEvent) -> void:
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_X:
				var logItem = preload("res://src/items/Log.tscn").instantiate() as Item
				inventory.addItem(logItem)
	
	
	if not PlayerState.isTyping:
		if event.is_action_pressed("toggle_chat"):
			setTyping(true)
		elif event.is_action_pressed("toggle_inventory"):
			if containerView.get_child_count() > 0:
				PlayerState.hideContainer()
			else:
				inventoryControl.visible = not inventoryControl.visible
				PlayerState.setInMenu(inventoryControl.visible)
		elif event.is_action_pressed("toggle_options"):
			print("Clicked toggle_options")
	else:
		if event.is_action_pressed("toggle_options"):
			setTyping(false)
		

func setTyping(isTyping):
	chat.visible = isTyping
	PlayerState.setInMenu(isTyping)
	PlayerState.isTyping = isTyping
	if isTyping:
		chat.reset()
