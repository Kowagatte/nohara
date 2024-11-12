extends Control

@onready var inventory: ItemContainer = $".."

var count = 0

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_A:
			var log = preload("res://src/items/Log.tscn").instantiate() as Item
			inventory.setItemAtPosition(log, 0, count)
			count += 1
			#inventory.addItemAtPosition()
