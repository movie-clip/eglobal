extends Control
class_name RewardItemControl
@export var data: RewardItemData

@onready var ItemTextureRect: TextureRect = $BorderTextureRect/ItemTextureRect
@onready var BorderTextureRect: TextureRect = $BorderTextureRect
@onready var ItemCountText: Label = $ItemCountTextLabel

func _ready() -> void:
	if data:
		ItemTextureRect.texture = data.ItemTexture
		BorderTextureRect.texture = data.BorderTexture
		if data.ItemCount > 0:
			ItemCountText.text = str(data.ItemCount)
		else:
			ItemCountText.text = ""

func _process(delta: float) -> void:
	pass
