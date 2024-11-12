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
	return contents[x][y]

func containsItem(itemName: String) -> Array:
	for i in rows:
		for j in columns:
			if contents[i][j].itemName == itemName:
				return [true, Vector2(i, j)]
	return [false, null]

func getFirstEmpty():
	for i in rows:
		for j in columns:
			if contents[i][j] == null:
				return Vector2(i,j)
	return null

func setAmount(x, y, amount):
	(contents[x][y] as Item).amount = amount
	_update()

func addAmount(x, y, amount):
	(contents[x][y] as Item).amount += amount
	_update()

func removeAmount(x, y, amount):
	(contents[x][y] as Item).amount -= amount
	_update()

func addItem(item: Item) -> bool:
	var contains = containsItem(item.itemName)
	if contains[0]:
		addAmount(contains[1].x, contains[1].y, item.amount)
		_update()
		return true
	else:
		var emptySpot = getFirstEmpty()
		if emptySpot != null:
			setItemAtPosition(emptySpot.x, emptySpot.y, item)
			_update()
			return true
		else:
			return false

func setItemAtPosition(item, x, y):
	contents[x][y] = item.duplicate()
	_update()

func _update():
	changed.emit()
