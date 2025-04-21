extends Resource
class_name InventoryResourceTable

@export var view_models: Array = [InventoryItemViewModel]

func get_viewModel(item_type: int, item_level: int) -> InventoryItemViewModel:
	for item: InventoryItemViewModel in view_models:
		if item.itemType == item_type and item.itemLevel == item_level:
			return item
	return null
