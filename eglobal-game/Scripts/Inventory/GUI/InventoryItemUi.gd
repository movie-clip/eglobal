extends Control
class_name InventoryItemUi

@export var itemSprite: TextureRect
@export var base_areas: Array
@export var base_slots: Array
var item_ui_data: Array[InventoryItemUiData]
var is_possible_place_item: bool
var is_placed: bool
var is_merged: bool = true
#Test
var itemData: InventoryItemViewModel
var merge_color: Color = Color("ffff24")

func init(ItemData: InventoryItemViewModel) -> void:
	if base_areas.is_empty():
		print("Areas is empty. Set area!")
		return
	if base_slots.is_empty():
		print("Slots is empty. Set colored slots!")
		return
	itemData = ItemData
	itemSprite.texture = ItemData.texture
	var sprite_size_x: int = ItemData.shape.width * 42
	var sprite_size_y: int = ItemData.shape.height * 42
	itemSprite.custom_minimum_size = Vector2(sprite_size_x, sprite_size_y)
	itemSprite.set_size(Vector2(sprite_size_x, sprite_size_y), false)
	self.custom_minimum_size = Vector2(sprite_size_x, sprite_size_y)
	#self.set_size(Vector2(sprite_size_x, sprite_size_y), false)
	
	var elements_for_delete: Array[Node]
	var areas_for_work: Array[Area2D]
	var slots_for_work: Array[TextureRect]
	
	for y in range(base_areas.size()):
		for x in range(base_areas[y].size()):
			if ItemData.shape.origin_pos != Vector2(-1, -1):
				if (x == ItemData.shape.origin_pos.x and y < ItemData.shape.height) or (y == ItemData.shape.origin_pos.y and x < ItemData.shape.width):
					var node_area: Node = get_node(base_areas[y][x])
					areas_for_work.append(node_area as Area2D)
					var node_slot: Node = get_node(base_slots[y][x])
					slots_for_work.append(node_slot as TextureRect)
				else:
					var node_area: Node = get_node(base_areas[y][x])
					elements_for_delete.append(node_area)
					var node_slot: Node = get_node(base_slots[y][x])
					elements_for_delete.append(node_slot)
			else:
				if x < ItemData.shape.width and y < ItemData.shape.height:
					var node_area: Node = get_node(base_areas[x][y])
					areas_for_work.append(node_area as Area2D)
					var node_slot: Node = get_node(base_slots[x][y])
					slots_for_work.append(node_slot as TextureRect)
				else:
					var node_area: Node = get_node(base_areas[x][y])
					elements_for_delete.append(node_area)
					var node_slot: Node = get_node(base_slots[x][y])
					elements_for_delete.append(node_slot)
	
	for element_for_delete in elements_for_delete:
		element_for_delete.queue_free()
	
	item_ui_data.resize(slots_for_work.size())
	for i in range(slots_for_work.size()):
		var _item_ui_data: InventoryItemUiData = InventoryItemUiData.new()
		_item_ui_data.area_num = i
		_item_ui_data.area = areas_for_work[i]
		_item_ui_data.is_correct_area = false
		_item_ui_data.slot_texture = slots_for_work[i]
		_item_ui_data.slot_texture.z_index = -1
		_item_ui_data.slot_texture.gui_input.connect(check_click_on_item)
		_item_ui_data.slot_texture.mouse_entered.connect(check_hover_on_item.bind(_item_ui_data.slot_texture as Control))
		item_ui_data[i] = _item_ui_data
	
	for ui_data: InventoryItemUiData in item_ui_data:
		ui_data.area.area_entered.connect(collision_with_item)
		#ui_data.area.area_exited.connect(exit_item.bind(ui_data))
	#SignalBus.change_item_position.connect(update_crossed_slots)

func collision_with_item(InsideArea: Area2D):
	var parent = InsideArea.get_parent()
	var item_ui: InventoryItemUi = parent as InventoryItemUi
	if item_ui != null and is_placed == true:
		print("Inside item")

func check_click_on_item(Event: InputEvent):
	#print(Event)
	if Event.is_pressed():
		#if Event is InputEventMouse:
			#var _event: InputEventMouse = Event as InputEventMouse
			#if _event.is_action_released():
				#print(_event)
			#
		#print("Click on item slot")
		is_placed = false
		for ui_data in item_ui_data:
			ui_data.slot_texture.mouse_filter = MOUSE_FILTER_IGNORE
		self.mouse_filter = MOUSE_FILTER_IGNORE
		self.z_index = 2
		SignalBus.select_item.emit(self)
	#elif Event.is_released():
		#print("is_released")

func check_hover_on_item(SlotControl: Control):
	SignalBus.hover_item_on_item.emit(SlotControl)

func try_marge_item():
	print("MEGRE!!!")
	itemSprite.modulate = merge_color

func place_item():
	print("Place item")
	for ui_data in item_ui_data:
		ui_data.slot_texture.mouse_filter = MOUSE_FILTER_STOP
	self.mouse_filter = MOUSE_FILTER_IGNORE
	self.z_index = 1
	is_placed = true

func disable_view_item_slot():
	print("Remove iten in stash")
	for item_ui in item_ui_data:
		item_ui.slot_texture.texture = null
		item_ui.slot_texture.mouse_filter = MOUSE_FILTER_STOP
	self.mouse_filter = MOUSE_FILTER_IGNORE
	self.z_index = 1

func possible_place_item() -> bool:
	is_possible_place_item = true
	for item in item_ui_data:
		if item.is_correct_area == false:
			is_possible_place_item = false
	return is_possible_place_item
