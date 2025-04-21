extends Node
class_name InventoryController

const  inventoryDataRank = preload("res://Authoring/Inventory/Rank/InventoryDataRank6.tres")
@onready var slot_scene = preload("res://Scenes/Inventory/inventory_slot_ui.tscn")
@onready var grid_container: GridContainer = $SlotsContainer
var data: InventoryData
var all_slots: Array[InventorySlotUI]

@export var normal_slot_texture: Texture
@export var locked_slot_texture: Texture

func init():
	if inventoryDataRank == null:
		print("Set InventoryDataRank")
	data = inventoryDataRank
	if data.grid.is_empty():
		_initialize_grid()
	itit_inventory(data)
	SignalBus.unlock_extra_slot.connect(updateInventory)
	SignalBus.to_free_inventory_slots.connect(to_free_inventory_slots)

func to_free_inventory_slots():
	for slot: InventorySlotUI in all_slots:
		var areas: Array[Area2D] = slot.area.get_overlapping_areas()
		if areas.is_empty():
			slot.inventory_slot.is_free = true
		else:
			print(areas)

func update_collisions(ItemSlots: Array[InventoryItemUiData]):
	for item_slot in ItemSlots:
		var collision_areas: Array[Area2D] = item_slot.area.get_overlapping_areas()
		if collision_areas.is_empty():
			print("collision_areas.is_empty")
			item_slot.slot_texture.texture = locked_slot_texture
			item_slot.is_correct_area = false
		else:
			for collision_area in collision_areas:
				var collision_parent = collision_area.get_parent()
				var try_slot_ui: InventorySlotUI = collision_parent as InventorySlotUI
				if try_slot_ui != null:
					if try_slot_ui.inventory_slot.is_extra or try_slot_ui.inventory_slot.is_locked or try_slot_ui.inventory_slot.is_free == false:
						item_slot.slot_texture.texture = locked_slot_texture
						item_slot.is_correct_area = false
					else:
						item_slot.slot_texture.texture = normal_slot_texture
						item_slot.is_correct_area = true
				else:
					var try_item_ui: InventoryItemUi = collision_parent as InventoryItemUi
					if try_item_ui != null:
						item_slot.slot_texture.texture = locked_slot_texture
						item_slot.is_correct_area = false

func update_slots_collisions(ItemSlots: Array[InventoryItemUiData], IsPlaced: bool):
	for item_slot in ItemSlots:
		item_slot.is_correct_area = false
		item_slot.slot_texture.texture = locked_slot_texture
	for slot in all_slots:
		for item_slot in ItemSlots:
			if slot.area.overlaps_area(item_slot.area) == true:
				if slot.inventory_slot.is_extra == false and slot.inventory_slot.is_locked == false and slot.inventory_slot.is_free == true:
					item_slot.is_correct_area = true
					item_slot.slot_texture.texture = normal_slot_texture
					if IsPlaced:
						slot.inventory_slot.is_free = false
					else:
						slot.inventory_slot.is_free = true
				else:
					item_slot.is_correct_area = false
					item_slot.slot_texture.texture = locked_slot_texture

func free_slots_after_select_item(ItemSlots: Array[InventoryItemUiData]):
	for item_slot in ItemSlots:
		item_slot.is_correct_area = false
		item_slot.slot_texture.texture = locked_slot_texture
	for slot in all_slots:
		for item_slot in ItemSlots:
			if slot.area.overlaps_area(item_slot.area) == true:
				if slot.inventory_slot.is_extra == false and slot.inventory_slot.is_locked == false:
					slot.inventory_slot.is_free = true
					item_slot.is_correct_area = true
					item_slot.slot_texture.texture = normal_slot_texture

func update_slots_if_place_item():
	pass

func updateInventory():
	var inventoryData: InventoryData = data
	var data_arr: Array[InventorySlot]
	if inventoryData.grid_extra > 0:
		for y in range(inventoryData.grid_height + 1):
			for x in range(inventoryData.grid_width):
				data_arr.append(inventoryData.grid[y][x])
	else:
		for y in range(inventoryData.grid_height):
			for x in range(inventoryData.grid_width):
				data_arr.append(inventoryData.grid[y][x])
	for i in range(all_slots.size()):
		all_slots[i].update_slot(data_arr[i])

func itit_inventory(data: InventoryData):
	if data == null:
		push_error("Inventory or InventoryData not assigned.")
		return
	grid_container.columns = data.grid_width
	for child in grid_container.get_children():
		child.queue_free()
	var slot_size = Vector2(42, 42)
	if data.grid_extra > 0:
		for y in range(data.grid_height + 1):
			for x in range(data.grid_width):
				var slot = slot_scene.instantiate() as InventorySlotUI
				slot.custom_minimum_size = slot_size
				var slot_data: InventorySlot = data.grid[y][x]
				slot.set_slot(slot_data)
				all_slots.append(slot)
				grid_container.add_child(slot)
	else:
		for y in range(data.grid_height):
			for x in range(data.grid_width):
				var slot = slot_scene.instantiate() as InventorySlotUI
				slot.custom_minimum_size = slot_size
				var slot_data: InventorySlot = data.grid[y][x]
				slot.set_slot(slot_data)
				all_slots.append(slot)
				grid_container.add_child(slot)

func unlock_extra_slot():
	for slot: InventorySlot in data.grid[0]:
		if slot.is_locked == false and slot.is_extra == true:
			slot.is_extra = false
			SignalBus.unlock_extra_slot.emit()
			print("unlock free slot")
			return
	print("all extra slots ulocked")

func _initialize_grid():
	if data.grid_extra > 0:
		data.grid.resize(data.grid_height + 1)
		for y in range(data.grid_height + 1):
			data.grid[y] = []
			for x in range(data.grid_width):
				var slot: InventorySlot = InventorySlot.new()
				if x == 0 and y == 0 and data.grid_extra < data.grid_width:
					slot.is_locked = true
				if y == 0:
					slot.is_extra = true
				slot.is_free = true
				data.grid[y].append(slot)
	else:
		data.grid.resize(data.grid_height)
		for y in range(data.grid_height):
			data.grid[y] = []
			for x in range(data.grid_width):
				data.grid[y].append(InventorySlot.new())

func place_item(item: InventoryItem) -> bool:
	var pos = find_free_space(item)
	if pos == null:
		return false
	var shape = item.shape
	for y in range(shape.height):
		for x in range(shape.width):
			var slot = data.grid[pos.y + y][pos.x + x]
			slot.item = item
			slot.is_origin = (x == 0 and y == 0)
	return true

func find_free_space(item: InventoryItem) -> Variant:
	for y in range(data.grid_height):
		for x in range(data.grid_width):
			if can_place_item(item, Vector2(x, y)):
				return Vector2(x, y)
	return null

func can_place_item(item: InventoryItem, pos: Vector2) -> bool:
	var shape = item.shape
	for y in range(shape.height):
		for x in range(shape.width):
			var gx = pos.x + x
			var gy = pos.y + y
			if gx >= data.grid_width or gy >= data.grid_height:
				return false
			if data.grid[gy][gx].item != null:
				return false
	return true
