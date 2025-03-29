extends Control
class_name InventorySlotUI

@export var texture: TextureRect
@export var empty_texture: Texture2D

func set_slot_item(item: InventoryItem, is_origin: bool) -> void:
	if item == null or not is_origin:
		texture.texture = empty_texture
	else:
		texture.texture = item.texture # or item.icon if you have icons in InventoryItem
