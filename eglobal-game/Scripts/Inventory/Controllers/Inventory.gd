extends Node
class_name Inventory

@export var data: InventoryData
@export var ui: InventoryUI
@export var grid_width: int = 10
@export var grid_height: int = 6

func _ready() -> void:
	if data.grid.is_empty():
		_initialize_grid()
	ui.updateInventory(data)

func _initialize_grid():
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
