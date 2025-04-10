extends Node
class_name InventoryFreeSlot

@export var texture: TextureRect
@export var empty_texture: AtlasTexture
@export var extra_texture: Texture2D

func set_free_slot(is_free: bool, is_extra: bool) -> void:
	if is_free:
		#var region = Rect2(Vector2(768, 176), Vector2(160, 164))  # Specify the x, y, width, and height
		#empty_texture.region = region
		if  is_extra:
			texture.texture = extra_texture
		else:
			texture.texture = empty_texture
	else :
		texture.texture = null
