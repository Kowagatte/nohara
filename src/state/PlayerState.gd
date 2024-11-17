extends Node

var inventory: ItemContainer
var isInMenu: bool = false

func _init() -> void:
	inventory = ItemContainer.new()
	inventory.rows = 6
	inventory.columns = 9

func getInventory() -> ItemContainer:
	return inventory

func setInMenu(flag):
	isInMenu = flag
	
func toggleInMenu():
	isInMenu = not isInMenu

func getInMenu() -> bool:
	return isInMenu
