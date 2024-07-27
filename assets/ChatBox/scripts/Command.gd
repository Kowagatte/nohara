extends Node
class_name Command


enum Commands { HELP = 0, }
static var commands = {
	"help": {
		"aliases": ['h'],
		"com": Commands.HELP
	},
}

var content: String

func _init(_content):
	self.content = _content

func get_command():
	return null

func call_command():
	pass
