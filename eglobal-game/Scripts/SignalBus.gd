extends Node

signal entity_spawned()

signal battle_button_clicked()
signal level_stage_complited()
signal level_complited(Value: bool)
signal player_hp_changed(Value:int)
signal player_exp_changed(Value:int)
signal player_exp_for_next_level_changed(Value:int)
signal player_level_changed(Value:int)
signal player_attack_changed(Value:int)
signal player_defence_changed(Value:int)
signal player_move_finished(PlayerPos: Vector2)

signal player_died()