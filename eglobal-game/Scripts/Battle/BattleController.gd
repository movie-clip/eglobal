extends Node2D
class_name BattleController

@export var level_controller: LevelSceneController

func _ready():
	load_level(0)
	await get_tree().create_timer(1.0).timeout
	level_controller.create_player()
	level_controller.start_level()

func load_level(levelID: int):
	var level_config = Global.levelDataProvider.get_level_config(levelID)
	level_controller.load_level(level_config)
	level_controller.load_stage(level_config.stages[0])
