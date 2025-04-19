extends Node

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	Global.game_controller.mock_player_data()
	Global.game_controller.change_2d_scene(Util.WORLD_SCENES.BATTLE)
	Global.game_controller.change_gui_scene(Util.GUI_SCENES.BATTLE, true)
