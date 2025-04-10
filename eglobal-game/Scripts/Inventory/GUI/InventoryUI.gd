extends Control
class_name InventoryUI

@export var slot_scene: PackedScene = preload("res://Scenes/Inventory/inventory_slot_ui.tscn")
const free_slot_scene = preload("res://Scenes/Inventory/inventory_free_slot.tscn")

@onready var grid_container: GridContainer = $GridContainer
@onready var free_slots_grid_container: GridContainer = $FreeSlotsGridContainer

var data: InventoryData

func _ready():
	await get_tree().process_frame  # Ensure inventory is ready

func updateView():
	updateInventory(data)

func updateInventory(data: InventoryData):
	if data == null:
		push_error("Inventory or InventoryData not assigned.")
		return
	self.data = data
	#updateInventoryFreeSlots(data)
	grid_container.columns = data.grid_width

	for child in grid_container.get_children():
		child.queue_free()

	var screen_size = get_viewport_rect().size
	var cols = data.grid_width
	var rows = data.grid_height
	var slot_width = screen_size.x / cols
	var slot_height = screen_size.y / rows
	#var slot_size = Vector2(slot_width, slot_height)
	var slot_size = Vector2(38, 38)
	
	if data.grid_extra > 0:
		for y in range(data.grid_height + 1):
			for x in range(data.grid_width):
				var slot = slot_scene.instantiate() as InventorySlotUI
				slot.custom_minimum_size = slot_size
				var slot_data = data.grid[y][x]
				var item = slot_data.item
				var is_origin = slot_data.is_origin
				#slot.set_slot_item(item, is_origin)
				slot.set_slot(slot_data)
				grid_container.add_child(slot)
	else:
		for y in range(data.grid_height):
			for x in range(data.grid_width):
				var slot = slot_scene.instantiate() as InventorySlotUI
				slot.custom_minimum_size = slot_size
				var slot_data = data.grid[y][x]
				var item = slot_data.item
				var is_origin = slot_data.is_origin
				slot.set_slot_item(item, is_origin)
				grid_container.add_child(slot)

func updateInventoryFreeSlots(data: InventoryData):
	free_slots_grid_container.columns = data.grid_width

	for child in free_slots_grid_container.get_children():
		child.queue_free()
	
	for y in range(data.grid_height + 1):
		for x in range(data.grid_width):
			var free_slot_scene = free_slot_scene.instantiate()  as InventoryFreeSlot
			if y == 0 and x == 0:
				free_slot_scene.set_free_slot(false, false)
			elif y == 0 and x > 0:
				free_slot_scene.set_free_slot(true, true)
			else:
				free_slot_scene.set_free_slot(true, false)
			
			free_slots_grid_container.add_child(free_slot_scene)
