extends Control
class_name ItemContainerController

# Data of the container
@export var container: ItemContainer

# Grid view of the items in the container
@export var containerViewer: ContainerViewer
@export var mouseItem: MouseItemController

func _ready() -> void:
	if container != null:
		setContainer(container)

func setContainer(newContainer):
	container = newContainer
	containerViewer.container = container
	for itemSlot in containerViewer.get_children():
		if itemSlot is ItemFrame:
			itemSlot.ItemSlotClicked.connect(_clicked_inventory_slot)
	container.changed.connect(_update)
	_update()

func _update():
	mouseItem._update(container.getOnMouse())
	containerViewer._update()

func enable() -> void:
	toggleInput(self, true)

func disable() -> void:
	toggleInput(self, false)

func toggleInput(node, enabled):
	node.set_process_input(enabled)
	for n in node.get_children():
		toggleInput(n, enabled)

func _clicked_inventory_slot(slotName):
	var slotCoords = slotName.split(",")
	var slotX = int(slotCoords[0])
	var slotY = int(slotCoords[1])
	container.switchMouseItemWithSlot(slotX, slotY)
