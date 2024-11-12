extends Control
class_name ItemContainer

# Emits when anything in the Container is modified.
signal changed
#var observers: Array[Object] = []

# Number of rows in the container
@export var rows: int = 0
# Number of columns in the container
@export var columns: int = 0
# 2D-array representing the contents of the container (Empty slots are null)
var contents = []

# Constructor for the Container object
func _ready() -> void:
	for i in rows:
		contents.append([])
		for j in columns:
			contents[i].append(null)
	_update()

# Returns the item at the x (row) and y (column) coordinate of the container.
func getItem(x, y):
	pass

func itemExists(x, y):
	pass

func containsItem(item):
	pass

func addItem(item):
	pass

func setItemAtPosition(item, x, y):
	contents[x][y] = item.duplicate()
	_update()

func _update():
	changed.emit()
