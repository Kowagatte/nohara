extends TextureRect
class_name ItemFrame

@onready var count: Label = $Count
@onready var content: TextureRect = $Content

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
