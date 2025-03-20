extends Node

func _ready() -> void:
	await get_tree().create_timer(0.3).timeout
	Global.game_controller.change_gui_scene(Util.SCENES.META, true)
