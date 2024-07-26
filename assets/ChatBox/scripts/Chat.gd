extends Label
class_name Chat

var time: float
var playerName: String = "Player"
var content: String

func _init(_content):
	self.time = Time.get_unix_time_from_system()
	self.content = _content
	self.text = format()

func getLocalTime():
	var dateTime = Time.get_datetime_string_from_unix_time(time)
	return dateTime

func format():
	return "<"+playerName+"> " + content
