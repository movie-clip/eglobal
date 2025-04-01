extends Node

var max_hp: int = 3000
var current_hp: int = 3000
var current_level: int = 1
var current_exp: int = 0
var exp_for_next_level: int = 100
var levels = [0, 100, 200, 300, 400, 600, 800, 1000, 10000]

func on_battla_button_clicked() -> void:
	SignalBus.battle_button_clicked.emit()

func on_level_stage_complited() -> void:
	SignalBus.level_stage_complited.emit()

func on_player_hp_changed(Value: int):
	current_hp += Value
	SignalBus.player_hp_changed.emit(Value)

func on_player_exp_changed(Value: int):
	current_exp += Value
	while (current_exp >= exp_for_next_level):
		current_exp -= exp_for_next_level
		current_level += 1
		if (levels.size() > current_level):
			exp_for_next_level = levels[current_level]
	on_player_exp_for_next_level_changed(exp_for_next_level)
	on_player_level_changed(current_level)
	SignalBus.player_exp_changed.emit(current_exp)

func on_player_level_changed(Value: int):
	SignalBus.player_level_changed.emit(Value)

func on_player_exp_for_next_level_changed(Value: int):
	SignalBus.player_exp_for_next_level_changed.emit(Value)

func get_max_hp():
	return max_hp

func get_current_hp():
	return current_hp

func get_current_level():
	return current_level

func get_current_exp():
	return current_exp

func get_exp_for_next_level():
	return exp_for_next_level
