class_name InventoryService

var inventoryModel: InventoryModel

func init() -> void:
	inventoryModel = InventoryModel.new()

func get_item_by_id(itemId: int) -> InventoryItemModel:
	for item in inventoryModel.items:
		if item.id == itemId:
			return item
	return null

func get_inventory_model() -> InventoryModel:
	return inventoryModel
