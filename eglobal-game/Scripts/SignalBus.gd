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

signal unlock_extra_slot()
signal select_slot_for_item(SlotControl: Control)
signal select_item(ItemControl: Control)
signal change_item_position(ItemControl: Control)
signal hover_item_on_slot(SlotControl: Control)
signal hover_item_on_item(SlotControl: Control)
signal remove_iten_in_stash(ItemControl: Control)
signal item_entered_in_slot(SlotPos: Vector2)
signal out_item_of_slot(SlotControl: Control)
signal to_free_inventory_slots()
