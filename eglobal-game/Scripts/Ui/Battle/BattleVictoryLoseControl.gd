extends Control
class_name BattleVictoryLoseControl

@onready var HeadTextureRect: TextureRect = $MarginContainer/VBoxContainer/HeadControl/HeadTextureRect
@onready var HeadLabel: Label = $MarginContainer/VBoxContainer/HeadControl/HeadTextureRect/HeadLabel
@onready var GlowEffectTextureRect: TextureRect = $MarginContainer/VBoxContainer/EffectControl/BgTextureRect/GlowEffectTextureRect
@onready var FlagTextureRect: TextureRect = $MarginContainer/VBoxContainer/EffectControl/BgTextureRect/FlagTextureRect
@onready var SwordTextureRect: TextureRect = $MarginContainer/VBoxContainer/EffectControl/BgTextureRect/FlagTextureRect/SwordTextureRect
@onready var BattleRewardPanelTextureRect: TextureRect = $MarginContainer/VBoxContainer/BattleRewardControl/BattleRewardPanel
@onready var BubbleFlagTextureRect: TextureRect = $MarginContainer/VBoxContainer/BattleRewardControl/BattleRewardPanel/BubbleFlagTextureRect
@onready var WingLeftTextureRect: TextureRect = $MarginContainer/VBoxContainer/EffectControl/BgTextureRect/WingsControl/WingLeftTextureRect
@onready var WingRightTextureRect: TextureRect = $MarginContainer/VBoxContainer/EffectControl/BgTextureRect/WingsControl/WingRightTextureRect

@export var data: BattleFinalSpritesData
const  victory_test_data: BattleFinalSpritesData = preload("res://Authoring/BattleFinal/VictoryBattleFinal.tres")
const  lose_test_data: BattleFinalSpritesData = preload("res://Authoring/BattleFinal/LoseBattleFinal.tres")

func _ready() -> void:
	if lose_test_data:
		init(lose_test_data)

func _process(delta: float) -> void:
	pass

func init(_BattleFinalSpritesData: BattleFinalSpritesData) -> void:
	HeadTextureRect.texture = _BattleFinalSpritesData.HeadTexture
	HeadLabel.text = _BattleFinalSpritesData.FinalName
	GlowEffectTextureRect.texture = _BattleFinalSpritesData.GlowEffectTexture
	FlagTextureRect.texture = _BattleFinalSpritesData.FlagTexture
	SwordTextureRect.texture = _BattleFinalSpritesData.SwordTexture
	BattleRewardPanelTextureRect.texture = _BattleFinalSpritesData.BattleRewardPanelTexture
	BubbleFlagTextureRect.texture = _BattleFinalSpritesData.BubbleFlagTexture
	if _BattleFinalSpritesData.IsLose:
		WingLeftTextureRect.rotation = -1.17
		print(WingLeftTextureRect.rotation)
		WingRightTextureRect.rotation = 1.17
