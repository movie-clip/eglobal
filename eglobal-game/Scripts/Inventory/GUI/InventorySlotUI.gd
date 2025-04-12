extends Control
class_name InventorySlotUI

@export var texture: TextureRect
@export var empty_texture: Texture2D
@export var extra_texture: Texture2D
@onready var slot_area: Area2D = $SlotArea2D
var inventory_slot: InventorySlot
var slot_pos: Vector2

#func set_slot_item(item: InventoryItem, is_origin: bool):
	#if item == null or not is_origin:
		#texture.texture = empty_texture
	#else:
		#texture.texture = item.texture # or item.icon if you have icons in InventoryItem

func set_slot(Slot: InventorySlot):
	update_slot(Slot)
	self.gui_input.connect(on_slot_hover)

func update_slot(Slot: InventorySlot):
	inventory_slot = Slot
	if Slot.is_locked:
		texture.texture = null
	elif Slot.is_extra:
		texture.texture = extra_texture
	else:
		texture.texture = empty_texture

func on_slot_hover(Event: InputEvent):
	if Event.is_pressed():
		SignalBus.select_slot_for_item.emit(self)
	else:
		SignalBus.hover_item_on_slot.emit(self)
