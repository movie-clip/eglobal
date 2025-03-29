extends Control
class_name MetaController

@onready var inventory: Inventory = $Inventory
@onready var inventory_ui: InventoryUI = inventory.get_node("InventoryUI")
@onready var add_button: Button = $Button

func _ready() -> void:
	print("Ready")
	add_button.pressed.connect(_on_start_btn_pressed)

func _on_start_btn_pressed() -> void:
	print("Button Clicked!")
	var items = [
		preload("res://Authoring/Inventory/Items/shield_item.tres"),
		preload("res://Authoring/Inventory/Items/sword_item.tres")
	]
	var item = items[randi() % items.size()]
	inventory.place_item(item)
	inventory_ui.updateView()
	
	
	
