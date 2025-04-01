class_name Chest extends IObject

var columns: int = 9
var rows: int = 5
var container: ItemContainer
var containerScreen = preload("res://src/containers/chest/Chest.tscn")

func _init() -> void:
	object_name = "Chest"
	container = ItemContainer.new()
	container.rows = rows
	container.columns = columns

func getContainer() -> ItemContainer:
	return container

func interact():
	if not PlayerState.isInMenu:
		var chestView: ItemContainerController = containerScreen.instantiate()
		PlayerState.showContainer(chestView)
		chestView.setContainer(container)
	print("Interacted with chest")
