extends VBoxContainer

@onready var input: LineEdit = $input
@onready var history: VBoxContainer = $ScrollContainer/history
@onready var scroll_container: ScrollContainer = $ScrollContainer

func _ready() -> void:
	input.text_submitted.connect(Callable(self, "push"))
	
func reset():
	input.grab_focus()
	await get_tree().process_frame
	input.text = ""
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value

func push(message):
	if message != "":
		var label = Label.new()
		label.text = message
		history.add_child(label)
		reset()
