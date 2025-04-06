extends Node

var isTyping: bool = false
var containerView: Control
var inventory: ItemContainer
var isInMenu: bool = false

func setContainerView(control):
	containerView = control

func showContainer(containerController):
	containerView.add_child(containerController)
	setInMenu(true)

func hideContainer():
	containerView.get_child(0).queue_free()
	setInMenu(false)

func _init() -> void:
	inventory = ItemContainer.new()
	inventory.rows = 5
	inventory.columns = 9

func getInventory() -> ItemContainer:
	return inventory

func setInMenu(flag):
	if flag:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	isInMenu = flag
	
func toggleInMenu():
	isInMenu = not isInMenu

func getInMenu() -> bool:
	return isInMenu
