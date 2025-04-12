extends Node
class_name InventoryController

var data: InventoryData
const  inventoryDataRank = preload("res://Authoring/Inventory/Rank/InventoryDataRank6.tres")
#@export var ui: InventoryUI

#@export var grid_width: int = 10
#@export var grid_height: int = 6

func init():
	if inventoryDataRank == null:
		print("Set InventoryDataRank")
	data = inventoryDataRank
	if data.grid.is_empty():
		_initialize_grid()
	#ui.itit_inventory(data)

func unlock_extra_slot():
	for slot: InventorySlot in data.grid[0]:
		if slot.is_locked == false and slot.is_extra == true:
			slot.is_extra = false
			#ui.updateInventory(data)
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
