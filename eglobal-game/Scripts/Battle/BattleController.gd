extends Node
class_name BattleController

@onready var level_config: LevelSceneController = $LevelScene
@onready var player = $Player

func _ready():
	spawn_enemy_in_lane(preload("res://Authoring/Enemies/EnemyGoblin.tres"), 0)
	spawn_enemy_in_lane(preload("res://Authoring/Enemies/EnemyOrc.tres"), 1)

func spawn_enemy_in_lane(enemy_data: EnemyData, lane_index: int) -> void:
	if lane_index < 0 or lane_index >= level_config.lanes_config.size():
		push_error("Invalid lane index!")
		return
	
	var lane_info = level_config.lanes_config[lane_index]
	var spawn_position = lane_info["spawn_pos"]
	var target_position = lane_info["target_pos"]
	
	var enemy_scene = preload("res://Scenes/Battle/enemy.tscn")
	var enemy: EnemyController = enemy_scene.instantiate()
	
	enemy.data = enemy_data
	enemy.global_position = spawn_position
	enemy.targetPosition = target_position
	
	add_child(enemy)
