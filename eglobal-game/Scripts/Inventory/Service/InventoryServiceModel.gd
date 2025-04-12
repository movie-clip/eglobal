class_name InventoryServiceModel

var inventoryModel: InventoryModel

func _init() -> void:
	inventoryModel = InventoryModel.new()
	#load inventory from res

func get_item_by_id(itemId: int) -> InventoryItemModel:
	for item in inventoryModel.items:
		if item.id == itemId:
			return item
	return null

func get_inventory_model(item: int) -> InventoryModel:
	return inventoryModel