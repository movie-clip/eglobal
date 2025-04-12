extends Resource
class_name InventoryResourceTable

@export var view_models: Array = [InventoryItemViewModel]

func get_viewModel(item_type: int) -> InventoryItemViewModel:
	for item in view_models:
		if item.itemType == item_type:
			return item
	return null
	
		
	
