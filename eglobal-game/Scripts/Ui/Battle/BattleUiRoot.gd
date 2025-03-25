extends Control
@onready var BattleButton = $MarginContainer/VBoxContainer/AllStatsPanel/BattleButton
@onready var LevelProgressBar: ProgressBar = $MarginContainer/VBoxContainer/LevelProgressPanel/HBoxContainer/LevelProgressBar
@onready var PlayerHpPanelText: RichTextLabel = $MarginContainer/VBoxContainer/AllStatsPanel/AllStatsHBoxContainer/HealthStatPanel/RichTextLabel
@onready var PlayerHpProgressBar: ProgressBar = $MarginContainer/VBoxContainer/AllStatsPanel/AllStatsHBoxContainer/HealthStatPanel/ProgressBar
@onready var PlayerHpTexture: TextureRect = $MarginContainer/VBoxContainer/AllStatsPanel/AllStatsHBoxContainer/HealthStatPanel/TextureRect
@onready var PlayerExpPanelText: RichTextLabel = $MarginContainer/VBoxContainer/AllStatsPanel/AllStatsHBoxContainer/ExpStatPanel/RichTextLabel
@onready var PlayerExpProgressBar: ProgressBar = $MarginContainer/VBoxContainer/AllStatsPanel/AllStatsHBoxContainer/ExpStatPanel/ProgressBar
@onready var PlayerExpTexture: TextureRect = $MarginContainer/VBoxContainer/AllStatsPanel/AllStatsHBoxContainer/ExpStatPanel/TextureRect


func _ready() -> void:
	LevelProgressBar.value = 0
	PlayerHpProgressBar.max_value = Global.GetMaxPlayerHp()
	PlayerHpProgressBar.value = Global.GetCurrentPlayerHp()
	PlayerExpProgressBar.max_value = Global.GetExpForNextLvl()
	PlayerExpProgressBar.value = Global.GetCurrentPlayerExp()
	change_text(PlayerHpPanelText, "[center][b]" + str(Global.GetCurrentPlayerHp()) + " / " + str(Global.GetMaxPlayerHp()))
	change_text(PlayerExpPanelText, "[center][b]" + "Level " + str(Global.GetCurrentPlayerLvl()))
	Events.OnCompliteLevelStage.connect(change_progress)
	Events.OnPlayerHpChanged.connect(change_hp_view)
	Events.OnPlayerExpChanged.connect(change_exp_view)
	Events.OnPlayerLvlChanged.connect(change_lvl_view)

func _process(delta: float) -> void:
	pass

func change_progress() -> void:
	LevelProgressBar.value += 1

func change_exp_view(_Value: int) -> void:
	slider_change_animation(PlayerExpProgressBar, PlayerExpProgressBar.value + _Value, PlayerExpTexture)

func change_lvl_view(_Value: int) -> void:
	change_text(PlayerExpPanelText, "[center][b]" + "Level " + str(Global.GetCurrentPlayerLvl()))

func change_hp_view(_Value: int) -> void:
	change_text(PlayerHpPanelText, "[center][b]" + str(Global.GetCurrentPlayerHp()) + " / " + str(Global.GetMaxPlayerHp()))
	slider_change_animation(PlayerHpProgressBar, PlayerHpProgressBar.value + _Value, PlayerHpTexture)

func  slider_change_animation(_Slider: ProgressBar, _Value: int, _Texture: TextureRect) -> void:
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(_Slider, "value", _Value, 0.2)
	tween.tween_property(_Texture, "scale", Vector2(1.2, 1.2), 0.2)
	tween.chain().tween_property(_Texture, "scale", Vector2(1, 1), 0.1)

func change_text(_TextLabel: RichTextLabel, _Text: String) -> void:
	_TextLabel.text = _Text
