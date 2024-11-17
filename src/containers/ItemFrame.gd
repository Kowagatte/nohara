extends TextureRect
class_name ItemFrame

signal ItemSlotClicked(itemSlotName)

@onready var count: Label = $Count
@onready var content: TextureRect = $Content
var mouseHovering: bool = false

func _ready() -> void:
	mouse_entered.connect(func(): mouseHovering = true)
	mouse_exited.connect(func(): mouseHovering = false)

func _input(event: InputEvent) -> void:
	if mouseHovering:
		if event is InputEventMouseButton and event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT:
				ItemSlotClicked.emit(name)

func setContent(image):
	if image == null:
		content.texture = null
	else:
		content.texture = image.texture

func setAmount(amount: int):
	if amount == 0:
		count.text = ""
	else:
		count.text = "%d" % amount
