extends Control
class_name InventorySlotUI

@export var texture: TextureRect
@export var empty_texture: Texture2D
@export var extra_texture: Texture2D
var area: Area2D
var inventory_slot: InventorySlot
var slot_pos: Vector2

func set_slot(Slot: InventorySlot):
	update_slot(Slot)
	self.gui_input.connect(on_slot_click)
	self.mouse_entered.connect(on_slot_hover)
	self.mouse_exited.connect(on_out_of_slot)
	area = get_child(1)

func update_slot(Slot: InventorySlot):
	inventory_slot = Slot
	if Slot.is_locked:
		texture.texture = null
	elif Slot.is_extra:
		texture.texture = extra_texture
	else:
		texture.texture = empty_texture

func on_slot_hover():
	SignalBus.hover_item_on_slot.emit(self)

func on_slot_click(Event: InputEvent):
	if Event.is_pressed():
		SignalBus.select_slot_for_item.emit(self)

func on_out_of_slot():
	SignalBus.out_item_of_slot.emit(self)
