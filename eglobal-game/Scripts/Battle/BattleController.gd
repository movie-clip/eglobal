extends Node2D
class_name BattleController

@onready var player = $Player
@onready var gui_container: CanvasLayer = $CanvasLayer

var level_controller: LevelSceneController

func _ready():
	level_controller = LevelSceneController.new()
	Global.playerService.create_player()

func load_level(levelID: int):
	var level_config = Global.levelDataProvider.get_level_config(levelID)
	level_controller.load_level(level_config)
	pass
