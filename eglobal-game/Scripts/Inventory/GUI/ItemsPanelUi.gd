extends Control
class_name  ItemsPanelUi

@onready var container: HBoxContainer = $HBoxContainer
@export var inventory_items_ui: Array = []

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func update_items(Data) -> void:
	for child in container.get_children():
		child.queue_free()
