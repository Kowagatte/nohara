extends Control

@onready var display: TextureRect = $TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	var _size = Vector2(256, 256)
	var poisson = Poisson.new(1337, false, 15, _size, Vector2(128, 128))
	var img = poisson.getImage() as Image
	display.texture = ImageTexture.create_from_image(img)
	#print(poisson.data)
	#print(img.get_pixel(128, 128))
