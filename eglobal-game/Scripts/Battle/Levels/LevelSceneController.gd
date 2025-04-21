extends Node2D
class_name LevelSceneController

@export var level_container: Node2D

var current_level_scene: LevelController
var current_level_config: LevelConfiguration

func _ready():
	pass

func load_level(config: LevelConfiguration):
	if current_level_scene:
		current_level_scene.queue_free()
		current_level_scene = null
		current_level_config = null
	
	current_level_config = config
	current_level_scene = config.level_scene.instantiate()
	level_container.add_child(current_level_scene)

func load_stage(config: StageConfiguration):
	current_level_scene.load_stage(config)

func start_level():
	if !current_level_scene:
		return
	current_level_scene.activate_enemy_spawner()

func next_stage():
	current_level_scene.load_stage(current_level_config.stages[0])
