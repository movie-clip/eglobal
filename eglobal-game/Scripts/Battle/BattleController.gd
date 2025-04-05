extends Node
class_name BattleController

@onready var level_config: LevelSceneController = $LevelScene
@onready var player = $Player
@onready var gui_container: CanvasLayer = $CanvasLayer

func _ready():
	spawn_enemy_in_lane(preload("res://Authoring/Enemies/EnemyGoblin.tres"), 0)
	spawn_enemy_in_lane(preload("res://Authoring/Enemies/EnemyOrc.tres"), 1)
	init_battle_ui()
	SignalBus.level_complited.connect(open_reward_panel)

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

func init_battle_ui() -> void:
	var battle_ui_root_scene = preload("res://Scenes/BattleUiRoot.tscn")
	var battle_ui_root = battle_ui_root_scene.instantiate()
	gui_container.add_child(battle_ui_root)

func open_reward_panel(Value: bool) -> void:
	var reward_panel_scane = preload("res://Scenes/BattleVictoryRoot.tscn")
	var reward_panel:BattleVictoryLoseControl = reward_panel_scane.instantiate()
	if Value == true:
		var victory_test_data: BattleFinalSpritesData = preload("res://Authoring/BattleFinal/VictoryBattleFinal.tres")
		reward_panel.data = victory_test_data
	else:
		var lose_test_data: BattleFinalSpritesData = preload("res://Authoring/BattleFinal/LoseBattleFinal.tres")
		reward_panel.data = lose_test_data
	gui_container.add_child(reward_panel)
