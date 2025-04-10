extends Control
class_name Inventory

@export var data: InventoryData
@export var ui: InventoryUI
@export var grid_width: int = 10
@export var grid_height: int = 6

@onready var TestButtonUnlockFreeSlot = $TestButtonUnlockFreeSlot
@onready var TestBagLabel: Label = $TestBagLabel
@onready var TestItem: Control = $InventoryItemUiH2
@onready var TestItem2: Control = $InventoryItemUiH3
@onready var TestItem4: Control = $InventoryItemUiH4
@onready var TestItem5: Control = $InventoryItemUiT

var is_item_selected: bool = false
var selected_item_control: Control

func _ready() -> void:
	TestButtonUnlockFreeSlot.pressed.connect(unlock_extra_slot)
	TestBagLabel.text = data.resource_name
	add_signal_connections(TestItem)
	add_signal_connections(TestItem2)
	add_signal_connections(TestItem4)
	add_signal_connections(TestItem5)
	SignalBus.select_slot_for_item.connect(on_seted_item_in_slot)
	SignalBus.hover_item_on_slot.connect(on_hover_item_on_slot)
	SignalBus.hover_item_on_item.connect(on_hover_item_on_item)
	
	if data.grid.is_empty():
		_initialize_grid()
	ui.updateInventory(data)

func on_hover_item_on_item(SlotControl: Control):
	if selected_item_control and is_item_selected:
		selected_item_control.global_position = SlotControl.global_position

func on_hover_item_on_slot(SlotControl: Control):
	if selected_item_control and is_item_selected:
		selected_item_control.global_position = SlotControl.global_position

func on_seted_item_in_slot(SlotControl: Control):
	if is_item_selected:
		var item_ui: InventoryItemUi = selected_item_control as InventoryItemUi
		if item_ui.possible_place_item() == true:
			item_ui.place_item()
			is_item_selected = false
			selected_item_control = null
			#selected_item_control.get_parent().remove_child(selected_item_control)
			#SlotControl.add_child(selected_item_control)
			#selected_item_control.set_owner(SlotControl)
			#selected_item_control.position = Vector2.ZERO
		else:
			print("!!!")

func unlock_extra_slot() -> void:
	for slot: InventorySlot in data.grid[0]:
		if slot.is_locked == false and slot.is_extra == true:
			slot.is_extra = false
			ui.updateInventory(data)
			print("unlock free slot")
			return
	print("all extra slots ulocked")

func add_signal_connections(ControlItem: Control):
	ControlItem.gui_input.connect(on_item_hover.bind(ControlItem))

func on_item_hover(Event: InputEvent, ControlItem: Control):
	if Event.is_pressed():
		if !is_item_selected and selected_item_control == null:
			is_item_selected = true
			selected_item_control = ControlItem
			#SignalBus.input_select_item.emit(ControlItem)

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
