class_name InventoryDataProvider

var table: InventoryResourceTable

func init() -> void:
	table = load("res://Authoring/Inventory/Service/InventoryResourceTable.tres")

func create_view_model(model:InventoryItemModel) -> InventoryItemViewModel:
	var viewModel: InventoryItemViewModel = table.get_viewModel(model.itemType)
	if viewModel != null:
		viewModel.itemName = model.itemName
		return viewModel
	return null
