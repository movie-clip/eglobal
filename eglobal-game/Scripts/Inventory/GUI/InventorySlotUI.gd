extends Control
class_name InventorySlotUI

@export var texture: TextureRect
@export var empty_texture: Texture2D
@export var extra_texture: Texture2D

@onready var slot_area: Area2D = $SlotArea2D

var inventory_slot: InventorySlot
var slot_pos: Vector2

func set_slot_item(item: InventoryItem, is_origin: bool) -> void:
	if item == null or not is_origin:
		texture.texture = empty_texture
	else:
		texture.texture = item.texture # or item.icon if you have icons in InventoryItem

func set_slot(slot: InventorySlot) -> void:
	inventory_slot = slot
	if slot.is_locked:
		texture.texture = null
	elif slot.is_extra:
		texture.texture = extra_texture
	else:
		texture.texture = empty_texture
	self.gui_input.connect(on_slot_hover.bind(self))

func on_slot_hover(Event: InputEvent, ControlItem: Control):
	if Event.is_pressed():
		SignalBus.select_slot_for_item.emit(self)
	else:
		SignalBus.hover_item_on_slot.emit(self)
