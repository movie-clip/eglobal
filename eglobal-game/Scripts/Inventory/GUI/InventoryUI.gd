extends Control
class_name InventoryUI

var is_item_selected: bool = false
var is_item_moved: bool = false
var selected_item_control: Control
@onready var inventory_controller: InventoryController = $InventoryController
#@onready var stash_container: HBoxContainer = $InventoryStashUiRoot/HBoxContainer/HBoxContainer
@onready var items_container: Control = $ItemsContainer
#For tests
@onready var TestButtonUnlockFreeSlot = $TestButtonUnlockFreeSlot
var is_drag_item: bool = false
var is_drag_on_slot: bool = false
#var last_clot: Control
var last_inventory_slot: Control
var all_items: Array[InventoryItemUi]

func _ready():
	await get_tree().process_frame  # Ensure inventory is ready
	inventory_controller.init()
	TestButtonUnlockFreeSlot.pressed.connect(inventory_controller.unlock_extra_slot)
	#SignalBus.select_slot_for_item.connect(on_seted_item_in_slot)
	SignalBus.hover_item_on_slot.connect(on_hover_item_on_slot)
	SignalBus.hover_item_on_item.connect(on_hover_item_on_item)
	SignalBus.select_item.connect(on_select_item)
	SignalBus.out_item_of_slot.connect(on_out_item_of_slot)

func _input(Event: InputEvent):
	if Event is InputEventMouseButton: # or InputEventScreenTouch
		if Event.button_index == MOUSE_BUTTON_LEFT and Event.pressed:
			print("drag")
			is_drag_item = true
			#start_dragging(Event.position)
		else:
			print("drop")
			if is_item_selected and selected_item_control != null:
				on_seted_item_in_slot()
	elif Event is InputEventMouse:
		change_item_position(Event.position)

func on_out_item_of_slot(SlotControl: Control):
	#is_drag_on_slot = false
	if last_inventory_slot != null and last_inventory_slot == SlotControl:
		last_inventory_slot = null

func on_select_item(ItemControl: Control):
	if !is_item_selected and selected_item_control == null and is_item_moved == false:
		is_item_selected = true
		selected_item_control = ItemControl
		selected_item_control.rotation = 0
		var item_ui: InventoryItemUi = selected_item_control as InventoryItemUi
		inventory_controller.free_slots_after_select_item(item_ui.item_ui_data)
	elif is_item_selected and selected_item_control != null:
		var item_ui: InventoryItemUi = ItemControl as InventoryItemUi
		if item_ui != null:
			if item_ui.is_merged:
				selected_item_control.queue_free()
				item_ui.try_marge_item()
				selected_item_control = null
				is_item_selected = false

func change_item_position(GlobalPosition: Vector2):
	if selected_item_control and is_item_selected:# and is_item_moved == false and is_drag_item == true and is_drag_on_slot == false:
		var item_ui: InventoryItemUi = selected_item_control as InventoryItemUi
		if last_inventory_slot != null:
			selected_item_control.global_position = last_inventory_slot.global_position
			
		else:
			var pos_offset: Vector2 = Vector2(21, 21)#Vector2(selected_item_control.size.x / 2, selected_item_control.size.y / 2)
			selected_item_control.global_position = GlobalPosition - pos_offset
		inventory_controller.update_collisions(item_ui.item_ui_data)
		#var item_ui: InventoryItemUi = selected_item_control as InventoryItemUi
		#inventory_controller.update_slots_collisions(item_ui.item_ui_data, false)

func on_hover_item_on_item(SlotControl: Control):
	if selected_item_control and is_item_selected:# and is_item_moved == false and is_drag_item == true:
		update_slots_collisions_for_item()
		#last_clot = SlotControl
		#is_item_moved = true
		#var tween = get_tree().create_tween()
		#tween.tween_property(selected_item_control, "global_position", SlotControl.global_position, 0.1)
		#tween.tween_callback(update_slots_collisions_for_item)

