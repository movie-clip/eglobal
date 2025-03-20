class_name DebugController extends Control

var properties: Array

@onready var container = $PanelContainer/VBoxContainer

const fps_ms = 16

func _ready() -> void:
	Global.debug = self

func _process(delta: float) -> void:
	pass
	
func add_debug_peroperty(id: String, value, time_in_frames) -> void:
	if properties.has(id):
		var target = container.find_child(id, true, false) as Label
		target.text = id + ": " + str(value)
	else:
		var property = Label.new()
		container.add_child(property)
		property.name = id
		property.text = id + ": " + str(value)
		properties.append(property)
