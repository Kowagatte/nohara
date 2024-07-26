extends Control

@onready var chatContainer: VBoxContainer = $Container/VBoxContainer
@onready var input: LineEdit = $LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	input.text_submitted.connect(Callable(self, "insertChat"))

func insertChat(text):
	var chat = Chat.new(text)
	chatContainer.add_child(chat)
	input.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
