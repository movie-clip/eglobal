extends Node

var game_controller: GameController
var debug: DebugController

var player: PlayerModel

func _ready() -> void:
	player = PlayerModel.new()

func on_battla_button_clicked() -> void:
	SignalBus.battle_button_clicked.emit()

func on_level_stage_complited() -> void:
	SignalBus.level_stage_complited.emit()

func on_player_hp_changed(Value: int):
	player.current_hp += Value
	if player.current_hp <= 0:
		player.current_hp = 0
		on_level_complited(false)
	SignalBus.player_hp_changed.emit(Value)

func on_level_complited(Value: bool):
	SignalBus.level_complited.emit(Value)

func on_player_exp_changed(Value: int):
	player.current_exp += Value
	var is_level_changed: bool = false
	while (player.current_exp >= player.exp_for_next_level):
		player.current_exp -= player.exp_for_next_level
		player.current_level += 1
		is_level_changed = true
		if (player.levels.size() > player.current_level):
			player.exp_for_next_level = player.levels[player.current_level]
	on_player_exp_for_next_level_changed(player.exp_for_next_level)
	if is_level_changed == true:
		if player.current_level >= 6:
			on_level_complited(true)
		on_player_level_changed(player.current_level)
	SignalBus.player_exp_changed.emit(player.current_exp)

func on_player_level_changed(Value: int):
	SignalBus.player_level_changed.emit(Value)

func on_player_exp_for_next_level_changed(Value: int):
	SignalBus.player_exp_for_next_level_changed.emit(Value)

func get_max_hp():
	return player.max_hp

func get_current_hp():
	return player.current_hp

func get_current_level():
	return player.current_level

func get_current_exp():
	return player.current_exp

func get_exp_for_next_level():
	return player.exp_for_next_level
