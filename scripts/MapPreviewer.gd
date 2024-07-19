extends Node

var NumberRegEx = RegEx.new()
@onready var panel = get_parent()

func _ready():
	NumberRegEx.compile("^[0-9.]*$")
	$Seed.text_submitted.connect(_seed_changed)
	$Frequency.text_changed.connect(_frequency_changed)
	$Octaves.text_changed.connect(_octaves_changed)
	$Lacunarity.text_changed.connect(_lacunarity_changed)
	$Gain.text_changed.connect(_gain_changed)
	$Save.pressed.connect(_download)

func _seed_changed(seed):
	var hash = int(seed)
	if seed != "0":
		if hash == 0:
			hash = seed.hash()
	print("Changed seed to ", hash)
	panel.change_seed(hash)

func ensure_numbers(node: LineEdit, new_text):
	var old_text = node.placeholder_text
	if NumberRegEx.search(new_text):
		old_text = str(new_text)
		return true
	else:
		node.text = old_text
		node.caret_column = node.text.length()
		return false

func ensure_nonempty(node: LineEdit, text):
	var value = float(node.placeholder_text)
	if text != "":
		value = float(text)
	return value

func _frequency_changed(frequency):
	if ensure_numbers($Frequency, frequency):
		panel.change_frequency(ensure_nonempty($Frequency, frequency))

func _octaves_changed(octaves):
	if ensure_numbers($Octaves, octaves):
		panel.change_octaves(ensure_nonempty($Octaves, octaves))

func _lacunarity_changed(lacunarity):
	if ensure_numbers($Lacunarity, lacunarity):
		panel.change_lacunarity(ensure_nonempty($Lacunarity, lacunarity))

func _gain_changed(gain):
	if ensure_numbers($Gain, gain):
		panel.change_gain(ensure_nonempty($Gain, gain))

func _download():
	var texture = panel.find_child("TextureRect") as TextureRect
	var noiseTexture = texture.texture as NoiseTexture2D
	ResourceSaver.save(noiseTexture, "res://assets/newNoise.tres")
	
