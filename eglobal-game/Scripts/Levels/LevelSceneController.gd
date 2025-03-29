extends Node2D
class_name LevelSceneController

@export var lanes_node_path: NodePath = "Lanes"
@export var player_spawn_path: NodePath = "PlayerSpawn"

var lanes_config: Array = []
var player_spawn_position: Vector2 = Vector2.ZERO

func _ready():
	_collect_level_configuration()

func _collect_level_configuration():
	var lanes_node = get_node(lanes_node_path)
	lanes_config.clear()
	for lane in lanes_node.get_children():
		var lane_y = lane.global_position.y
		var spawner_marker = lane.get_node("EnemySpawnerMarker")
		var spawn_pos = spawner_marker.global_position
		lanes_config.append({ "lane_y": lane_y, "spawn_pos": spawn_pos, "target_pos": player_spawn_position })
	
	var player_spawn = get_node(player_spawn_path)
	player_spawn_position = player_spawn.global_position
	