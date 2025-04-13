extends Node2D
class_name LevelSceneController

@export var level_container: Node2D
@export var lanes_node_path: NodePath = "Lanes"
@export var player_spawn_path: NodePath = "PlayerSpawn"

var lanes_config: Array = []
var player_spawn_position: Vector2 = Vector2.ZERO

var current_level: Node2D = null

func _ready():
	var config = preload("res://Authoring/Levels/Level1Config.tres")
	load_level(config)

func load_level(config: LevelConfiguration):
	if current_level:
		current_level.queue_free()
		current_level = null
		
	current_level = config.level_scene.instantiate()
	level_container.add_child(current_level)
	_collect_level_configuration()


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
	
func _collect_level_configuration():
	var lanes_node = current_level.get_node_or_null(lanes_node_path)
	lanes_config.clear()
	for lane in lanes_node.get_children():
		var lane_y = lane.global_position.y
		var spawner_marker = lane.get_node("EnemySpawnerMarker")
		var spawn_pos = spawner_marker.global_position
		lanes_config.append({ "lane_y": lane_y, "spawn_pos": spawn_pos, "target_pos": player_spawn_position })
	
	var player_spawn = current_level.get_node(player_spawn_path)
	player_spawn_position = player_spawn.global_position
	
