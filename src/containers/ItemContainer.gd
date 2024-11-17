extends Node
class_name ItemContainer

# Emits when anything in the Container is modified.
signal changed
#var observers: Array[Object] = []

# Number of rows in the container
@export var rows: int = 0:
	set(value):
		rows = value
		_setup(rows, columns)
# Number of columns in the container
@export var columns: int = 0:
	set(value):
		columns = value
		_setup(rows, columns)
# 2D-array representing the contents of the container (Empty slots are null)
var contents = []
var onMouse: Item = null

func _setup(r, c) -> void:
	contents = []
	for i in r:
		contents.append([])
		for j in c:
			contents[i].append(null)
	_update()

# Returns the item at the x (row) and y (column) coordinate of the container.
func getItem(x, y) -> Item:
	return contents[x][y]

func isItem(x, y):
	return contents[x][y] != null

func containsItem(itemName: String) -> Array:
	for i in rows:
		for j in columns:
			if contents[i][j] != null:
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
			setItemAtPosition(item, emptySpot.x, emptySpot.y)
			_update()
			return true
		else:
			return false

func setItemAtPosition(item, x, y):
	if item == null:
		contents[x][y] = null
	else:
		contents[x][y] = item.duplicate()
	_update()

func getOnMouse() -> Item:
	return onMouse

func isItemOnMouse() -> bool:
	return onMouse != null

func isItemOnMouseAndValue():
	if onMouse != null:
		return [true, onMouse]
	else:
		return [false, null]

func setMouseItem(item):
	onMouse = item

func switchMouseItemWithSlot(x, y):
	if isItemOnMouse() or isItem(x, y):
		if isItemOnMouse() and isItem(x, y):
			if getItem(x, y).itemName == getOnMouse().itemName:
				var ma = getOnMouse().amount
				onMouse = null
				addAmount(x, y, ma)
				_update()
				return

		var mi = onMouse
		onMouse = getItem(x, y)
		setItemAtPosition(mi, x, y)

func _update():
	changed.emit()
