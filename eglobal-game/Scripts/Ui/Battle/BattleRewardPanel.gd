extends TextureRect
class_name BattleRewardPanel

const  item_scene = preload("res://Scenes/RewardItemControl.tscn")
@onready var container: GridContainer = $HBoxContainer/GridContainer

func _ready() -> void:
	create_reward_item(preload("res://Authoring/BattleRewards/Item_1.tres"))
	create_reward_item(preload("res://Authoring/BattleRewards/Item_2.tres"))
	create_reward_item(preload("res://Authoring/BattleRewards/Item_3.tres"))

func _process(delta: float) -> void:
	pass

func create_reward_item(_RewardItemData: RewardItemData) -> void:
	var item = item_scene.instantiate()
	item.data = _RewardItemData
	container.add_child(item)
