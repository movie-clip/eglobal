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
	

	
#func spawn_enemy_in_lane(enemy_data: EnemyData, lane_index: int) -> void:
	#if lane_index < 0 or lane_index >= level_config.lanes_config.size():
		#push_error("Invalid lane index!")
		#return
	#
	#var lane_info = level_config.lanes_config[lane_index]
	#var spawn_position = lane_info["spawn_pos"]
	#var target_position = lane_info["target_pos"]
	#
	#var enemy_scene = preload("res://Scenes/Battle/enemy.tscn")
	#var enemy: EnemyController = enemy_scene.instantiate()
	#
	#enemy.data = enemy_data
	#enemy.global_position = spawn_position
	#enemy.targetPosition = target_position
	#
	#add_child(enemy)
