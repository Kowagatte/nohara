extends Control

@onready var data: ItemContainer = $data

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_X:
				var logItem = preload("res://src/items/Log.tscn").instantiate() as Item
				data.addItem(logItem)