func on_hover_item_on_slot(SlotControl: Control):
	if selected_item_control and is_item_selected:# and is_item_moved == false and is_drag_item == true:
		last_inventory_slot = SlotControl
		var item_ui: InventoryItemUi = selected_item_control as InventoryItemUi
		var item_ui_textute: Control = item_ui.itemSprite as Control
		#is_drag_on_slot = true
		#is_item_moved = true
		#selected_item_control.global_position = SlotControl.global_position
		#update_slots_collisions_for_slots()
		var tween = get_tree().create_tween()
		tween.tween_property(item_ui_textute, "global_position", SlotControl.global_position, 0.1)
		#tween.tween_callback(update_slots_collisions_for_slots)

func update_slots_collisions_for_slots():
	var item_ui: InventoryItemUi = selected_item_control as InventoryItemUi
	inventory_controller.update_collisions(item_ui.item_ui_data)
	#inventory_controller.update_slots_collisions(item_ui.item_ui_data, false)
	#is_item_moved = false

func update_slots_collisions_for_item():
	#TODO change visual of item if merge is possible
	var item_ui: InventoryItemUi = selected_item_control as InventoryItemUi
	inventory_controller.update_slots_collisions(item_ui.item_ui_data, false)
	#is_item_moved = false

#func remove_iten_in_stash(Item: Control):
	#var tween = get_tree().create_tween()
	#tween.tween_property(Item, "global_position", stash_container.global_position, 0.2)
	#tween.tween_callback(revert_item_parent.bind(Item))
	
	#var tween = get_tree().create_tween()
	#tween.tween_property(selected_item_control, "position", Vector2(stash_container.position.x + stash_container.size.x, stash_container.position.y), 0.3)
	#selected_item_control.position = Vector2.ZERO
	#is_item_selected = false
	#selected_item_control = null
	#is_drag_item = false

#func revert_item_parent(Item: Control):
	#var item_ui: InventoryItemUi = Item as InventoryItemUi
	#item_ui.disable_view_item_slot()
	#Item.get_parent().remove_child(Item)
	#stash_container.add_child(Item)
	#Item.set_owner(stash_container)
	#calculate_items_size()
	#inventory_controller.to_free_inventory_slots()

#func calculate_items_size():
	#var items: Array = stash_container.get_children()
	#var last_item_size = items.back().size.x
	#var stash_width = stash_container.size.x
	#var last_item_ui: InventoryItemUi = items.back() as InventoryItemUi
	#var new_last_item_size = last_item_ui.itemData.shape.width * 42
	#var new_stash_width = stash_width - new_last_item_size
	#print(stash_width)
	#print(new_stash_width)
	#items.back().size.x = new_last_item_size
	#for i in range(items.size()):
		#if i < items.size():
			#var new_size = (new_stash_width / items.size() + 2)
			#items[i].custom_minimum_size.x = new_size
			#items[i].size.x = new_size


func add_iten_in_items_container(Item: Control):
	var pos = Item.global_position
	#if last_clot != null:
	#	pos = last_clot.global_position
	var item_parent = Item.get_parent()
	item_parent.remove_child(Item)
	print(item_parent.name)
	items_container.add_child(Item)
	Item.global_position = pos

func check_collision_with_items(Item: InventoryItemUi):
	print("!!!")
	for item_ui in all_items:
		if item_ui != null and Item != null:
			for ui_data in Item.item_ui_data:
				for area_data in item_ui.item_ui_data:
					if ui_data.area.overlaps_area(area_data.area):
						#remove_iten_in_stash(item_ui as Control)
						SignalBus.remove_iten_in_stash.emit(item_ui as Control)

func on_seted_item_in_slot():#(SlotControl: Control):
	if selected_item_control and is_item_selected and is_item_moved == false:
		
		var item_ui: InventoryItemUi = selected_item_control as InventoryItemUi
		if item_ui.possible_place_item() == true:
			item_ui.place_item()
			add_iten_in_items_container(selected_item_control)
			inventory_controller.update_slots_collisions(item_ui.item_ui_data, true)
			all_items.append(item_ui)
			is_item_selected = false
			selected_item_control = null
			is_drag_item = false
			is_item_moved == false
		else:
			check_collision_with_items(selected_item_control as InventoryItemUi)
			#remove_iten_in_stash(selected_item_control)
			SignalBus.remove_iten_in_stash.emit(item_ui as Control)
			is_item_selected = false
			selected_item_control = null
			is_drag_item = false
			is_item_moved == false
