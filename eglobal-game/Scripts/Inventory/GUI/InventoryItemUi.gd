extends Control
class_name InventoryItemUi

var red_color: Color = Color("ff003b65")
var green_color: Color = Color("07cc0865")
var alpha_color: Color = Color("ffffff00")
var is_possible_place_item: bool
var is_placed: bool

#Test
@export var itemData: InventoryItem
@export var itemShape: InventoryShape

@export var base_areas: Array
@export var base_colored_slots: Array

@export var item_areas: Array[Area2D]
@export var colored_slots: Array[ColorRect]
var item_ui_data: Array[InventoryItemUiData]
var slots_collision_ui_data: Array[Area2D]

@onready var itemSprite: TextureRect = $ItemTextureRect

func _ready() -> void:
	if base_areas.is_empty():
		print("Areas is empty. Set area!")
		return
	if base_colored_slots.is_empty():
		print("Colored slots is empty. Set colored slots!")
		return
	
	for base_area_y in base_areas:
		for base_area_x: NodePath in base_area_y:
			var node: Node = get_node(base_area_x)  
			node.set_process_mode(Node.PROCESS_MODE_DISABLED)
	
	for base_colored_slot_y in base_colored_slots:
		for base_colored_slot_x: NodePath in base_colored_slot_y:
			var node: ColorRect = get_node(base_colored_slot_x)
			node.set_process_mode(Node.PROCESS_MODE_DISABLED)
			node.visible = false
	
	item_areas.clear()
	colored_slots.clear()
	
	itemSprite.texture = itemData.texture
	
	var elements_for_delete: Array[Node]
	
	for y in range(base_areas.size()):#(itemData.shape.height):
		for x in range(base_areas[y].size()):
			if itemData.shape.origin_pos != Vector2.ZERO:
				if x == itemData.shape.origin_pos.x or y == itemData.shape.origin_pos.y:
					var node_area: Node = get_node(base_areas[x][y])
					item_areas.append(node_area as Area2D)
					var node_colored_slot: Node = get_node(base_colored_slots[x][y])
					colored_slots.append(node_colored_slot as ColorRect)
				else:
					var node_area: Node = get_node(base_areas[x][y])
					elements_for_delete.append(node_area)
					var node_colored_slot: Node = get_node(base_colored_slots[x][y])
					elements_for_delete.append(node_colored_slot)
			else:
				if x < itemData.shape.width and y < itemData.shape.height:
					var node_area: Node = get_node(base_areas[y][x])
					item_areas.append(node_area as Area2D)
					var node_colored_slot: Node = get_node(base_colored_slots[y][x])
					colored_slots.append(node_colored_slot as ColorRect)
				else:
					var node_area: Node = get_node(base_areas[y][x])
					elements_for_delete.append(node_area)
					var node_colored_slot: Node = get_node(base_colored_slots[y][x])
					elements_for_delete.append(node_colored_slot)
	
	for element_for_delete in elements_for_delete:
		element_for_delete.queue_free()
	
	for colored_slot: ColorRect in colored_slots:
		colored_slot.visible = true
		colored_slot.set_process_mode(Node.PROCESS_MODE_INHERIT)
	
	item_ui_data.resize(item_areas.size())
	slots_collision_ui_data.resize(item_areas.size())
	for i in range(item_areas.size()):
		var _item_ui_data: InventoryItemUiData = InventoryItemUiData.new()
		item_areas[i].set_process_mode(Node.PROCESS_MODE_INHERIT)
		_item_ui_data.area_num = i
		_item_ui_data.area = item_areas[i]
		_item_ui_data.is_correct_area = false
		item_ui_data[i] = _item_ui_data
	
	for data: InventoryItemUiData in item_ui_data:
		data.area.area_entered.connect(item_inside_inventory_slot.bind(data))
	
	#self.gui_input.connect(select_item)
	#self.gui_input.connect(on_item_hover.bind(self))
	SignalBus.hover_item_on_slot.connect(update_crossed_slots)
	
	for colored_slot in colored_slots:
		colored_slot.gui_input.connect(check_click_on_item)

