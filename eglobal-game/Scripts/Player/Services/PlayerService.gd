extends Node
class_name PlayerService

var player: PlayerModel

func create_player():
	player = PlayerModel.new()

func change_player_exp(Value: int):
	player.current_exp += Value
	var hasLevelChanged: bool = false
	while (player.current_exp >= player.exp_for_next_level):
		player.current_exp -= player.exp_for_next_level
		player.current_level += 1
		hasLevelChanged = true
		if (player.levels.size() > player.current_level):
			player.exp_for_next_level = player.levels[player.current_level]
	
	on_player_exp_changed(player.exp_for_next_level)
	if hasLevelChanged:
		on_player_level_changed(player.current_level)
	SignalBus.player_exp_changed.emit(player.current_exp)

func on_player_level_changed(Value: int):
	SignalBus.player_level_changed.emit(Value)
	
func on_player_exp_changed(Value: int):
	SignalBus.player_exp_for_next_level_changed.emit(Value)
	
func change_player_hp(Value: int):
	player.current_hp += Value
	if player.current_hp <= 0:
		player.current_hp = 0
		on_player_died(false)
	SignalBus.player_hp_changed.emit(Value)

func on_player_died(Value: bool):
	SignalBus.player_died.emit(Value)


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
