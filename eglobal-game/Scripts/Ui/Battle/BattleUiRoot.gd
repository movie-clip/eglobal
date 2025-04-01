extends Control

@onready var BattleButton = $MarginContainer/VBoxContainer/TextureRect/BattleButton
@onready var LevelProgressBar: ProgressBar = $MarginContainer/VBoxContainer/LevelProgressPanel/HBoxContainer/LevelProgressBar
@onready var PlayerHpPanelText: RichTextLabel = $MarginContainer/VBoxContainer/AllStatsPanel/AllStatsHBoxContainer/HealthStatPanel/RichTextLabel
@onready var PlayerHpProgressBar: TextureProgressBar = $MarginContainer/VBoxContainer/AllStatsPanel/AllStatsHBoxContainer/HealthStatPanel/TextureProgressBar
@onready var PlayerHpTexture: TextureRect = $MarginContainer/VBoxContainer/AllStatsPanel/AllStatsHBoxContainer/HealthStatPanel/TextureRect
@onready var PlayerExpPanelText: RichTextLabel = $MarginContainer/VBoxContainer/AllStatsPanel/AllStatsHBoxContainer/ExpStatPanel/RichTextLabel
@onready var PlayerExpProgressBar: TextureProgressBar = $MarginContainer/VBoxContainer/AllStatsPanel/AllStatsHBoxContainer/ExpStatPanel/TextureProgressBar
@onready var PlayerExpTexture: TextureRect = $MarginContainer/VBoxContainer/AllStatsPanel/AllStatsHBoxContainer/ExpStatPanel/TextureRect

func _ready() -> void:
	LevelProgressBar.value = 0
	PlayerHpProgressBar.max_value = Global.player.get_max_hp()
	PlayerHpProgressBar.value = Global.player.get_current_hp()
	PlayerExpProgressBar.max_value = Global.player.get_exp_for_next_level()
	PlayerExpProgressBar.value = Global.player.get_current_exp()
	change_text(PlayerHpPanelText, "[center][b]" + str(Global.player.get_current_hp()) + " / " + str(Global.player.get_max_hp()))
	change_text(PlayerExpPanelText, "[center][b]" + "Level " + str(Global.player.get_current_level()))
	SignalBus.level_stage_complited.connect(change_progress)
	SignalBus.player_hp_changed.connect(change_hp_view)
	SignalBus.player_exp_changed.connect(change_exp_view)
	SignalBus.player_level_changed.connect(change_lvl_view)
	SignalBus.player_exp_for_next_level_changed.connect(change_exp_next_lvl_view)

func _process(delta: float) -> void:
	pass

func change_progress() -> void:
	LevelProgressBar.value += 1

func change_exp_next_lvl_view(_Value: int) -> void:
	PlayerExpProgressBar.max_value = _Value

func change_exp_view(_Value: int) -> void:
	slider_change_animation(PlayerExpProgressBar, _Value, PlayerExpTexture)

func change_lvl_view(_Value: int) -> void:
	change_text(PlayerExpPanelText, "[center][b]" + "Level " + str(_Value))

func change_hp_view(_Value: int) -> void:
	change_text(PlayerHpPanelText, "[center][b]" + str(Global.player.get_current_hp()) + "/" + str(Global.player.get_max_hp()))
	slider_change_animation(PlayerHpProgressBar, PlayerHpProgressBar.value + _Value, PlayerHpTexture)

func slider_change_animation(_Slider: TextureProgressBar, _Value: int, _Texture: TextureRect) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(_Slider, "value", _Value, 0.2)
	tween.tween_property(_Texture, "scale", Vector2(1.2, 1.2), 0.2)
	tween.chain().tween_property(_Texture, "scale", Vector2(1, 1), 0.1)

func change_text(_TextLabel: RichTextLabel, _Text: String) -> void:
	_TextLabel.text = _Text
