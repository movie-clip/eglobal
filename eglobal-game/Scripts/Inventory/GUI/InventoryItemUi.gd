extends Control
class_name InventoryItemUi

var red_color: Color = Color("ff003b65")
var green_color: Color = Color("07cc0865")
var is_possible_place_item: bool
var is_placed: bool

@export var item_areas: Array[Area2D]
@export var colored_slots: Array[ColorRect]
var item_ui_data: Array[InventoryItemUiData]
var slots_collision_ui_data: Array[Area2D]

func _ready() -> void:
	if item_areas.is_empty():
		print("Areas is empty. Set area!")
		return
	if colored_slots.is_empty():
		print("Colored slots is empty. Set colored slots!")
		return
	if item_areas.size() != colored_slots.size():
		print("Colored slots count not equal area count!!!")
		return
	for colored_slot in colored_slots:
			colored_slot.visible = false
	item_ui_data.resize(item_areas.size())
	slots_collision_ui_data.resize(item_areas.size())
	for i in range(item_areas.size()):
		var _item_ui_data: InventoryItemUiData = InventoryItemUiData.new()
		_item_ui_data.area_num = i
		_item_ui_data.area = item_areas[i]
		_item_ui_data.is_correct_area = false
		item_ui_data[i] = _item_ui_data
	
	for data: InventoryItemUiData in item_ui_data:
		data.area.area_entered.connect(item_inside_inventory_slot.bind(data))
	
	self.gui_input.connect(select_item)
	self.gui_input.connect(on_item_hover.bind(self))
	SignalBus.hover_item_on_slot.connect(update_crossed_slots)

func update_crossed_slots(_Control: Control):
	for data: InventoryItemUiData in item_ui_data:
			if data.area.overlaps_area(slots_collision_ui_data[data.area_num]):
				var slot_ui: InventorySlotUI = slots_collision_ui_data[data.area_num].get_parent() as InventorySlotUI
				if slot_ui.inventory_slot.is_free:
					colored_slots[data.area_num].color = green_color
				else:
					colored_slots[data.area_num].color = red_color
			else:
				colored_slots[data.area_num].color = red_color

func update_inventory_slots_ui():
	if is_placed:
		for data: InventoryItemUiData in item_ui_data:
			if data.area.overlaps_area(slots_collision_ui_data[data.area_num]):
				var slot_ui: InventorySlotUI = slots_collision_ui_data[data.area_num].get_parent() as InventorySlotUI
				slot_ui.inventory_slot.is_free = false
	else:
		for data: InventoryItemUiData in item_ui_data:
			if data.area.overlaps_area(slots_collision_ui_data[data.area_num]):
				var slot_ui: InventorySlotUI = slots_collision_ui_data[data.area_num].get_parent() as InventorySlotUI
				slot_ui.inventory_slot.is_free = true

func on_item_hover(Event: InputEvent, ControlItem: Control):
	if Event.is_pressed():
		print("try marge")
		#SignalBus.select_slot_for_item.emit(self)
	else:
		SignalBus.hover_item_on_item.emit(self)

func try_marge_item(Item: Control):
	pass

func select_item(Event: InputEvent):
	if Event.is_pressed():
		self.mouse_filter = MOUSE_FILTER_IGNORE
		self.z_index = 2
		is_placed = false
		for colored_slot in colored_slots:
			colored_slot.visible = true
		update_inventory_slots_ui()

func place_item():
	self.mouse_filter = MOUSE_FILTER_STOP
	self.z_index = 1
	is_placed = true
	for colored_slot in colored_slots:
			colored_slot.visible = false
	update_inventory_slots_ui()

func item_inside_inventory_slot(InsideArea: Area2D, ItemUiDataData: InventoryItemUiData):
	var _InventorySlot: InventorySlotUI = InsideArea.get_parent() as InventorySlotUI
	if _InventorySlot == null:
		var _Insideitem: InventoryItemUi = InsideArea.get_parent() as InventoryItemUi
		if _Insideitem != null:
			if !is_placed:
				colored_slots[ItemUiDataData.area_num].color = red_color
				ItemUiDataData.is_correct_area = false
	else:
		if !_InventorySlot.inventory_slot.is_extra and !_InventorySlot.inventory_slot.is_locked and _InventorySlot.inventory_slot.is_free:
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
