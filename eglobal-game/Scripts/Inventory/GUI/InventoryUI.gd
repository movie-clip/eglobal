extends Control
class_name InventoryUI

@onready var slot_scene = preload("res://Scenes/Inventory/inventory_slot_ui.tscn")
@onready var grid_container: GridContainer = $InventoryCenterContainer/GridContainer
var all_slots: Array[InventorySlotUI]
var is_item_selected: bool = false
var selected_item_control: Control
#For tests
@onready var TestButtonUnlockFreeSlot = $TestButtonUnlockFreeSlot
@onready var TestBagLabel: Label = $TestBagLabel

func _ready():
	await get_tree().process_frame  # Ensure inventory is ready
	TestButtonUnlockFreeSlot.pressed.connect(Global.inventoryService.unlock_extra_slot)
	itit_inventory(Global.inventoryService.data)
	SignalBus.select_slot_for_item.connect(on_seted_item_in_slot)
	SignalBus.hover_item_on_slot.connect(on_hover_item_on_slot)
	SignalBus.hover_item_on_item.connect(on_hover_item_on_item)
	SignalBus.unlock_extra_slot.connect(updateInventory)
	SignalBus.select_item.connect(on_select_item)

func on_select_item(ItemControl: Control):
	if !is_item_selected and selected_item_control == null:
		is_item_selected = true
		selected_item_control = ItemControl
			#SignalBus.input_select_item.emit(ControlItem)

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

func updateInventory():
	var inventoryData: InventoryData = Global.inventoryService.data
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
	#self.data = data
	TestBagLabel.text = data.resource_name
	grid_container.columns = data.grid_width
	for child in grid_container.get_children():
		child.queue_free()
	var slot_size = Vector2(38, 38)
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