func check_click_on_item(Event: InputEvent):
	if Event.is_pressed():
		for colored_slot in colored_slots:
			colored_slot.mouse_filter = MOUSE_FILTER_IGNORE
		self.mouse_filter = MOUSE_FILTER_IGNORE
		self.z_index = 2
		is_placed = false
		for colored_slot in colored_slots:
			colored_slot.color = alpha_color
		update_inventory_slots_ui()
		SignalBus.select_item.emit(self)
	else:
		print("Hover on colored slot")

func update_crossed_slots(_Control: Control):
	if !is_placed:
		for data: InventoryItemUiData in item_ui_data:
			if slots_collision_ui_data[data.area_num] != null:
				if data.area.overlaps_area(slots_collision_ui_data[data.area_num]):
					var slot_ui: InventorySlotUI = slots_collision_ui_data[data.area_num].get_parent() as InventorySlotUI
					if slot_ui.inventory_slot.is_free:
						colored_slots[data.area_num].color = green_color
					else:
						colored_slots[data.area_num].color = red_color
						data.is_correct_area = false
				else:
					colored_slots[data.area_num].color = red_color
					data.is_correct_area = false

func update_inventory_slots_ui():
	if is_placed:
		for data: InventoryItemUiData in item_ui_data:
			if data.area.overlaps_area(slots_collision_ui_data[data.area_num]):
				var slot_ui: InventorySlotUI = slots_collision_ui_data[data.area_num].get_parent() as InventorySlotUI
				slot_ui.inventory_slot.is_free = false
	else:
		for data: InventoryItemUiData in item_ui_data:
			if slots_collision_ui_data[data.area_num] != null and data.area.overlaps_area(slots_collision_ui_data[data.area_num]):
				var slot_ui: InventorySlotUI = slots_collision_ui_data[data.area_num].get_parent() as InventorySlotUI
				slot_ui.inventory_slot.is_free = true

#func on_item_hover(Event: InputEvent, ControlItem: Control):
	#if Event.is_pressed():
		#print("try marge")
		##SignalBus.select_slot_for_item.emit(self)
	#else:
		#SignalBus.hover_item_on_item.emit(self)

#func try_marge_item(Item: Control):
	#pass

#func select_item(Event: InputEvent):
	#if Event.is_pressed():
		#self.mouse_filter = MOUSE_FILTER_IGNORE
		#self.z_index = 2
		#is_placed = false
		#for colored_slot in colored_slots:
			#colored_slot.visible = true
		#update_inventory_slots_ui()

func place_item():
	for colored_slot in colored_slots:
			colored_slot.mouse_filter = MOUSE_FILTER_STOP
			colored_slot.color = alpha_color
	#self.mouse_filter = MOUSE_FILTER_STOP
	self.z_index = 1
	is_placed = true
	update_inventory_slots_ui()

func item_inside_inventory_slot(InsideArea: Area2D, ItemUiDataData: InventoryItemUiData):
	var inventorySlot: InventorySlotUI = InsideArea.get_parent() as InventorySlotUI
	if inventorySlot == null:
		var _Insideitem: InventoryItemUi = InsideArea.get_parent() as InventoryItemUi
		if _Insideitem != null:
			print("on item")
			if !is_placed:
				colored_slots[ItemUiDataData.area_num].color = red_color
				ItemUiDataData.is_correct_area = false
	else:
		if !inventorySlot.inventory_slot.is_extra and !inventorySlot.inventory_slot.is_locked and inventorySlot.inventory_slot.is_free:
			colored_slots[ItemUiDataData.area_num].color = green_color
			ItemUiDataData.is_correct_area = true
			var slot_area: Area2D = InsideArea
			slots_collision_ui_data[ItemUiDataData.area_num] = slot_area
		else:
			colored_slots[ItemUiDataData.area_num].color = red_color
			ItemUiDataData.is_correct_area = false

func possible_place_item() -> bool:
	is_possible_place_item = true
	for item in item_ui_data:
		if item.is_correct_area == false:
			is_possible_place_item = false
	return is_possible_place_item
