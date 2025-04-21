class_name InventoryStashController extends Control

const  item_ui_prefab = preload("res://Scenes/Inventory/inventory_item_ui.tscn")
@onready var stash_container: HBoxContainer = $HBoxContainer/HBoxContainer
#For tests
@onready var open_chest_button: Button = $"../TetstPanelControl/HBoxContainer/TestButtonOpenShest"
@onready var stash_button: Button = $"../TetstPanelControl/HBoxContainer/TestButtonStashOnOff"
var is_stash_on: bool = false

func _ready() -> void:
	open_chest_button.pressed.connect(generate_items)
	stash_button.pressed.connect(slider_change_animation)
	SignalBus.remove_iten_in_stash.connect(remove_iten_in_stash)
	self.visible = false

func slider_change_animation():
	for stash_item in stash_container.get_children():
		stash_item.free()
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, "size", Vector2.ZERO, 1)
	tween.tween_property(self, "custom_minimum_size", Vector2.ZERO, 1)
	tween.tween_callback(set_stash_visible).set_delay(1)
	#tween.chain().tween_property(_Texture, "scale", Vector2(1, 1), 0.1)

func set_stash_visible():
	self.visible = is_stash_on

func _process(delta: float) -> void:
	pass

func generate_items():
	for stash_item in stash_container.get_children():
		stash_item.free()
	#0-begin 4-center 8-end
	generate_item(4)
	generate_item(4)
	generate_item(4)
	generate_item(4)
	calculate_items_size()

func try_get_lucky_item():
	pass

func generate_lucky_items():
	pass

func generate_item(V_set: int):
	var item_type: int = randi_range(1, 26)
	var item_level: int = randi_range(1, 2)
	var item_view: InventoryItemViewModel = Global.inventoryDataProvider.table.get_viewModel(item_type, item_level)
	if item_view != null:
		var item = item_ui_prefab.instantiate()
		var item_ui = item as InventoryItemUi
		item_ui.init(item_view)
		item.size_flags_vertical = V_set
		stash_container.add_child(item)

func remove_iten_in_stash(Item: Control):
	var tween = get_tree().create_tween()
	tween.tween_property(Item, "global_position", stash_container.global_position, 0.2)
	tween.tween_callback(revert_item_parent.bind(Item))

func revert_item_parent(Item: Control):
	var item_ui: InventoryItemUi = Item as InventoryItemUi
	item_ui.disable_view_item_slot()
	Item.get_parent().remove_child(Item)
	stash_container.add_child(Item)
	Item.set_owner(stash_container)
	var item_v_flag: int = randi_range(0, 1)
	if item_v_flag == 0:
		Item.size_flags_vertical = 0
	else:
		Item.size_flags_vertical = 8
	calculate_items_size()
	var tween = get_tree().create_tween()
	tween.tween_property(Item, "rotation", 0.15, 0.2).set_trans(Tween.TRANS_CIRC)
	SignalBus.to_free_inventory_slots.emit()

func calculate_items_size():
	self.visible = true
	var items: Array = stash_container.get_children()
	var last_item_size = items.back().size.x
	var stash_width = stash_container.size.x
	var last_item_ui: InventoryItemUi = items.back() as InventoryItemUi
	var new_last_item_size = last_item_ui.itemData.shape.width * 42
	var new_stash_width = stash_width - new_last_item_size
	items.back().size.x = new_last_item_size
	var max_items_width = 0
	for item in items:
		var item_ui: InventoryItemUi = item as InventoryItemUi
		max_items_width += item_ui.itemData.shape.width * 42
	if max_items_width > stash_width:
		for i in range(items.size()):
			if i < items.size():
				var new_size = (new_stash_width / items.size())
				items[i].custom_minimum_size.x = new_size
				items[i].size.x = new_size
				#var cntrl: Control
				items[i].pivot_offset = Vector2(items[i].size.x / 2, items[i].size.y / 2)
	else:
		for i in range(items.size()):
			if i < items.size():
				var item_ui: InventoryItemUi = items[i] as InventoryItemUi
				var new_size = item_ui.itemData.shape.width * 42
				items[i].custom_minimum_size.x = new_size
				items[i].size.x = new_size
				items[i].pivot_offset = Vector2(items[i].size.x / 2, items[i].size.y / 2)
