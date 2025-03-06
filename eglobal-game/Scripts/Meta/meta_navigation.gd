extends Node

@onready var start_btn: Button = $start_btn

func _ready() -> void:
	start_btn.connect("pressed", Callable(self, "_on_StartBattle_pressed"))

func _on_StartBattle_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Loading.tscn")
	
func _process(delta: float) -> void:
	pass
