extends Node2D
class_name LevelController

@export var stage_container: Node2D

var current_stage_scene: StageController
var current_stage_config: StageConfiguration

func load_stage(config: StageConfiguration):
	if current_stage_scene:
		current_stage_scene.queue_free()
		current_stage_scene = null
		current_stage_config = null
	
	current_stage_config = config
	current_stage_scene = config.stage_scene.instantiate()
	stage_container.add_child(current_stage_scene)

func activate_enemy_spawner():
	if !current_stage_scene:
		return
	
	var spawner = current_stage_config.spawners[0]
	var wave = spawner.get_wave(0)
	for enemy in wave.enemies:
		spawn_enemy_in_lane(enemy, wave.laneIndex)
	
	
func spawn_enemy_in_lane(enemy_data: EnemyConfiguration, lane_index: int) -> void:
	
	var spawn_position = current_stage_scene.get_spawn_position(lane_index)

	var enemy_scene = preload("res://Scenes/Battle/enemy.tscn")
	var enemy: EnemyController = enemy_scene.instantiate()
	enemy.data = enemy_data
	enemy.attack_target_x = 400.0
	enemy.global_position = spawn_position
	
	add_child(enemy)
	
