extends Button

func _ready() -> void:
	self.pressed.connect(self.on_click)

func _process(delta: float) -> void:
	pass

func on_click():
	var tween = get_tree().create_tween()
	#tween.tween_property(self, "modulate", Color.RED, 1)
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.3)
	tween.chain().tween_property(self, "scale", Vector2(1, 1), 0.3)
	#tween.tween_callback(self.queue_free)
	Global.on_battla_button_clicked()
	Global.on_level_stage_complited()
	var Damage: int = randi_range(-100, -300)
	var Exp: int = randi_range(10, 600)
	Global.playerService.change_player_hp(Damage) #on_player_hp_changed(Damage)
	Global.playerService.change_player_exp(Exp) #on_player_exp_changed(Exp)
